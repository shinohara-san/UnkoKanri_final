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
    
    func saveData(result: String){
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
            } else {
                print("Document added with ID: \(ref!.documentID)")
                //                completion()
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
    
    func deleteData(id: String){
        
        db.collection("results").whereField("id", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let docId = document.documentID
                        self.db.collection("results").document(docId).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    }
                }
        }
    }
    
}
