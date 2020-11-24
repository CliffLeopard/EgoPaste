//
//  FocusTextField.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/17.
//

import SwiftUI

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

extension TextField {
    public func becomeFirstResponder() -> some View {
        return self.overlay(OverlayRepresentable().frame(width: 0, height: 0))
    }
}

struct FocusTextField: NSViewRepresentable {
    var placeHolderString: String
    @Binding var inputText: String
    @Binding var becomeFirstResponder: Bool
    
    var changeHandler:(String) -> Void
    var beginHandler: () -> Void
    var endHandler: (String) -> Void
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.delegate = context.coordinator
        textField.placeholderString = self.placeHolderString
        textField.stringValue = inputText
        textField.isBordered = false
        textField.backgroundColor = NSColor(Color.clear)
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        if self.becomeFirstResponder {
            DispatchQueue.main.async {
                nsView.becomeFirstResponder()
                self.becomeFirstResponder = false
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        let parent: FocusTextField
        
        init(_ textField: FocusTextField) {
            self.parent = textField
        }
        
        func controlTextDidBeginEditing(_ obj: Notification) {
            parent.beginHandler()
        }

        func controlTextDidEndEditing(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else {
                return
            }
            parent.endHandler(textField.stringValue)
        }

        func controlTextDidChange(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else {
                return
            }
            parent.inputText = textField.stringValue
            parent.changeHandler(textField.stringValue)
        }
    }
}
