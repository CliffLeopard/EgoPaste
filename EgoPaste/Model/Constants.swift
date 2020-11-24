//
//  Constants.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/10.
//

import Foundation
import KeyboardShortcuts
import SwiftUI

extension KeyboardShortcuts.Name {
    static let showPop = Self("showPop", default: Shortcut(.v, modifiers: [.command, .shift]))
    static let quit = Self("quit", default: Shortcut(.q, modifiers: [.command]))
    static let clear = Self("clear", default: Shortcut(.h, modifiers: [.command]))
    static let search = Self("search", default: Shortcut(.f, modifiers: [.command]))
    static let leftArrow = Self("leftArrow", default: Shortcut(.leftArrow, modifiers: []))
    static let rightArrow = Self("rightArrow", default: Shortcut(.rightArrow, modifiers: []))
    static let upArrow = Self("upArrow", default: Shortcut(.upArrow, modifiers: []))
    static let downArrow = Self("downArrow", default: Shortcut(.downArrow, modifiers: []))
    static let enter = Self("enter", default: Shortcut(.return, modifiers: []))
    static let escape = Self("escape", default: Shortcut(.escape, modifiers: []))
}

let PASTE_COLORS = [
    Color(#colorLiteral(red: 0.3150139749, green: 0, blue: 0.8982304931, alpha: 1)),
    Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1)),
    Color(#colorLiteral(red: 0, green: 0.7283110023, blue: 1, alpha: 1)),
    Color(#colorLiteral(red: 0.9467853904, green: 0.2021691203, blue: 0.3819385171, alpha: 1)),
    Color(#colorLiteral(red: 0.9721538424, green: 0.2151708901, blue: 0.5066347718, alpha: 1)),
    Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)),
    Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)),
    Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)),
    Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)),
    Color(#colorLiteral(red: 0.8136427717, green: 0.1280636024, blue: 0.8549019694, alpha: 1))
]
