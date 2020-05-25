//
//  GameViewController.swift
//  EggCatcher
//
//  Created by Prassyy on 17/05/20.
//  Copyright © 2020 prassy. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill

            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        }
    }
}
