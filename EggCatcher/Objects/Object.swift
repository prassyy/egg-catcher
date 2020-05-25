//
//  Object.swift
//  EggCatcher
//
//  Created by Prassyy on 22/05/20.
//  Copyright © 2020 prassy. All rights reserved.
//

import SpriteKit

class Object: SKSpriteNode {
    private let remnantImage: String
    private let value: Int
    private let emitterName: String
    public let objectType: ObjectType

    public init(image: String,
                size: CGSize,
                value: Int,
                objectType: ObjectType,
                emitterName: String,
                remnantImage: String) {
        let texture = SKTexture(imageNamed: image)
        self.remnantImage = remnantImage
        self.emitterName = emitterName
        self.value = value
        self.objectType = objectType
        super.init(texture: texture,
                   color: .clear,
                   size: size)
        self.setUpObjectParameters()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getEmitter(range: CGVector) -> SKEmitterNode {
        let emitter = SKEmitterNode(fileNamed: emitterName)!
        emitter.particlePositionRange = range
        emitter.position = CGPoint.zero
        emitter.zPosition = self.zPosition
        return emitter
    }
    
    func getSplashedTexture() -> SKSpriteNode {
        let splashNode = SKSpriteNode(imageNamed: remnantImage)
        splashNode.zPosition = self.zPosition
        splashNode.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        splashNode.setScale(2 * self.size.width/splashNode.size.width)
        return splashNode
    }
    
    private func setUpObjectParameters() {
        self.name = Constants.Id.object
        self.zPosition = Constants.ZPosition.object
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.restitution = 0.3
        self.physicsBody?.categoryBitMask = Constants.PhysicsCategory.eggCategory
    }
    
    func getObjectValue() -> Int {
        return value
    }
}
