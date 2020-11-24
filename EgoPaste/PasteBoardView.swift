//
//  PasteBoardView.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/10.
//

import SwiftUI
import KeyboardShortcuts
struct PasteBoardView: View {
    
    @Environment(\.managedObjectContext)
    private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.createTime, ascending: true)],
        animation: .default)
    var cards: FetchedResults<Card>
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Paste.pasteTime, ascending: false)],
        animation: .default)
    var allPastes: FetchedResults<Paste>
    
    
    @Binding var activeCardIndex: Int
    @Binding var activePasteIndex: Int
    @State var firstAppear: Bool = true
    
    @Binding var isSearching: Bool
    @Binding var searchText: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader{ proxy in
                if self.contentPastes.count == 0 {
                    Text(NSLocalizedString("empty_paste_board", comment: "This Paste Board Is Empty"))
                        .font(.largeTitle)
                        .scaledToFit()
                        .frame(width: NSScreen.main!.frame.width, height: 270, alignment: .center)
                        .foregroundColor(Color.gray)
                }
                
                LazyHStack(spacing: 15, pinnedViews: .sectionHeaders) {
                    ForEach(Array(self.contentPastes.enumerated()),id: \.0) {  (index,paste) in
                        PasteView(paste: paste)
                            .id(index)
                            .frame(width: 280, alignment: .center)
                            .background(Color.black)
                            .cornerRadius(5.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: activePasteIndex == index ? 8.0 : 0.0)
                                    .stroke(Color.blue, lineWidth: activePasteIndex == index ? 4.0 : 0.0)
                            )
                            .onTapGesture {
                                activePasteIndex = index
                                AppState.shared.updateActivePaste(paste)
                                PersistenceController.shared.paste()
                                self.activePasteIndex = 0
                            }
                    }
                }
                .padding(5)
                .onChange(of: activePasteIndex) { pst in
                    withAnimation{
                        proxy.scrollTo(pst)
                    }
                    
                }
            }
        }
        .onChange(of: self.activeCardIndex) { activeCard in
            AppState.shared.updateCardIndex(self.activeCardIndex)
        }
        .onAppear {
            if self.firstAppear {
                appear()
                firstAppear = false
            }
        }
    }
    
    private func appear() {
        KeyboardShortcuts.onKeyDown(for: .rightArrow) {
            if activePasteIndex < contentPastes.count - 1 {
                self.activePasteIndex = self.activePasteIndex + 1
            }
        }
        
        KeyboardShortcuts.onKeyDown(for: .leftArrow) {
            if activePasteIndex > 0 {
                self.activePasteIndex = self.activePasteIndex - 1
            }
        }
        
        KeyboardShortcuts.onKeyDown(for: .enter ) {
            if contentPastes.count > 0 {
                AppState.shared.updateActivePaste(contentPastes[self.activePasteIndex])
            }
            PersistenceController.shared.paste()
            self.activePasteIndex = 0
        }
        
        KeyboardShortcuts.onKeyDown(for: .search ) {
            self.isSearching = true
        }
        
        KeyboardShortcuts.onKeyDown(for: .escape ) {
            if self.isSearching {
                self.isSearching = false
            } else {
                NSApp.hide(nil)
            }
        }
        
        
        ShortcutsController.disableShortCut()
    }
    
    private var contentPastes: [Paste] {
        if isSearching {
            return allPastes.filter { paste in
                if self.searchText.isEmpty {
                    return true
                }
                
                if let pasteContent = paste.loadString() {
                    return pasteContent.contains(self.searchText)
                } else {
                    return false
                }
            }
        } else {
            if self.activeCardIndex < cards.count {
                return self.cards[self.activeCardIndex].pastesArray
            } else {
                return []
            }
           
        }
    }
}

//struct PasteBoardView_Previews: PreviewProvider {
//    @State static var preview_index = 0
//    static var previews: some View {
//        PasteBoardView(activeCardIndex: PasteBoardView_Previews.$preview_index)
//    }
//}
