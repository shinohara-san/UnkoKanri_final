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
        label.font = .systemFont(ofSize: 26)
        label.textAlignment = .center
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let chokoImage: UIImageView = {
       let image = UIImageView()
        image.layer.masksToBounds = true
        image.tintColor = .systemGray
        return image
    }()
    
    private let kotsuImage: UIImageView = {
       let image = UIImageView()
        image.layer.masksToBounds = true
        image.tintColor = .systemGray
        return image
    }()
    
    private var result: UnkoInfo?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        let views = [resultLabel, dateLabel, chokoImage, kotsuImage]
        for x in views {
            contentView.addSubview(x)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with result: UnkoInfo){
        self.result = result
        
        if result.result.contains("朝"){
            resultLabel.text = "朝"
        } else {
            resultLabel.text = "夕"
        }
        
        
        if result.result.contains("ちょ○"){
            chokoImage.image = UIImage(named: "choko")
        } else {
            chokoImage.image = UIImage(systemName: "xmark")
        }
        
        if result.result.contains("こつ○"){
            kotsuImage.image = UIImage(named: "kotsu")
        } else {
            kotsuImage.image = UIImage(systemName: "xmark")
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
        dateLabel.frame = CGRect(x: 5, y: 5, width: contentView.width / 2, height: 20)
        resultLabel.frame = CGRect(x: 5, y: dateLabel.bottom, width: dateLabel.width, height: contentView.height - dateLabel.height - 10)
        chokoImage.frame = CGRect(x: dateLabel.right + 10, y: 5, width: contentView.width / 5, height: contentView.width / 5)
        chokoImage.layer.cornerRadius = chokoImage.width / 2
        kotsuImage.frame = CGRect(x: chokoImage.right + 10, y: 5, width: contentView.width / 5, height: contentView.width / 5)
        kotsuImage.layer.cornerRadius = kotsuImage.width / 2
    }
}
