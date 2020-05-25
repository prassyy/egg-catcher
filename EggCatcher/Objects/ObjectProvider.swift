//
//  ObjectFactory.swift
//  EggCatcher
//
//  Created by Prassyy on 16/05/20.
//  Copyright © 2020 prassy. All rights reserved.
//

import Foundation
import CoreGraphics

protocol ObjectProviding {
    func getObject(type: ObjectType, withSize size: CGSize) -> Object
}

enum ObjectType: Int, CaseIterable {
    case whiteEgg = 0, silverEgg, goldEgg, dropping
}

class ObjectProvider: ObjectProviding {
    func getObject(type: ObjectType, withSize size: CGSize) -> Object {
        switch type {
        case .whiteEgg:
            return Object(image: Constants.Resource.Image.whiteEgg,
                          size: size,
                          value: 20,
                          objectType: type,
                          emitterName: Constants.Resource.Particle.eggSplash,
                          remnantImage: Constants.Resource.Image.eggRemnant)
        case .silverEgg:
            return Object(image: Constants.Resource.Image.silverEgg,
                          size: size,
                          value: 50,
                          objectType: type,
                          emitterName: Constants.Resource.Particle.eggSplash,
                          remnantImage: Constants.Resource.Image.eggRemnant)
        case .goldEgg:
            return Object(image: Constants.Resource.Image.goldenEgg,
                          size: size,
                          value: 100,
                          objectType: type,
                          emitterName: Constants.Resource.Particle.eggSplash,
                          remnantImage: Constants.Resource.Image.eggRemnant)
        case .dropping:
            return Object(image: Constants.Resource.Image.dropping,
                          size: size,
                          value: -100,
                          objectType: type,
                          emitterName: Constants.Resource.Particle.droppingSplash,
                          remnantImage: Constants.Resource.Image.droppingRemnant)
        }
    }
}
