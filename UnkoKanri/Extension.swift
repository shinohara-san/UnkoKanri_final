//
//  Extension.swift
//  UnkoKanri
//
//  Created by Yuki Shinohara on 2020/08/30.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import Foundation

extension Date {

    func toStringWithCurrentLocale() -> String {

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return formatter.string(from: self)
    }

}
