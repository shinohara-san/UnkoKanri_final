//
//  AppDelegate.swift
//  UnkoKanri
//
//  Created by Yuki Shinohara on 2020/08/28.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UITableView.appearance().backgroundColor = UIColor.secondarySystemBackground
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {(granted, error) in
            if granted {
                print("通知を許可する")
            } else {
                print("通知を許可しない")
            }
        }
        let dataSource = DataSource()
        
        DispatchQueue.global().async {
            dataSource.getYesterdayUnko()
        }
        // dataを取得するまで待ちます
        wait( { return dataSource.done == false } ) {
            //done == falseの限りreturn
            //getYesterdayUnko処理の最後でfalseがtrueになって以降の処理が走る。
            self.setLocalNotification(title:"昨日のうんこ", message:"ちょこ \(dataSource.chokoUnko)回、こたろ \(dataSource.kotsuUnko)回")
        }
        
        UINavigationBar.appearance().barTintColor = UIColor.systemBlue
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        UINavigationBar.appearance().tintColor = UIColor.white
        // ナビゲーションバーのテキストを変更する
        UINavigationBar.appearance().titleTextAttributes = [
            // 文字の色
        .foregroundColor: UIColor.white
        ]
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func setLocalNotification(title:String, message:String, hour:Int = 7, minute:Int = 0, second:Int = 0 ){
        // タイトル、本文、サウンド設定の保持
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default
        
        var notificationTime = DateComponents()
        notificationTime.hour = hour
        notificationTime.minute = minute
        notificationTime.second = second
        
        let trigger: UNNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
        
        // 識別子とともに通知の表示内容とトリガーをrequestに内包
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        // UNUserNotificationCenterにrequestを加える
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // アプリ起動中でもアラートと音で通知
        completionHandler([.alert, .sound])
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

}

