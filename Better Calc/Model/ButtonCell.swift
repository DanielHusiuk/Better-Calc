//
//  ButtonCell.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 03.08.2024.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    
    var cornerRadius: CGFloat {
        UIScreen.main.bounds.height >= 895 ? 35 : 25
    }
    
    //MARK: - Cell objects
    
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var innerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.35
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //MARK: - Shadow
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(shadowView)
        shadowView.addSubview(button)
        button.addSubview(innerView)
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            
            button.topAnchor.constraint(equalTo: shadowView.topAnchor),
            button.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            innerView.topAnchor.constraint(equalTo: button.topAnchor),
            innerView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            innerView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            innerView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.layer.cornerRadius = cornerRadius
    }
    
    
    //MARK: - Inner Placement
    
    func configure(with buttonText: String, image: UIImage) {
        innerView.subviews.forEach { $0.removeFromSuperview() }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        if let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor") {
            imageView.tintColor = selectedTintColor
        }
        imageView.contentScaleFactor = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(imageView)
        
        var textFontSize: CGFloat {
            UIScreen.main.bounds.height >= 895 ? 18 : 16
        }
        
        let titleLabel = UILabel()
        titleLabel.text = buttonText
        titleLabel.font = UIFont.systemFont(ofSize: textFontSize, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.6
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: innerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 50),
            imageView.widthAnchor.constraint(equalTo: innerView.widthAnchor, multiplier: 0.23),
            imageView.heightAnchor.constraint(equalTo: innerView.heightAnchor, multiplier: 0.23),
            
            titleLabel.centerXAnchor.constraint(equalTo: innerView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -15),
            titleLabel.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -10)
        ])
        
        innerView.layer.cornerRadius = cornerRadius
        innerView.layer.masksToBounds = false
    }
}
