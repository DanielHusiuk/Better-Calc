//
//  IconsCell.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 03.10.2024.
//

import UIKit

class IconCell: UICollectionViewCell {
    
    let button: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
//        button.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        
        return button
    }()
    
    func configure(with buttonText: String, image: UIImage) {
        button.setTitle(buttonText, for: .normal)
        button.setImage(image, for: .normal)

        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 90, height: 90))
        button.setImage(resizedImage, for: .normal)
        
        let imageSize = button.imageView?.intrinsicContentSize ?? CGSize.zero
        let titleSize = button.titleLabel?.intrinsicContentSize ?? CGSize.zero
        let imageInset: CGFloat = 8
        button.titleEdgeInsets = UIEdgeInsets(top: imageSize.height + imageInset, left: -imageSize.width, bottom: 0, right: 0)
        
        
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height


        let newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
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
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 10
        button.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
        button.layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

