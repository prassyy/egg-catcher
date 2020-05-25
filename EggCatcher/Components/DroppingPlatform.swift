//
//  DroppingPlatform.swift
//  EggCatcher
//
//  Created by Prassyy on 25/05/20.
//  Copyright © 2020 prassy. All rights reserved.
//

import SpriteKit

class DroppingPlatform: SKSpriteNode {
    lazy var sittingBeam: SKSpriteNode = {
        let beam = SKSpriteNode(imageNamed: Constants.Resource.Image.droppingBeam)
        beam.setScale(frame.width/beam.size.width)
        return beam
    }()
    private let numberOfChickens: Int
    private var chickens: [SKSpriteNode] = []
    
    init(size: CGSize,
         numberOfChickens: Int) {
        self.numberOfChickens = numberOfChickens
        super.init(texture: nil, color: .clear, size: size)
        setupSittingBeam()
        setupChickens()
    }
    
    private func setupSittingBeam() {
        sittingBeam.position = CGPoint(x: frame.midX, y: frame.minY + sittingBeam.size.height/2)
        addChild(sittingBeam)
    }
    
    private func setupChickens() {
        for i in 0..<numberOfChickens {
            let chicken = SKSpriteNode(imageNamed: "chicken_0")
            chicken.setScale(frame.width/(CGFloat(numberOfChickens) * chicken.size.width))
            chicken.position = CGPoint(x: frame.minX + (CGFloat(i) * frame.width/CGFloat(numberOfChickens)) + chicken.size.width/2,
                                       y: sittingBeam.frame.maxY + chicken.size.height/2)
            addChild(chicken)
            chickens.append(chicken)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getChickenPosition(at index: Int) -> CGPoint? {
        guard index < numberOfChickens else { return nil }
        return chickens[index].position
    }
}
