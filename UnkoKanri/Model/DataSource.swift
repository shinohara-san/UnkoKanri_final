//
//  DataSource.swift
//  UnkoKanri
//
//  Created by Yuki Shinohara on 2020/08/29.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct UnkoInfo: Equatable {
    static func == (lhs: UnkoInfo, rhs: UnkoInfo) -> Bool {
        return lhs.result == rhs.result
    }
    var id: String
    var result: String
    var date: Date
}

class DataSource {
    
    let db = Firestore.firestore()
    
    var results = [UnkoInfo]()
    
    var chokoUnko:Int = 0
    var kotsuUnko:Int = 0
    var done: Bool = false //通知
    
    var chokoAlert = 0
    var kotaroAlert = 0
    var alertReady = false //注意アラート
    
    func saveData(result: String, completion: @escaping (Bool)->Void){
        let id = NSUUID().uuidString
        let info = UnkoInfo(id: id, result: result, date: Date())
        
        var ref: DocumentReference? = nil
        ref = db.collection("results").addDocument(data: [
            "id": info.id,
            "result": info.result,
            "date": info.date
            ]
            
        ) { err in
            if let err = err {
                print("Error adding document: \(err)")
                completion(false)
            } else {
                print("Document added with ID: \(ref!.documentID)")
                completion(true)
            }
        }
    }
    
    
    
    func fetchData(){
        db.collection("results").order(by: "date", descending: true).limit(to: 10).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let timestamp = document.get("date") as! Timestamp
                    let dateValue = timestamp.dateValue()
                    
                    let id = document.get("id") as! String
                    let result = document.get("result") as! String
                    
                    let info = UnkoInfo(id: id, result: result, date: dateValue)
                    self.results.append(info)
                }
            }
        }
    }
    
    func deleteData(id: String, completion: @escaping (Bool)->Void){
        
        db.collection("results").whereField("id", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(false)
                } else {
                    for document in querySnapshot!.documents {
                        let docId = document.documentID
                        self.db.collection("results").document(docId).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                                completion(false)
                            } else {
                                print("Document successfully removed!")
                                completion(true)
                            }
                        }
                    }
                }
        }
    }
    
    func getYesterdayUnko(){
        
        db.collection("results").order(by: "date", descending: true).limit(to: 2).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {
                    guard let result = document.get("result") as? String else {return}
                    
                    switch result {
                    case "朝: ちょ○、こつ○":
                        self.chokoUnko += 1
                        self.kotsuUnko += 1
                        
                    case "朝: ちょ○、こつ×":
                        self.chokoUnko += 1
                    case "朝: ちょ×、こつ○":
                        self.kotsuUnko += 1
                    case "夕: ちょ○、こつ○":
                        self.chokoUnko += 1
                        self.kotsuUnko += 1
                    case "夕: ちょ○、こつ×":
                        self.chokoUnko += 1
                    case "夕: ちょ×、こつ○":
                        self.kotsuUnko += 1
                        
                    default:
                        break
                    }
                    self.done = true
                }
            }
        }
    }
    
    func getUnkoAlert(){
        
        db.collection("results").order(by: "date", descending: true).limit(to: 2).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {
                    guard let result = document.get("result") as? String else {return}
                    
                    switch result {
                    case "朝: ちょ×、こつ×":
                        self.chokoAlert += 1
                        self.kotaroAlert += 1
                    case "朝: ちょ○、こつ×":
                        self.kotaroAlert += 1
                    case "朝: ちょ×、こつ○":
                        self.chokoAlert += 1
                    case "夕: ちょ×、こつ×":
                        self.chokoAlert += 1
                        self.kotaroAlert += 1
                    case "夕: ちょ○、こつ×":
                        self.kotaroAlert += 1
                    case "夕: ちょ×、こつ○":
                        self.chokoAlert += 1
                    default:
                        break
                    }
                    self.alertReady = true
                }
            }
        }
    }
    
    
}
