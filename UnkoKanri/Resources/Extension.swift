//
//  Extension.swift
//  UnkoKanri
//
//  Created by Yuki Shinohara on 2020/08/30.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public var width : CGFloat {
        return self.frame.size.width
    }

    public var height : CGFloat {
        return self.frame.size.height
    }

    public var top : CGFloat {
        return self.frame.origin.y
    }

    public var bottom : CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }

    public var left : CGFloat {
        return self.frame.origin.x
    }

    public var right : CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
}

extension Date {

    func toStringWithCurrentLocale() -> String {

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return formatter.string(from: self)
    }

}
