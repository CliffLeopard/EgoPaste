//
//  MainContentController.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/15.
//

import Foundation
import SwiftUI

protocol MainContentController {
    
    init(_ controller: NSViewController)
    
    func togglePopover(_ sender: Any?)
    
    func popUp()
    
    func hide(_ sender: Any?)
}
