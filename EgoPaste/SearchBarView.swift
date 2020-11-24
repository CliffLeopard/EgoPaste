//
//  SearchBarView.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/16.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    @State private var becomeFirstResponder = false
    
    var body: some View {
        
        return HStack {
            Button(action: {
                withAnimation {
                    self.isSearching.toggle()
                }
            }){
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(isSearching ? 6: 0)
            
            if self.isSearching {
                FocusTextField(
                    placeHolderString: NSLocalizedString("search_placeholder", comment: "Searching..."),
                    inputText: self.$searchText,
                    becomeFirstResponder: self.$becomeFirstResponder,
                    changeHandler: self.searchingChange,
                    beginHandler: self.searchBegin,
                    endHandler: self.searchEnd
                )
//                .overlay(
//                    HStack{
//                        Spacer()
//                        Button(action: {
//                            self.searchText = ""
//                        }) {
//                            Image(systemName: "multiply.circle.fill")
//                                .imageScale(.large)
//                                .foregroundColor(.gray)
//                                .padding(.trailing, 8)
//                        }
//                        .buttonStyle(BorderlessButtonStyle())
//                    }
//                )
                .textFieldStyle(PlainTextFieldStyle())
                .frame(maxWidth: 500)
                .onAppear {
                    self.becomeFirstResponder = true
                }
            }
        }.overlay(
            RoundedRectangle(cornerRadius: self.isSearching ? 6.0 : 0)
                .stroke(Color.blue, lineWidth: self.isSearching ? 2.0 : 0)
        )
    }
    
    func searchingChange(searchText: String){
        self.searchText = searchText
    }
    
    func searchBegin() {
        //        print("searchBegin")
    }
    
    func searchEnd(searchText: String) {
        //        print("searchEnd: \(searchText)")
    }
}

struct SearchBarView_Previews: PreviewProvider {
    @State static var searchText: String = ""
    @State static var isSearching: Bool = false
    static var previews: some View {
        SearchBarView(searchText: $searchText, isSearching: self.$isSearching)
    }
}
