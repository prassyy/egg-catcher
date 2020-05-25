//
//  Constants.swift
//  EggCatcher
//
//  Created by Prassyy on 22/05/20.
//  Copyright © 2020 prassy. All rights reserved.
//

import CoreGraphics

struct Constants {
    struct GamePlay {
        static let minimumDropInterval: Double = 0.5
        static let maximumDropInterval: Double = 3.0
    }
    
    struct PhysicsCategory {
        static let noCategory: UInt32 = 0x0
        static let eggCategory: UInt32 = 0x1 << 0
        static let basketCategory: UInt32 = 0x1 << 1
        static let floorCategory: UInt32 = 0x1 << 2
    }
    
    struct ZPosition {
        static let background: CGFloat = 0
        static let object: CGFloat = 1
        static let henPlatform: CGFloat = 2
        static let basket: CGFloat = 3
        static let scoreboard: CGFloat = 4
    }
    
    struct Resource {
        struct Image {
            static let basket: String = "basket"
            static let droppingBeam: String = "bamboo"
            static let background: String = "background"
            static let goldenEgg: String = "golden_egg"
            static let silverEgg: String = "silver_egg"
            static let whiteEgg: String = "white_egg"
            static let dropping: String = "crap_drop"
            static let eggRemnant: String = "egg_yolk"
            static let droppingRemnant: String = "crap_splash"
            static let chicken: String = "chicken_0"
        }
        
        struct Particle {
            static let eggSplash: String = "EggSplash"
            static let droppingSplash: String = "DroppingSplash"
        }
        
        struct Scene {
            static let hensPlatform: String = "HensPlatform"
        }
        
        struct Font {
            static let scoreFont: String = "VarianeScript"
        }
    }
    
    struct Id {
        static let basket: String = "basket"
        static let chicken: String = "chicken"
        static let object: String = "Object"
    }
}
