//
//  ReviewCell.swift
//  master
//
//  Created by Zakirov Tahir on 23.12.2020.
//

import UIKit


class ReviewCell: UICollectionViewCell {
    
    let titleLabel = UILabel(text: "Ебучие отзывы", font: .boldSystemFont(ofSize: 18))
    let authorLabel = UILabel(text: "Автор", font: .systemFont(ofSize: 16), textColor: #colorLiteral(red: 0.6077381968, green: 0.6033633351, blue: 0.6327681541, alpha: 1))
    let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 14))
    let bodyLabel = UILabel(text: "Отзыв\nОтзыв\nОтзыв блять", font: .systemFont(ofSize: 18), numberOfLines: 5)
    let starsStackView: UIStackView = {
        var arrangeSubviews = [UIView]()
        
        (0..<5).forEach({ (_) in
            let imageView = UIImageView(image: #imageLiteral(resourceName: "star"))
            imageView.constrainWidth(constant: 24)
            imageView.constrainHeight(constant: 24)
            arrangeSubviews.append(imageView)
        })
        
        arrangeSubviews.append(UIView())
        
        let stackView = UIStackView(arrangedSubviews: arrangeSubviews)
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.9450005889, green: 0.9405583739, blue: 0.9741286635, alpha: 1)
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [titleLabel, UIView(), authorLabel], customSpacing: 8), starsStackView, bodyLabel
        ], spacing: 12)
        
        titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        authorLabel.textAlignment = .right
        
        addSubview(stackView)
        
//        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 20, bottom: 0, right: 20))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
