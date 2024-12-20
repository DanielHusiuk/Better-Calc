//
//  IconsModel.swift
//  Better Calc
//qqqqq
//  Created by Daniel Husiuk on 03.10.2024.
//

import UIKit

struct appIcon {
    let id: Int16
    var text: String
    var image: UIImage
    var action: () -> Void
}

struct IconsModel {
    var icons: [appIcon] = [
        appIcon(id: 0,    text: "System Orange",      image: UIImage(named: "IconTemplate0.png")!)  { setIcon(.icon0) },
        appIcon(id: 1,    text: "Better Orange",      image: UIImage(named: "IconTemplate1.png")!)  { setIcon(.icon1) },
        appIcon(id: 2,    text: "Cyan Like",         image: UIImage(named: "IconTemplate2.png")!)  { setIcon(.icon2) },
        appIcon(id: 3,    text: "Old Purple",        image: UIImage(named: "IconTemplate3.png")!)  { setIcon(.icon3) },
        appIcon(id: 4,    text: "Very Lime",         image: UIImage(named: "IconTemplate4.png")!)  { setIcon(.icon4) },
        appIcon(id: 5,    text: "Cherry Red",        image: UIImage(named: "IconTemplate5.png")!)  { setIcon(.icon5) },
        appIcon(id: 6,    text: "Aegean Blue",       image: UIImage(named: "IconTemplate6.png")!)  { setIcon(.icon6) },
        appIcon(id: 7,    text: "Miami One",         image: UIImage(named: "IconTemplate7.png")!)  { setIcon(.icon7) },
        appIcon(id: 8,    text: "Just Gray",         image: UIImage(named: "IconTemplate8.png")!)  { setIcon(.icon8) },
    ]
    
}
