//
//  UISquareScrollView.swift
//  scrollViewGame
//
//  Created by peter on 2021/8/6.
//

import UIKit

class UISquareScrollView: UIScrollView {
    var imageViews: [UIImageView] = []
    var magics: [MagicElement] = []
    
    required init?(coder: NSCoder) {

        super.init(coder: coder)
        
        let width = self.frame.width
        let height = self.frame.height
        
        magics = MagicElement.allCases.shuffled()
        
        for (index, magic) in magics.enumerated() {
            let imageView = UIImageView()
            imageView.image = magic.getImage()
            imageView.frame = CGRect(x: Double(index) * width, y: 0, width: width, height: height)
            imageViews.append(imageView)
            self.addSubview(imageView)
        }
        
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.contentSize = CGSize(width: CGFloat(imageViews.count) * self.frame.width, height: 0)
    }
    
    func getHorizontalIndex() -> Int {
        Int(self.contentOffset.x / self.frame.width)
    }
    
    func getVerticalIndex() -> Int {
        Int(self.contentOffset.y / self.frame.height)
    }
    
    func getCurrentMagic() -> MagicElement {
        magics[getHorizontalIndex()]
    }
}
