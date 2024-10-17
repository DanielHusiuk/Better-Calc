//
//  ButtonCell.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 03.08.2024.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    let button: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        
        return button
    }()
    
    func configure(with buttonText: String, image: UIImage) {
        button.setTitle(buttonText, for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.8163539171, green: 0.538916111, blue: 0.3300756216, alpha: 1)
        
        let imageSize = button.imageView?.intrinsicContentSize ?? .zero
        let titleSize = button.titleLabel?.intrinsicContentSize ?? .zero
        button.imageEdgeInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: -titleSize.width)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -90, right: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        
        let padding: CGFloat = 3
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.35
        button.layer.shadowRadius = 10
        button.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
        button.layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
