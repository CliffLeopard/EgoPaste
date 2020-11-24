//
//  ContentView.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/10.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.createTime, ascending: true)],
        animation: .default)
    var cards: FetchedResults<Card>
    
    @State var activeCardIndex: Int = 0
    @State var activePasteIndex: Int = 0
    @State var firstAppear: Bool = true
    @State var isSearching: Bool = false
    @State var searchText: String = ""
    
    private let headerHeight : CGFloat = 40
    
    var body: some View {
        VStack {
            HeaderView(
                activeCardIndex: self.$activeCardIndex,
                activePasteIndex: self.$activePasteIndex,
                searchText: self.$searchText,
                isSearching: self.$isSearching
                
            ).frame(minHeight:headerHeight,maxHeight: headerHeight,alignment: .bottom)
            
            PasteBoardView(
                activeCardIndex: self.$activeCardIndex,
                activePasteIndex: self.$activePasteIndex,
                isSearching: self.$isSearching,
                searchText: self.$searchText
            )
        }
        .padding(4.0)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
