//
//  HeaderView.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/10.
//

import SwiftUI

struct HeaderView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.createTime, ascending: true)],
        animation: .default)
    private var cards: FetchedResults<Card>
    @Binding var activeCardIndex: Int
    @Binding var activePasteIndex: Int
    
    @State var isHover: Int = -1
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    private let hoverColor: Color = Color(.displayP3, white: 0.80, opacity: 0.50)
    private let selectedColor: Color = Color(.displayP3, white: 0.50, opacity: 0.60)
    
    var body: some View {
        HStack{
            Spacer()
            
            SearchBarView(searchText: $searchText, isSearching: $isSearching)
                .padding(6)
                .background(BackView(color: self.isHover == -2 ? hoverColor : Color.clear))
                .onHover { self.isHover =  $0 ? -2 : -1 }
            
            if !self.isSearching {
                ForEach(Array(self.cards.enumerated()), id: \.element){ (index,card) in
                    HStack{
                        Image(systemName: "circle.fill")
                            .imageScale(.small)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(index == activeCardIndex ? Color.blue : Color.orange)
                        Text(card.name!)
                    }
                    .padding(6)
                    .background(BackView(color: index == activeCardIndex ? selectedColor : (index == self.isHover ? hoverColor : Color.clear)))
                    .onHover { self.isHover =  $0 ? index : -1 }
                    .cornerRadius(3.0)
                    .onTapGesture {
                        activeCardIndex = index
                        activePasteIndex = 0
                    }
                    
                }.animation(.easeIn)
                
                Button(action: addCard){
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(6)
                .background(BackView(color: self.isHover == -3 ? hoverColor : Color.clear))
                .onHover { self.isHover =  $0 ? -3 : -1 }
            } else {
                Button(action: {
                    withAnimation {
                        self.isSearching = false
                    }
                }){
                    Image(systemName: "circle.fill")
                        .imageScale(.large)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(6)
                .background(BackView(color: self.isHover == -4 ? hoverColor : Color.clear))
                .onHover { self.isHover =  $0 ? -4 : -1 }
            }
            
            Spacer()
        }
    }
    
    private func addCard() {
        let card = Card(context: self.viewContext)
        card.frozen = false
        card.createTime = Date()
        card.name = "NewCLPD"
        try? self.viewContext.save()
    }
    
    private func deletePaste() {
        if cards.count > activeCardIndex && cards[activeCardIndex].pastes!.count > activePasteIndex  {
            viewContext.delete(cards[activeCardIndex].pastesArray[activePasteIndex])
            try! viewContext.save()
        }
    }
    
    private func deleteCard() {
        if cards.count > 1 && activeCardIndex != 1 {
            viewContext.delete(cards[1])
            try? viewContext.save()
        }
    }
}

//struct HeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderView()
//    }
//}
