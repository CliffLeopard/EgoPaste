//
//  Persistence.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/10.
//

import CoreData
import SwiftUI
import Carbon

struct PersistenceController {
    static var shared = PersistenceController(inMemory: false)
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let card = Card(context: viewContext)
            card.createTime = Date()
            card.name = "ClipBoard"
        }
        try! viewContext.save()
        return result
    }()
    
    
    let container: NSPersistentContainer
    let viewContext: NSManagedObjectContext
    let clipboard: Clipboard
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "EgoPaste")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        viewContext = container.viewContext
        clipboard = Clipboard(self.viewContext)
        clipboard.startListening()
    }
    
    func onNewCopy(_ paste: Paste) {
        if UserDefaults.standard.playSounds {
            NSSound(named: NSSound.Name("write"))?.play()
        }
        
        if let existingPaste = findSimilarItem(paste) {
            paste.updateWithOldPaste(existingPaste)
            if let cts = existingPaste.contents {
                existingPaste.removeFromContents(cts)
            }
            
            if let card = existingPaste.card {
                card.removeFromPastes(existingPaste)
            }
            self.viewContext.delete(existingPaste)
            try! self.viewContext.save()
        }
        cards[AppState.shared.activeCardIndex()].addToPastes(paste)
        try! self.viewContext.save()
    }
    
    // 找到历史记录中存在的粘贴板
    private func findSimilarItem(_ item: Paste) -> Paste? {
        var result : Paste?
        self.cards.forEach { card in
            card.getPastes().forEach { paste in
                if(paste == item) {
                    result = paste
                }
            }
        }
        return result
    }
    
    public var cards:[Card] {
        let fetchRequest = NSFetchRequest<Card>(entityName: "Card")
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Card.createTime), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    public func clearAll() {
        self.cards.forEach { card in
            
            if let pastesSet = card.pastes, let pastes = pastesSet as? Set<Paste> {
                for paste in pastes {
                    if let contentSet = paste.contents, let contents = contentSet as? Set<PasteContent> {
                        contents.forEach { content in
                            viewContext.delete(content)
                        }
                    }
                    viewContext.delete(paste)
                }
            }
            
            if !card.frozen {
                viewContext.delete(card)
            }
            
            do{
                try viewContext.save()
            } catch {
                print("clearAll failed")
            }
        }
    }
    
    public func paste() {
        if let paste = AppState.shared.getActivePaste() {
            NSApp.hide(nil)
            self.clipboard.copy(paste)
            self.clipboard.paste()
        }
    }
    
    public func initData() {
        if self.cards.count == 0 {
            let card = Card(context: viewContext)
            card.frozen = true
            card.createTime = Date()
            card.name = "EGO-CLPD"
            try? viewContext.save()
        }
    }
    
    public var pasteContents:[PasteContent] {
        let fetchRequest = NSFetchRequest<PasteContent>(entityName: "PasteContent")
        fetchRequest.sortDescriptors = []
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
}
