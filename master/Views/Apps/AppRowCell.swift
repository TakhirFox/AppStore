//
//  AppRowCell.swift
//  master
//
//  Created by Zakirov Tahir on 20.12.2020.
//

import UIKit

class AppRowCell: UICollectionViewCell {
    
    var app: FeedResult! {
        didSet {
            imageView.sd_setImage(with: URL(string: app.artworkUrl100))
            nameLabel.text = app.name
            companyLabel.text = app.artistName
                
        }
    }
    
    let imageView = UIImageView(cornerRadius: 8)
    let nameLabel = UILabel(text: "App name", font: .systemFont(ofSize: 20))
    let companyLabel = UILabel(text: "Company", font: .systemFont(ofSize: 13))
    let getButton = UIButton(title: "GET")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.backgroundColor = .green
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)
        getButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        getButton.layer.cornerRadius = 32 / 2
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView, VerticalStackView(arrangedSubviews: [nameLabel, companyLabel]), getButton
        ])
        stackView.spacing = 16
        
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
