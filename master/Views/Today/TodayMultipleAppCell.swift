//
//  TodayMultipleAppCell.swift
//  master
//
//  Created by Zakirov Tahir on 25.12.2020.
//

import UIKit

class TodayMultipleAppCell: BaseTodayCell {
    
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            
            multipleAppsController.apps = todayItem.apps
//            multipleAppsController.controllerView.reloadData()
        }
    }
    
    let categoryLabel = UILabel(text: "ПРОДАМ ГАРАЖ", font: .boldSystemFont(ofSize: 16), textColor: #colorLiteral(red: 0.6038691401, green: 0.6039564013, blue: 0.6038416624, alpha: 1))
    let titleLabel = UILabel(text: "Срочно, не дорого", font: .boldSystemFont(ofSize: 28), numberOfLines: 2)
    
    let multipleAppsController = TodayMultipleAppsController(mode: .small)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        
        
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel, titleLabel, multipleAppsController.view
        ], spacing: 12)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
