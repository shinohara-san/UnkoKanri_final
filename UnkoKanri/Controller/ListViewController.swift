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
       return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "うんこ結果画面"
        view.addSubview(table)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    
    
}
