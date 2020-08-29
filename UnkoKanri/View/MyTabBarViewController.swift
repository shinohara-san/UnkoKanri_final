//
//  MyTabBarViewController.swift
//  UnkoKanri
//
//  Created by Yuki Shinohara on 2020/08/28.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//


import UIKit

class MyTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .white

        // 背景色
        UITabBar.appearance().barTintColor = .systemBlue
    }


}
