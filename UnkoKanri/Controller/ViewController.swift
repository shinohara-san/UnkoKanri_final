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
    
    let dataSource = DataSource()
    
    var result: String?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "うんこ入力画面"
        picker.delegate = self
        picker.dataSource = self
        view.addSubview(picker)
        view.addSubview(imageView)
        view.addSubview(sendButton)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        picker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 6)
        picker.center = view.center
        
        view.sendSubviewToBack(imageView)
        imageView.frame = view.bounds
        
        sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //横軸は中心
        sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        sendButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        sendButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
    }
    
    @objc private func didTapSendButton(){
        guard let result = result, result != "-----" else {
            return
        }
        
        dataSource.saveData(result: result) { (saveSuccess) in
            
            var alertTitle: String
            var alertMessage: String
            
            if saveSuccess {
                alertTitle = "完了"
                alertMessage = "結果を送信しました。"
            } else {
                alertTitle = "失敗"
                alertMessage = "結果を送信できませんでした。"
            }
            
            let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true)
            
        }
    }
    
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return elements.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = .systemFont(ofSize: 25, weight: .bold)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = elements[row]

        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        result = elements[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
}

