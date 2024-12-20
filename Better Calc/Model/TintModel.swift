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
        tintStruct(id: 0,    text: "System Orange",     color: #colorLiteral(red: 0.9960784314, green: 0.5333333333, blue: 0.137254902, alpha: 1),          image: UIImage(named: "AppIcon_small0.png")!),
        tintStruct(id: 1,    text: "Better Orange",     color: #colorLiteral(red: 0.8163539171, green: 0.538916111, blue: 0.3300756216, alpha: 1),         image: UIImage(named: "AppIcon_small1.png")!),
        tintStruct(id: 2,    text: "Cyan Like",        color: #colorLiteral(red: 0.07450980392, green: 0.4, blue: 0.3960784314, alpha: 1),         image: UIImage(named: "AppIcon_small2.png")!),
        tintStruct(id: 3,    text: "Old Purple",       color: #colorLiteral(red: 0.3843137255, green: 0.2156862745, blue: 0.3333333333, alpha: 1),         image: UIImage(named: "AppIcon_small3.png")!),
        tintStruct(id: 4,    text: "Very Lime",        color: #colorLiteral(red: 0.5450980392, green: 0.6117647059, blue: 0.1333333333, alpha: 1),         image: UIImage(named: "AppIcon_small4.png")!),
        tintStruct(id: 5,    text: "Cherry Red",       color: #colorLiteral(red: 0.4784313725, green: 0.05882352941, blue: 0.07450980392, alpha: 1),         image: UIImage(named: "AppIcon_small5.png")!),
        tintStruct(id: 6,    text: "Aegean Blue",      color: #colorLiteral(red: 0.1058823529, green: 0.2156862745, blue: 0.3333333333, alpha: 1),         image: UIImage(named: "AppIcon_small6.png")!),
        tintStruct(id: 7,    text: "Just Gray",        color: #colorLiteral(red: 0.4039215686, green: 0.4039215686, blue: 0.4039215686, alpha: 1),         image: UIImage(named: "AppIcon_small7.png")!),
        tintStruct(id: 8,    text: "Miami One",        color: #colorLiteral(red: 0.05098039216, green: 0.5019607843, blue: 0.6078431373, alpha: 1) ,        image: UIImage(named: "AppIcon_small8.png")!)
    ]
    
}
