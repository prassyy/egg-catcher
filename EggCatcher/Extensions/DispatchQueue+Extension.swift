//
//  DispatchQueue+Extension.swift
//  EggCatcher
//
//  Created by Prassyy on 25/05/20.
//  Copyright © 2020 prassy. All rights reserved.
//

import Foundation

protocol Dispatching {
    func asyncAfter(deadline: DispatchTime, execute work: @escaping @convention(block) () -> Void)
    func suspend()
}

extension DispatchQueue: Dispatching {
    func asyncAfter(deadline: DispatchTime, execute work: @escaping @convention(block) () -> Void) {
        self.asyncAfter(deadline: deadline, qos: .unspecified, flags: [], execute: work)
    }
}
