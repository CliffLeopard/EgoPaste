//
//  ModelExtension.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/11.
//

import Foundation
import Cocoa
import SwiftUI

extension Card {
    
    public var pastesArrayWithIndex:  Array<(Int,Paste)> {
        let set = pastes as? Set<Paste> ?? []
        let result = set.sorted {
            $0.wrappedPasteTime > $1.wrappedPasteTime
        }.enumerated()
        return Array(result)
    }
    
    public var pastesArray:  [Paste] {
        let set = pastes as? Set<Paste> ?? []
        return set.sorted {
            $0.wrappedPasteTime > $1.wrappedPasteTime
        }
    }
    
    func getPastes() -> [Paste] {
        return ((pastes?.allObjects ?? []) as! [Paste])
    }
}

extension Paste {
    convenience init(contents: [PasteContent]) {
        let entity = NSEntityDescription.entity(forEntityName: "Paste",
                                                in: PersistenceController.shared.viewContext)!
        self.init(entity: entity, insertInto: PersistenceController.shared.viewContext)
        self.createTime = Date()
        self.pasteTime = Date()
        self.pasteNum = 0
        self.color =  Int16(Int(arc4random() % UInt32(PASTE_COLORS.count)))
        contents.forEach(addToContents(_:))
    }
    
    func updateWithOldPaste(_ oldPaste: Paste) {
        self.createTime = oldPaste.createTime
        self.pasteNum += oldPaste.pasteNum + 1
        self.color = oldPaste.color
        self.pasteTime = Date()
    }
    
    public static func == (lhs: Paste, rhs: Paste) -> Bool {
        return lhs.getContents().count == rhs.getContents().count && lhs.supersedes(rhs)
    }
    
    func supersedes(_ item: Paste) -> Bool {
        return item.getContents().allSatisfy({ content in
            getContents().contains(where: { $0 == content})
        })
    }
    
    public var wrappedCreateTime: Date {
        self.createTime ?? Date()
    }
    
    public var wrappedPasteTime: Date {
        self.pasteTime ?? Date()
    }
    
    func loadImage() -> Data? {
        return contentData([.tiff, .png])
    }
    
    func loadString() -> String? {
        if let stringData = contentData([.string]){
            return String(data: stringData, encoding: .utf8)
        }
        return nil
    }
    
    private func isImage() -> Bool {
        return contentData([.tiff, .png]) != nil
    }
    
    private func isFile() -> Bool {
        return contentData([.fileURL]) != nil
    }
    
    private func isString() -> Bool {
        return contentData([.string]) != nil
    }
    
    
    func contentData(_ types: [NSPasteboard.PasteboardType]) -> Data? {
        let content = getContents().first(where: { content in
            return types.contains(NSPasteboard.PasteboardType(content.type!))
        })
        return content?.value
    }
    
    func getContents() -> [PasteContent] {
        return ((contents?.allObjects ?? []) as! [PasteContent])
    }
}

extension PasteContent {
    convenience init(type: String, value: Data?) {
        let entity = NSEntityDescription.entity(forEntityName: "PasteContent",
                                                in: PersistenceController.shared.viewContext)!
        self.init(entity: entity, insertInto: PersistenceController.shared.viewContext)
        self.type = type
        self.value = value
    }
    public static func == (lhs: PasteContent, rhs: PasteContent) -> Bool {
        return (lhs.type == rhs.type) && (lhs.value == rhs.value)
    }
}
