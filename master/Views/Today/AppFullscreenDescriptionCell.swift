//
//  AppFullscreenDescriptionCell.swift
//  master
//
//  Created by Zakirov Tahir on 24.12.2020.
//

import UIKit

class AppFullscreenDescriptionCell: UITableViewCell {
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        let attriburedText = NSMutableAttributedString(string: "Отличные игры", attributes: [.foregroundColor: UIColor.label])
        
        attriburedText.append(NSAttributedString(string: " и надо написать описание", attributes: [.foregroundColor: UIColor.gray]))
        
        attriburedText.append(NSAttributedString(string: "\n\n\nЕще про игры", attributes: [.foregroundColor: UIColor.label]))
        
        attriburedText.append(NSAttributedString(string: "\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание", attributes: [.foregroundColor: UIColor.gray]))
        
        attriburedText.append(NSAttributedString(string: "\n\n\nЕще про игры", attributes: [.foregroundColor: UIColor.label]))
        
        attriburedText.append(NSAttributedString(string: "\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание", attributes: [.foregroundColor: UIColor.gray]))
        
        attriburedText.append(NSAttributedString(string: "\n\n\nЕще про игры", attributes: [.foregroundColor: UIColor.label]))
        
        attriburedText.append(NSAttributedString(string: "\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание", attributes: [.foregroundColor: UIColor.gray]))
        
        attriburedText.append(NSAttributedString(string: "\n\n\nЕще про игры", attributes: [.foregroundColor: UIColor.label]))
        
        attriburedText.append(NSAttributedString(string: "\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание\nНаписать описание", attributes: [.foregroundColor: UIColor.gray]))
        
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.attributedText = attriburedText
        label.numberOfLines = 0
        
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(descriptionLabel)
        descriptionLabel.fillSuperview(padding: .init(top: 0, left: 24, bottom: 0, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
