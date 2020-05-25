//
//  Scoreboard.swift
//  EggCatcher
//
//  Created by Prassyy on 23/05/20.
//  Copyright © 2020 prassy. All rights reserved.
//

import SpriteKit

class Scoreboard: SKSpriteNode {
    private let lifeIndicator: LifeIndicator
    private let scoreLabel: SKLabelNode
    private var score: Int {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    init(size: CGSize, numberOfLives: Int) {
        scoreLabel = SKLabelNode(fontNamed: Constants.Resource.Font.scoreFont)
        lifeIndicator = LifeIndicator(size: CGSize(width: size.width/3, height: size.height),
                                      numberOfLives: numberOfLives)
        score = 0
        super.init(texture: nil, color: .clear, size: size)
        setupScoreLabel()
        setupLifeIndicator()
    }
    
    private func setupScoreLabel() {
        let labelContainer = SKSpriteNode(texture: nil,
                                          color: .clear,
                                          size: CGSize(width: frame.size.width/3, height: frame.size.height))
        labelContainer.position = CGPoint(x: frame.maxX - labelContainer.frame.width/2,
                                          y: frame.midY)
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.text = "0"
        scoreLabel.fontSize = 200
        labelContainer.addChild(scoreLabel)
        addChild(labelContainer)
        scoreLabel.setScale(0.5 * frame.height/scoreLabel.frame.height)
    }
    
    private func setupLifeIndicator() {
        lifeIndicator.position = CGPoint(x: frame.minX + lifeIndicator.frame.width/2,
                                         y: frame.midY)
        addChild(lifeIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(score: Int, livesRemaining: Int) {
        self.score = score
        self.lifeIndicator.livesRemaining = livesRemaining
    }
}

