//
//  LifeIndicator.swift
//  EggCatcher
//
//  Created by Prassyy on 23/05/20.
//  Copyright © 2020 prassy. All rights reserved.
//

import SpriteKit

class LifeIndicator: SKSpriteNode {
    private let numberOfLives: Int
    private var lifeIndicators: [SKSpriteNode] = []
    var livesRemaining: Int {
        didSet {
            updateIndicators()
        }
    }
    
    init(size: CGSize, numberOfLives: Int) {
        self.numberOfLives = numberOfLives
        self.livesRemaining = numberOfLives
        super.init(texture: nil, color: .clear, size: size)
        setupIndicators()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupIndicators() {
        for i in 0..<numberOfLives {
            let indicator = SKSpriteNode(imageNamed: Constants.Resource.Image.whiteEgg)
            indicator.alpha = 1
            indicator.setScale((0.8 * frame.width)/(5 * indicator.frame.width))
            indicator.position = CGPoint(x: frame.minX + frame.width*0.1 + (CGFloat(i) + 0.5)*indicator.frame.width,
                                         y: frame.midY)
            lifeIndicators.append(indicator)
            addChild(indicator)
        }
    }
    
    private func updateIndicators() {
        for i in 0 ..< numberOfLives {
            if i < livesRemaining {
                lifeIndicators[i].alpha = 1.0
            } else {
                lifeIndicators[i].alpha = 0.5
            }
        }
    }
}
