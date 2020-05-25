//
//  GameScene.swift
//  EggCatcher
//
//  Created by Prassyy on 17/05/20.
//  Copyright © 2020 prassy. All rights reserved.
//

import SpriteKit

enum GameState {
    case ready
    case inProgress
    case finished
}

class GameScene: SKScene {
    private let objectProvider: ObjectProviding
    private let numberOfChickens: Int
    private let gameManager: GameManager
    private var gameState: GameState
    
    private lazy var basket: SKSpriteNode = {
        let basket = SKSpriteNode(imageNamed: Constants.Resource.Image.basket)
        basket.name = Constants.Id.basket
        basket.setScale(frame.width/(5.5*basket.size.width))
        basket.physicsBody = SKPhysicsBody(rectangleOf: basket.size)
        basket.physicsBody?.isDynamic = false
        basket.zPosition = Constants.ZPosition.basket
        basket.physicsBody?.categoryBitMask = Constants.PhysicsCategory.basketCategory
        basket.physicsBody?.contactTestBitMask = Constants.PhysicsCategory.eggCategory
        return basket
    }()
    
    private lazy var scoreboard: Scoreboard = {
        let scoreboard = Scoreboard(size: CGSize(width: size.width, height: size.height/15), numberOfLives: 5)
        scoreboard.zPosition = Constants.ZPosition.scoreboard
        return scoreboard
    }()
    
    private lazy var droppingPlatform: DroppingPlatform = {
        let droppingPlatform = DroppingPlatform(size: CGSize(width: frame.width, height: frame.height/5),
                                                numberOfChickens: 5)
        droppingPlatform.zPosition = Constants.ZPosition.henPlatform
        return droppingPlatform
    }()
    
    convenience override init(size: CGSize) {
        self.init(size: size,
                  numberOfChickens: 5,
                  gameManager: GameManager(numberOfChickens: 5, numberOfLives: 5),
                  objectProvider: ObjectProvider())
    }
    
    init(size: CGSize,
         numberOfChickens: Int,
         gameManager: GameManager,
         objectProvider: ObjectProviding) {
        self.gameState = .ready
        self.objectProvider = objectProvider
        self.numberOfChickens = numberOfChickens
        self.gameManager = gameManager
        super.init(size: size)
        self.gameManager.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupArena()
        setupFloor()
        setupBackground()
        setupDroppingPlatform()
        setupPlayerBasket()
        setupScoreboard()
        gameManager.startGame()
    }
    
    private func setupArena() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5)
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.restitution = 0.0
        physicsBody?.affectedByGravity = false
    }
    
    private func setupFloor() {
        let floor = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: frame.width, height: frame.height/20))
        floor.anchorPoint = CGPoint.zero
        floor.position = CGPoint(x: frame.minX, y: frame.minY)
        floor.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY + frame.height/20),
                                          to: CGPoint(x: frame.maxX, y: frame.minY + frame.height/20))
        floor.physicsBody?.categoryBitMask = Constants.PhysicsCategory.floorCategory
        floor.physicsBody?.contactTestBitMask = Constants.PhysicsCategory.eggCategory
        floor.physicsBody?.restitution = 0.0
        floor.physicsBody?.affectedByGravity = false
        addChild(floor)
    }
    
    private func setupBackground() {
        let backgroundNode = SKSpriteNode(imageNamed: Constants.Resource.Image.background)
        backgroundNode.anchorPoint = CGPoint.zero
        backgroundNode.setScale(frame.height/backgroundNode.size.height)
        backgroundNode.zPosition = Constants.ZPosition.background
        addChild(backgroundNode)
    }
    
    private func setupDroppingPlatform() {
        droppingPlatform.position = CGPoint(x: frame.midX, y: frame.maxY - droppingPlatform.size.height)
        addChild(droppingPlatform)
    }
    
    private func setupPlayerBasket() {
        basket.position = CGPoint(x: frame.midX,
                                  y: frame.minY + basket.size.height/2 + frame.height/20)
        addChild(basket)
    }
    
    private func setupScoreboard() {
        scoreboard.position = CGPoint(x: frame.midX, y: frame.maxY - 2*scoreboard.frame.height/2)
        addChild(scoreboard)
    }

    private func handleObjectSplash(object: Object) {
        gameManager.brokeObject(object: object)
        object.physicsBody?.isDynamic = false
        object.physicsBody?.contactTestBitMask = Constants.PhysicsCategory.noCategory
        
        let splashEmitter = object.getEmitter(range: CGVector(dx: 1.0, dy: 1.0))
        object.addChild(splashEmitter)
        
        let remnants = object.getSplashedTexture()
        remnants.position = object.position
        addChild(remnants)

        remnants.run(SKAction.fadeOut(withDuration: 3)) {
            remnants.removeFromParent()
        }
        object.run(SKAction.fadeOut(withDuration: 0.2)) {
            object.removeFromParent()
        }
    }
    
    private func handleObjectCatch(object: Object) {
        gameManager.caughtObject(object: object)
        object.removeFromParent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let destination = touches.first?.location(in: self).x {
            basket.run(SKAction.moveTo(x: destination, duration: 0.4))
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        switch bodyA.categoryBitMask | bodyB.categoryBitMask {
        case Constants.PhysicsCategory.eggCategory | Constants.PhysicsCategory.floorCategory:
            if let object = (bodyA.node?.name == Constants.Id.object ? bodyA.node : bodyB.node) as? Object {
                handleObjectSplash(object: object)
            }
        case Constants.PhysicsCategory.eggCategory | Constants.PhysicsCategory.basketCategory:
            if let object = (bodyA.node?.name == Constants.Id.object ? bodyA.node : bodyB.node) as? Object {
                handleObjectCatch(object: object)
            }
        default: break
        }
    }
}

extension GameScene: GameManagerDelegate {
    func updateScoreboard(score: Int, livesRemaining: Int) {
        scoreboard.update(score: score, livesRemaining: livesRemaining)
    }
    
    func gameOver(score: Int) {
        gameState = .finished
    }
    
    func dropObject(of type: ObjectType, from chickenPosition: Int) {
        let object = objectProvider.getObject(type: type, withSize: CGSize(width: 25, height: 30))
        object.setScale(basket.frame.width/(3*object.size.width))
        let relativePosition = droppingPlatform.getChickenPosition(at: chickenPosition) ?? CGPoint(x: frame.midX, y: frame.maxY)
        let absolutePosition = CGPoint(x: droppingPlatform.position.x + relativePosition.x,
                                       y: droppingPlatform.position.y + relativePosition.y)
        object.position = absolutePosition
        addChild(object)
    }
}
