//
//  GameManager.swift
//  EggCatcher
//
//  Created by Prassyy on 25/05/20.
//  Copyright © 2020 prassy. All rights reserved.
//

import Foundation

protocol GameManagerDelegate {
    func dropObject(of type: ObjectType, from chickenPosition: Int)
    func updateScoreboard(score: Int, livesRemaining: Int)
    func gameOver(score: Int)
}

class GameManager {
    private let numberOfChickens: Int
    private let dropScheduler: Dispatching
    private var livesRemaining: Int {
        didSet {
            delegate?.updateScoreboard(score: score, livesRemaining: livesRemaining)
            if livesRemaining == 0 {
                dropScheduler.suspend()
                delegate?.gameOver(score: score)
            }
        }
    }
    private var score: Int = 0 {
        didSet {
            delegate?.updateScoreboard(score: score, livesRemaining: livesRemaining)
        }
    }
    
    var delegate: GameManagerDelegate?
    
    convenience init(numberOfChickens: Int, numberOfLives: Int) {
        let scheduler = DispatchQueue(label: "org.prassyy.EggCatcher.GameScene.ObjectDropQueue",
                                      qos: .userInteractive)
        self.init(numberOfChickens: numberOfChickens,
                  numberOfLives: numberOfLives,
                  dropScheduler: scheduler)
    }
    
    init(numberOfChickens: Int,
         numberOfLives: Int,
         dropScheduler: Dispatching) {
        self.numberOfChickens = numberOfChickens
        self.livesRemaining = numberOfLives
        self.dropScheduler = dropScheduler
    }
    
    func startGame() {
        scheduleDrop()
    }
    
    func caughtObject(object: Object) {
        score += object.getObjectValue()
    }
    
    func brokeObject(object: Object) {
        guard object.objectType != .dropping else { return }
        if livesRemaining > 0 {
            livesRemaining -= 1
        }
    }
    
    private func scheduleDrop() {
        let dropInterval = getDropInterval()
        let dropPointIndex = getDropPoint()
        let dropObjectType = getDropObjectType()
        dropScheduler.asyncAfter(deadline: .now() + dropInterval) { [weak self] in
            self?.delegate?.dropObject(of: dropObjectType, from: dropPointIndex)
            self?.scheduleDrop()
        }
    }
    
    private func getDropInterval() -> Double {
        let minInterval = Constants.GamePlay.minimumDropInterval
        let maxInterval = Constants.GamePlay.maximumDropInterval
        return Double.random(in: minInterval...maxInterval)
    }
    
    private func getDropPoint() -> Int {
        return Int.random(in: 0..<numberOfChickens)
    }
    
    private func getDropObjectType() -> ObjectType {
        return ObjectType(rawValue: Int.random(in: 0..<ObjectType.allCases.count)) ?? .dropping
    }
}
