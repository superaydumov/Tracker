//
//  GeometricParams.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 06.11.2023.
//

import Foundation

struct GeometricParams {
    let cellCount: Int
    let cellSpacing: CGFloat
    let lineSpacing: CGFloat
    
    let paddingWidth: CGFloat
    
    init(cellCount: Int, cellSpacing: CGFloat, lineSpacing: CGFloat) {
        self.cellCount = cellCount
        self.cellSpacing = cellSpacing
        self.lineSpacing = lineSpacing
        
        self.paddingWidth = CGFloat(cellCount - 1) * cellSpacing
    }
}
