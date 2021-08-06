//
//  MagicElement.swift
//  scrollViewGame
//
//  Created by peter on 2021/8/6.
//

import UIKit
import Foundation

enum MagicElement: CaseIterable {
    case elementA0
    case elementA1
    case elementA2
    case elementA3
    
    static func getRandom() -> MagicElement {
        Self.allCases.shuffled()[0]
    }
    
    func getImage() -> UIImage {
        let image: UIImage?
        
        switch self {
        case .elementA0:
            image = UIImage(named: "axys_0001.png")
        case .elementA1:
            image = UIImage(named: "axys_0003.png")
        case .elementA2:
            image = UIImage(named: "eris_0001.png")
        case .elementA3:
            image = UIImage(named: "eris_0003.png")
        }
        
        guard let image = image else {
            return UIImage()
        }

        return image
    }
}
