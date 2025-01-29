//
//  TintModel.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 06.10.2024.
//

import UIKit

struct tintStruct {
    let id: Int16
    var text: String
    var color: UIColor
    var image: UIImage
}

struct TintModel {
    var tints: [tintStruct] = [
        tintStruct(id: 0,    text: NSLocalizedString("system_orange", comment: ""),     color: #colorLiteral(red: 0.9490196078, green: 0.6392156863, blue: 0.2352941176, alpha: 1),         image: UIImage(named: "AppIcon_small0.png")!),
        tintStruct(id: 1,    text: NSLocalizedString("better_orange", comment: ""),     color: #colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1),         image: UIImage(named: "AppIcon_small1.png")!),
        tintStruct(id: 2,    text: NSLocalizedString("cyan_like", comment: ""),        color: #colorLiteral(red: 0.09411764706, green: 0.537254902, blue: 0.4823529412, alpha: 1),         image: UIImage(named: "AppIcon_small2.png")!),
        tintStruct(id: 3,    text: NSLocalizedString("old_purple", comment: ""),       color: #colorLiteral(red: 0.5176470588, green: 0.2901960784, blue: 0.4509803922, alpha: 1),         image: UIImage(named: "AppIcon_small3.png")!),
        tintStruct(id: 4,    text: NSLocalizedString("very_lime", comment: ""),        color: #colorLiteral(red: 0.5450980392, green: 0.6117647059, blue: 0.1333333333, alpha: 1),         image: UIImage(named: "AppIcon_small4.png")!),
        tintStruct(id: 5,    text: NSLocalizedString("cherry_red", comment: ""),       color: #colorLiteral(red: 0.6431372549, green: 0.0862745098, blue: 0.1137254902, alpha: 1),         image: UIImage(named: "AppIcon_small5.png")!),
        tintStruct(id: 6,    text: NSLocalizedString("deep_blue", comment: ""),        color: #colorLiteral(red: 0.07058823529, green: 0.3098039216, blue: 0.5882352941, alpha: 1),         image: UIImage(named: "AppIcon_small6.png")!),
        tintStruct(id: 7,    text: NSLocalizedString("just_gray", comment: ""),        color: #colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1),         image: UIImage(named: "AppIcon_small7.png")!),
        tintStruct(id: 8,    text: NSLocalizedString("miami_one", comment: ""),        color: #colorLiteral(red: 0.05098039216, green: 0.5019607843, blue: 0.6078431373, alpha: 1),         image: UIImage(named: "AppIcon_small8.png")!)
    ]
    
}
