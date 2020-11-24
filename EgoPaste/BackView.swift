//
//  BackView.swift
//  EgoPaste
//
//  Created by CliffLeopard on 2020/11/14.
//

import SwiftUI

struct BackView: View {
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(color)
    }
}
