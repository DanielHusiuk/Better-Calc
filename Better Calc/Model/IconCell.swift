//
//  IconsCell.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 03.10.2024.
//

import UIKit

class IconCell: UICollectionViewCell {
    
    //MARK: - Cell objects
    
    let button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let innerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 25
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
    
    
    let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 21
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
        button.addSubview(borderView)
        
        let padding: CGFloat = 3
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            button.topAnchor.constraint(equalTo: shadowView.topAnchor),
            button.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            innerView.topAnchor.constraint(equalTo: button.topAnchor),
            innerView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            innerView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            innerView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            
            borderView.topAnchor.constraint(equalTo: button.topAnchor, constant: 4),
            borderView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 4),
            borderView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -4),
            borderView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.layer.cornerRadius = 25
    }
    
    
    //MARK: - Inner Placement
    
    var imageView = UIImageView()
    
    func configure(with buttonText: String, image: UIImage) {
        innerView.subviews.forEach { $0.removeFromSuperview() }
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(imageView)
        
        let titleLabel = UILabel()
        titleLabel.text = buttonText
        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.6
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(titleLabel)
        
        let padding: CGFloat = 12
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: innerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: innerView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: innerView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: innerView.heightAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: innerView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: -10),
            titleLabel.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: 10)
        ])
        
        innerView.layer.cornerRadius = 25
        innerView.layer.masksToBounds = false
    }
}
