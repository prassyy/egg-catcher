//
//  GameManagerTests.swift
//  EggCatcherTests
//
//  Created by Prassyy on 25/05/20.
//  Copyright © 2020 prassy. All rights reserved.
//

import XCTest
@testable import EggCatcher

class GameManagerTests: XCTestCase {
    var subject: GameManager!
    var fakeScheduler: FakeDispatcher!
    var fakeGameManagerDelegate: FakeGameManagerDelegate!
    var numberOfChickens = 5
    var numberOfLives = 5
    override func setUp() {
        fakeScheduler = FakeDispatcher()
        fakeGameManagerDelegate = FakeGameManagerDelegate()
        subject = GameManager(numberOfChickens: numberOfChickens,
                              numberOfLives: numberOfLives,
                              dropScheduler: fakeScheduler)
        subject.delegate = fakeGameManagerDelegate
    }
    
    func test_whenStartingGame_shouldScheduleATaskWithScheduler() {
        subject.startGame()
        XCTAssertNotNil(fakeScheduler.dropInterval)
        XCTAssertNotNil(fakeScheduler.dispatchedTask)
    }
    
    func test_whenSchedulingATask_intervalShouldBeWithinLimits() {
        subject.startGame()
        XCTAssertNotNil(fakeScheduler.dropInterval.toSeconds())
        XCTAssert((0.5...3.0).contains(fakeScheduler.dropInterval.toSeconds()))
    }
    
    func test_whenScheduledTaskExecutes_shouldInvokeDelegate() {
        subject.startGame()
        fakeScheduler.dispatchedTask()
        XCTAssert(fakeGameManagerDelegate.didCallDropObject)
    }
    
    func test_whenScheduledTaskExecutes_shouldInvokeDelegateWithCorrectDropIndexValues() {
        subject.startGame()
        fakeScheduler.dispatchedTask()
        XCTAssert((0..<numberOfChickens).contains(fakeGameManagerDelegate.chickenPosition))
    }
    
    func test_whenScheduledTaskExecutes_shouldScheduleTaskAgain() {
        subject.startGame()
        XCTAssertNotNil(fakeScheduler.dropInterval)
        fakeScheduler.dropInterval = nil
        fakeScheduler.dispatchedTask()
        XCTAssertNotNil(fakeScheduler.dropInterval)
    }
    
    func test_whenCatchingObject_shouldAddObjectsValueToScore() {
        let object = Object(image: "", size: CGSize.zero, value: 200, objectType: .dropping, emitterName: "", remnantImage: "")
        subject.caughtObject(object: object)
        XCTAssertEqual(fakeGameManagerDelegate.updatedScore, 200)
    }
    
    func test_whenBrokeADroppingObject_shouldNotChangeRemainingLives() {
        let object = Object(image: "", size: CGSize.zero, value: 200, objectType: .dropping, emitterName: "", remnantImage: "")
        fakeGameManagerDelegate.updatedRemainingLives = 15
        subject.brokeObject(object: object)
        XCTAssertEqual(fakeGameManagerDelegate.updatedRemainingLives, 15)
    }
    
    func test_whenBrokeAnyObjectOtherThanDropping_shouldReduceRemainingLives() {
        let object = Object(image: "", size: CGSize.zero, value: 200, objectType: .whiteEgg, emitterName: "", remnantImage: "")
        subject.brokeObject(object: object)
        XCTAssertEqual(fakeGameManagerDelegate.updatedRemainingLives, numberOfLives - 1)
    }
    
    func test_whenBrokeAnyNonDroppingObjectDuringLastLife_shouldInvokeGameOverToDelegate() {
        numberOfLives = 1
        setUp()
        let object = Object(image: "", size: CGSize.zero, value: 200, objectType: .whiteEgg, emitterName: "", remnantImage: "")
        subject.brokeObject(object: object)
        XCTAssertEqual(fakeGameManagerDelegate.gameOverScore, 0)
    }
    
    func test_whenBrokeAnyNonDroppingObjectDuringLastLife_shouldSuspendTheDropScheduler() {
        numberOfLives = 1
        setUp()
        let object = Object(image: "", size: CGSize.zero, value: 200, objectType: .whiteEgg, emitterName: "", remnantImage: "")
        subject.brokeObject(object: object)
        XCTAssert(fakeScheduler.didCallSuspend)
    }
    
    func test_whenNoLivesRemainingAndBrokeAnObject_shouldNotReduceLives() {
        numberOfLives = 0
        setUp()
        let object = Object(image: "", size: CGSize.zero, value: 200, objectType: .dropping, emitterName: "", remnantImage: "")
        fakeGameManagerDelegate.updatedRemainingLives = 15
        subject.brokeObject(object: object)
        XCTAssertEqual(fakeGameManagerDelegate.updatedRemainingLives, 15)
    }
}

class FakeDispatcher: Dispatching {
    var dropInterval: DispatchTimeInterval!
    var dispatchedTask: (() -> Void)!
    func asyncAfter(deadline: DispatchTime, execute work: @escaping @convention(block) () -> Void) {
        dropInterval = DispatchTime.now().distance(to: deadline)
        dispatchedTask = work
    }

    var didCallSuspend: Bool = false
    func suspend() {
        didCallSuspend = true
    }
}

extension DispatchTimeInterval {
    func toSeconds() -> Double {
        switch self {
        case .seconds(let seconds): return Double(seconds)
        case .milliseconds(let milliseconds): return Double(milliseconds)/1000.0
        case .microseconds(let microseconds): return Double(microseconds)/1000000.0
        case .nanoseconds(let nanoseconds): return Double(nanoseconds)/1000000000.0
        default: return Double.infinity
        }
    }
}

class FakeGameManagerDelegate: GameManagerDelegate {
    var didCallDropObject: Bool = false
    var chickenPosition: Int = Int.max
    func dropObject(of type: ObjectType, from chickenPosition: Int) {
        self.didCallDropObject = true
        self.chickenPosition = chickenPosition
    }
    
    var updatedScore: Int = Int.max
    var updatedRemainingLives = Int.max
    func updateScoreboard(score: Int, livesRemaining: Int) {
        updatedScore = score
        updatedRemainingLives = livesRemaining
    }
    
    var gameOverScore: Int = Int.max
    func gameOver(score: Int) {
        gameOverScore = score
    }
}
