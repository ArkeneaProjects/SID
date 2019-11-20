//
//  Common.swift
//  YupEasy
//
//  Created by Pankaj on 11/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit
let screenHeight = UIScreen.main.bounds.height

let screenWidth = UIScreen.main.bounds.width

func isDevice() -> String {
    if screenHeight == 896 {
        return DEVICES.iPhoneXR
    } else if screenHeight == 812 {
        return DEVICES.iPhoneX
    } else if screenHeight == 736 {
        return DEVICES.iPhonePlus
    } else if screenHeight == 667 {
        return DEVICES.iPhone6
    } else {
        return DEVICES.iPhoneSE
    }
}
func getCalculated(_ value: CGFloat) -> CGFloat {
        if isDevice() == DEVICES.iPhoneX || isDevice() == DEVICES.iPhoneXR {
            return safeAreaHeight() * (value / 568.0)
        } else {
            return screenHeight * (value / 568.0)
        }
    }

func safeAreaHeight() -> CGFloat {
    return (isDevice() == DEVICES.iPhoneX) ?667:751
}
