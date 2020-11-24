//
//  DataBaseTestView.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/20.
//

import SwiftUI

struct DataBaseTestView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.createTime, ascending: true)],
        animation: .default)
    var cards: FetchedResults<Card>
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Paste.createTime, ascending: true)],
        animation: .default)
    var pastes: FetchedResults<Paste>
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PasteContent.value, ascending: true)],
        animation: .default)
    var contents: FetchedResults<PasteContent>
    
    var body: some View {
        VStack{
            HStack {
                Button("initData") {
                    initCardData()
                }
                
                Button(action: deleteCards) {
                    Label("Delete Cards", systemImage: "greetingcard")
                }
            }
            
            ForEach(pastes) { paste in
                if let textContent = paste.loadString() {
                    Text(textContent)
                        .onTapGesture {
                            deletePaste(paste)
                        }
                } else {
                    Text("Paste Empty")
                }
            }
        }
    }
    
    private func initCardData() {
        if(self.cards.isEmpty) {
            let card = Card(context: viewContext)
            card.name = "InitCardName"
            card.createTime = Date()
            card.frozen = true
            (1..<11).forEach { index in
                card.addToPastes(newPaste("PasteItem\(index)"))
            }
            try! viewContext.save()
        }
    }
    
    private func addPaste() {
        
    }
    
    private func deleteCards() {
        cards.forEach { card in
            viewContext.delete(card)
        }
        try! viewContext.save()
    }
    
    private func deletePaste(_ paste: Paste) {
        viewContext.delete(paste)
        try! viewContext.save()
    }
    
    
    private func newPaste(_ value: String) -> Paste {
        let paste = Paste(context: viewContext)
        paste.createTime = Date()
        paste.pasteTime = Date()
        paste.pasteNum = 1
        paste.color = Int16(Int(arc4random() % UInt32(PASTE_COLORS.count)))
        paste.addToContents([newPasteContent(value)])
        return paste
    }
    
    private func newPasteContent (_ value: String) -> PasteContent {
        let content = PasteContent(context: viewContext)
        content.type = NSPasteboard.PasteboardType.string.rawValue
        content.value = value.data(using: .utf8)!
        return content
    }
}
