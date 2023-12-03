//
//  UIColor+Extension.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 30.09.2023.
//

import UIKit

extension UIColor {
    static var trackerBackground: UIColor! { UIColor(named: "tracker_Background")}
    static var trackerBlack: UIColor! { UIColor(named: "tracker_Black")}
    static var trackerBlue: UIColor! { UIColor(named: "tracker_Blue")}
    static var trackerDatePicker: UIColor! { UIColor(named: "tracker_datePicker")}
    static var trackerGray: UIColor! { UIColor(named: "tracker_Gray")}
    static var trackerLightGray: UIColor! { UIColor(named: "tracker_Light_Gray")}
    static var trackerRed: UIColor! { UIColor(named: "tracker_Red")}
    static var trackerSearchTextField: UIColor! { UIColor(named: "tracker_searchTextField")}
    static var trackerSearchTextFieldPlaceholder: UIColor! { UIColor(named: "tracker_searchTextFieldPlaceholder")}
    static var trackerWhite: UIColor! { UIColor(named: "tracker_White")}
    static var redGradient: UIColor! { UIColor(named: "redGradient")}
    static var greenGradient: UIColor! { UIColor(named: "greenGradient")}
    static var blueGradient: UIColor! { UIColor(named: "blueGradient")}
}

extension UIColor {
    static var colorSelection1: UIColor! { UIColor(named: "color_Selection_1")}
    static var colorSelection2: UIColor! { UIColor(named: "color_Selection_2")}
    static var colorSelection3: UIColor! { UIColor(named: "color_Selection_3")}
    static var colorSelection4: UIColor! { UIColor(named: "color_Selection_4")}
    static var colorSelection5: UIColor! { UIColor(named: "color_Selection_5")}
    static var colorSelection6: UIColor! { UIColor(named: "color_Selection_6")}
    static var colorSelection7: UIColor! { UIColor(named: "color_Selection_7")}
    static var colorSelection8: UIColor! { UIColor(named: "color_Selection_8")}
    static var colorSelection9: UIColor! { UIColor(named: "color_Selection_9")}
    static var colorSelection10: UIColor! { UIColor(named: "color_Selection_10")}
    static var colorSelection11: UIColor! { UIColor(named: "color_Selection_11")}
    static var colorSelection12: UIColor! { UIColor(named: "color_Selection_12")}
    static var colorSelection13: UIColor! { UIColor(named: "color_Selection_13")}
    static var colorSelection14: UIColor! { UIColor(named: "color_Selection_14")}
    static var colorSelection15: UIColor! { UIColor(named: "color_Selection_15")}
    static var colorSelection16: UIColor! { UIColor(named: "color_Selection_16")}
    static var colorSelection17: UIColor! { UIColor(named: "color_Selection_17")}
    static var colorSelection18: UIColor! { UIColor(named: "color_Selection_18")}
}

extension UIColor {
    var hexString: String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }
}
