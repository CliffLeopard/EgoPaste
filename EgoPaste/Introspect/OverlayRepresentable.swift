//
//  EditTextExtensition.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/16.
//

import SwiftUI

var updated:Bool = false

struct OverlayRepresentable : NSViewRepresentable {
    
    private func  siblingContaining(_ entry: NSView) -> NSTextField? {
        guard let viewHost = Introspect.findViewHost(from: entry) else {
            return nil
        }
        return Introspect.previousSibling(containing: NSTextField.self, from: viewHost)
    }
    
    func makeNSView(context: NSViewRepresentableContext<OverlayRepresentable>) -> OverlayNSView {
        let view = OverlayNSView()
        view.setAccessibilityLabel("OverlayNSView<\(NSTextField.self)>")
        return view
    }
    
    func updateNSView(_ nsView: OverlayNSView, context: Context) {
        guard !updated else {
            return
        }
        updated = true
        DispatchQueue.main.async {
            if let targetView = siblingContaining(nsView) {
                    targetView.becomeFirstResponder()
            }
        }
    }
}

public class OverlayNSView: NSView {
    required init() {
        super.init(frame: .zero)
        isHidden = true
    }
    
    public override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






