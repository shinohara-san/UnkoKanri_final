//
//  ListViewController.swift
//  UnkoKanri
//
//  Created by Yuki Shinohara on 2020/08/28.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UnkoInfoTableViewCell.self, forCellReuseIdentifier: UnkoInfoTableViewCell.identifier)
        table.backgroundColor = .systemBackground
        return table
    }()
    
    let dataSource = DataSource()
    
    var ActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "うんこ結果画面"
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        
        // ActivityIndicatorを作成＆中央に配置
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        ActivityIndicator.center = self.view.center
        
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        
        // 大きさを設定
        ActivityIndicator.style = .large
        
        //Viewに追加
        self.view.addSubview(ActivityIndicator)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ActivityIndicator.startAnimating()
        
        DispatchQueue.global().async { [weak self] in
            self?.dataSource.fetchData()
            self?.dataSource.getUnkoAlert()
        }
        
        wait( { return self.dataSource.results == [UnkoInfo]() } ) {
            DispatchQueue.main.async { [weak self] in
                self?.table.reloadData() ///Don't forget it
                self?.ActivityIndicator.stopAnimating()
            }
        }
        
        wait( { return self.dataSource.alertReady == false } ) {
            
            let choko = self.dataSource.chokoAlert
            let kotsu = self.dataSource.kotaroAlert
            
            var title = ""
            
            if choko == 2 && kotsu == 2 {
                title = "2匹ともやばい"
            } else if kotsu == 2{
                title = "こたろうやばい"
            } else if choko == 2{
                title = "ちょこやばい"
            } else {
                return
            }
            
            let ac = UIAlertController(title: title, message: "2回連続うんこしてません。", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true)
            
        }
        
    }

    
    func wait(_ waitContinuation: @escaping (()->Bool), completion: @escaping (()->Void)) {
        var wait = waitContinuation()
        // 0.01秒周期で待機条件をクリアするまで待ちます。
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            while wait {
                DispatchQueue.main.async {
                    wait = waitContinuation()
                    semaphore.signal()
                }
                semaphore.wait()
                Thread.sleep(forTimeInterval: 0.01)
            }
            // 待機条件をクリアしたので通過後の処理を行います。
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataSource.results = [UnkoInfo]()
        dataSource.alertReady = false
        dataSource.chokoAlert = 0
        dataSource.kotaroAlert = 0
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = dataSource.results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UnkoInfoTableViewCell.identifier,
                                                 for: indexPath) as! UnkoInfoTableViewCell
        cell.configure(with: result) //この関数でCustomCellに各列のデータを渡す
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dataId = dataSource.results[indexPath.row].id
            

            dataSource.deleteData(id: dataId) { (deleteSuccess) in
                
                var alertTitle: String
                var alertMessage: String
                
                if deleteSuccess {
                    alertTitle = "削除"
                    alertMessage = "データを削除しました。"
                    self.dataSource.results.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
                } else {
                    alertTitle = "エラー"
                    alertMessage = "データを削除できませんでした。"
                }
                
                let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true)
            }
            
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
