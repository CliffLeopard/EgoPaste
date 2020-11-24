//
//  AppState.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/15.
//

import Foundation

class AppState {
    static var shared = AppState()
    private weak var activePaste: Paste?
    private var mainContentIsShow = false
    private var cardIndex : Int = 0
    
    func updateActivePaste(_ paste: Paste?) {
        self.activePaste = paste
    }
    
    func getActivePaste() -> Paste? {
        return self.activePaste
    }
    
    func updateShowState(_ showState: Bool) {
        self.mainContentIsShow = showState
    }
    
    func appShow() -> Bool {
        return self.mainContentIsShow
    }
    
    func updateCardIndex(_ index: Int) {
        self.cardIndex = index
    }
    
    func activeCardIndex() -> Int {
        self.cardIndex
    }
}
