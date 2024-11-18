//
//  ButtonCell.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 03.08.2024.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    
    //MARK: - Cell objects
    
    let button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
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
    
    
    //MARK: - Shadow

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(shadowView)
        shadowView.addSubview(button)
        button.addSubview(innerView)
        
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
            innerView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
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
    
    func configure(with buttonText: String, image: UIImage) {
        innerView.subviews.forEach { $0.removeFromSuperview() }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = #colorLiteral(red: 0.8163539171, green: 0.538916111, blue: 0.3300756216, alpha: 1)
        imageView.contentScaleFactor = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(imageView)
        
        let titleLabel = UILabel()
        titleLabel.text = buttonText
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(titleLabel)
        
        let padding: CGFloat = 15
        let imageTopPadding: CGFloat = 50
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: innerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: innerView.topAnchor, constant: imageTopPadding),
            imageView.widthAnchor.constraint(equalTo: innerView.widthAnchor, multiplier: 0.25),
            imageView.heightAnchor.constraint(equalTo: innerView.heightAnchor, multiplier: 0.25),
            
            titleLabel.centerXAnchor.constraint(equalTo: innerView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -padding)
        ])
        
        innerView.layer.cornerRadius = 25
        innerView.layer.masksToBounds = false
    }
}
