//
//  ViewController.swift
//  UnkoKanri
//
//  Created by Yuki Shinohara on 2020/08/28.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let elements = ["-----","朝: ちょ○、こつ○", "朝: ちょ○、こつ×", "朝: ちょ×、こつ○","朝: ちょ×、こつ×", "夕: ちょ○、こつ○", "夕: ちょ○、こつ×", "夕: ちょ×、こつ○", "夕: ちょ×、こつ×"]
    
    private let picker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "doubleUnko")
        imageView.alpha = 0.5
        return imageView
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("送信", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false //これがないとボタンが表示されない
        return button
    }()
    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "うんこ結果を入力"
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false //これがないとボタンが表示されない
//        label.font = .boldSystemFont(ofSize: 22)
//        return label
//    }()
//
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "うんこ入力画面"
        picker.delegate = self
        picker.dataSource = self
        view.addSubview(picker)
        view.addSubview(imageView)
        view.addSubview(sendButton)
//        view.addSubview(titleLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        picker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 6)
        picker.center = view.center
        
        view.sendSubviewToBack(imageView)
        imageView.frame = view.bounds
        
//        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //横軸は中心
//        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
//        titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
//
        sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //横軸は中心
        sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        sendButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        sendButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
    }
    
    @objc private func didTapSendButton(){
        print("tap")
    }
    
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return elements.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return elements[row]
    }
    
}

