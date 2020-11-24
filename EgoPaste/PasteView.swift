//
//  PasteView.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/10.
//

import SwiftUI

struct PasteView: View {
    
    var paste: Paste
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("文本")
                        .font(.title)
                    Text(self.timeGap).font(.subheadline)
                }.foregroundColor(Color.white)
                
                Spacer()
                
                Image(systemName: "timer")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
            }
            .frame(height:48)
            .padding()
            .background(PASTE_COLORS[Int(paste.color)])
            
            VStack {
                if let imageData = paste.loadImage() {
                    Image(nsImage: NSImage(data: imageData)!)
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                } else {
                    if let content = paste.loadString() {
                        Text(content)
                            .underline(true,color: Color.gray)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            .lineSpacing(3)
                            .font(.callout)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .topLeading)
                    }
                }
                
                Spacer()
                if let num = paste.loadString()?.count {
                    Text("\(num)个字符")
                }
            }
            .foregroundColor(Color.white)
            .padding()
        }
    }
    
    var timeGap : String {
        guard  paste.pasteTime != nil else {
            return ""
        }
        
        let timeGap : Double  =  0 - paste.pasteTime!.timeIntervalSinceNow
        let second = Int(timeGap)
        let formatter = DateComponentsFormatter.init()
        formatter.zeroFormattingBehavior = .dropLeading
        formatter.allowedUnits = NSCalendar.Unit(
            rawValue : NSCalendar.Unit.day.rawValue  |
                       NSCalendar.Unit.hour.rawValue |
                       NSCalendar.Unit.minute.rawValue |
                       NSCalendar.Unit.second.rawValue)
        formatter.unitsStyle = .short
        
        return (formatter.string(from:TimeInterval(second)) ?? "") + "前"
    }
}

//struct PasteView_Previews: PreviewProvider {
//    static var previews: some View {
//        PasteView(content: "Hello World")
//    }
//}
