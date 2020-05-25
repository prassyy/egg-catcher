//
//  ObjectProviderTests .swift
//  EggCatcherTests
//
//  Created by Prassyy on 25/05/20.
//  Copyright © 2020 prassy. All rights reserved.
//

import Foundation
import XCTest

@testable import EggCatcher

class ObjectProviderTests: XCTestCase {
    var subject = ObjectProvider()
    
    func test_whenRequestingAWhiteEgg_receivesAWhiteEggObject() {
        let object = subject.getObject(type: .whiteEgg, withSize: CGSize(width: 10, height: 25))
        XCTAssertEqual(object.objectType, .whiteEgg)
        XCTAssertEqual(object.getObjectValue(), 20)
        XCTAssertEqual(object.size, CGSize(width: 10, height: 25))
    }
    
    func test_whenRequestingASilverEgg_receivesASilverEggObject() {
        let object = subject.getObject(type: .silverEgg, withSize: CGSize(width: 10, height: 25))
        XCTAssertEqual(object.objectType, .silverEgg)
        XCTAssertEqual(object.getObjectValue(), 50)
        XCTAssertEqual(object.size, CGSize(width: 10, height: 25))
    }
    
    func test_whenRequestingAGoldEgg_receivesAGoldEggObject() {
        let object = subject.getObject(type: .goldEgg, withSize: CGSize(width: 10, height: 25))
        XCTAssertEqual(object.objectType, .goldEgg)
        XCTAssertEqual(object.getObjectValue(), 100)
        XCTAssertEqual(object.size, CGSize(width: 10, height: 25))
    }
    
    func test_whenRequestingADropping_receivesADropping() {
        let object = subject.getObject(type: .dropping, withSize: CGSize(width: 10, height: 25))
        XCTAssertEqual(object.objectType, .dropping)
        XCTAssertEqual(object.getObjectValue(), -100)
        XCTAssertEqual(object.size, CGSize(width: 10, height: 25))
    }
}
