//
//  UnkoInfoTableViewCell.swift
//  UnkoKanri
//
//  Created by Yuki Shinohara on 2020/08/29.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class UnkoInfoTableViewCell: UITableViewCell {
    
    static let identifier = "UnkoInfoTableViewCell"
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var result: UnkoInfo?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(resultLabel)
        contentView.addSubview(dateLabel)
//        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with result: UnkoInfo){
        self.result = result
        resultLabel.text = result.result
        
        if result.result == "夕: ちょ×、こつ×" || result.result == "朝: ちょ×、こつ×" {
            resultLabel.textColor = .systemRed
        }else{
            resultLabel.textColor = .label
        }
        
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateStyle = .long
        f.timeStyle = .short
        let date = f.string(from: result.date)
        dateLabel.text = date
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
    
        resultLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        resultLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        resultLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        
    }
}
