//
//  ViewController.swift
//  scrollViewGame
//
//  Created by peter on 2021/8/6.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var squareEelements: [UISquareScrollView]!
    @IBOutlet var puzzleImageViews: [UIImageView]!
    @IBOutlet weak var maskView: UIVisualEffectView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var puzzleView: UIView!
    
    var puzzleMagics: [MagicElement] = []
    let squareEelementsDelegate = UISquareScrollViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for square in squareEelements {
            square.delegate = squareEelementsDelegate
        }
        squareEelementsDelegate.callback = unlockPuzzle
        
        characterImageView.isHidden = true
        for puzzleImageView in puzzleImageViews {
            let magic = MagicElement.getRandom()
            puzzleMagics.append(magic)
            puzzleImageView.image = magic.getImage()
        }
    }

    func animationUnlock() -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        basicAnimation.duration = 1
        basicAnimation.repeatCount = 0
        basicAnimation.fromValue = 0
        basicAnimation.toValue = Double.pi
        
        return basicAnimation
    }
    
    func animationPuzzleHidden() -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        basicAnimation.duration = 10
        basicAnimation.repeatCount = 0
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 2 * Double.pi
        
        return basicAnimation
    }
    
    func unlockPuzzle() {
        var unlock = true
        
        for (index, square) in squareEelements.enumerated() {
            if puzzleMagics[index] != square.getCurrentMagic() {
                unlock = false
                break
            }
        }
        
        if unlock {
            let maskViewAnimation = self.animationUnlock()
            maskViewAnimation.animationComplete {
                self.maskView.isHidden = true
                self.characterImageView.isHidden = false
            }
            maskView.layer.add(maskViewAnimation, forKey: nil)
            
            let puzzleViewAnimation = self.animationPuzzleHidden()
            puzzleViewAnimation.animationComplete {
                self.puzzleView.isHidden = true
            }
            puzzleView.layer.add(puzzleViewAnimation, forKey: nil)
        }
    }
    
    func calculateMagic() {
        let magicArray = MagicElement.allCases
        var magics = [Int].init(repeating: 0, count: magicArray.count)
        
        for square in squareEelements {
            for (magicIndex, magic) in magicArray.enumerated() {
                if square.getCurrentMagic() == magic {
                    magics[magicIndex] += 1
                    break
                }
            }
        }
    }
}

public typealias CallbackType = () -> ();

public class UISquareScrollViewDelegate: NSObject, UIScrollViewDelegate {
    var callback: CallbackType?
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if callback != nil {
            callback!()
        }
    }
}

public typealias CAAnimationCallbackType = () -> ();

public class CAAnimationCallback: NSObject, CAAnimationDelegate {
    var stopCallBack: CAAnimationCallbackType?
    var startCallBack: CAAnimationCallbackType?
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let callBack = stopCallBack {
            callBack()
        }
    }
    
    public func animationDidStart(_ anim: CAAnimation, finished flag: Bool) {
        if let callBack = startCallBack {
            callBack()
        }
    }
}

extension CAAnimation {
    func animationComplete(callback: @escaping CAAnimationCallbackType) {
        if let delegate = self.delegate as? CAAnimationCallback {
            delegate.stopCallBack = callback
            return
        }
        
        let newDelegate = CAAnimationCallback()
        newDelegate.stopCallBack = callback
        self.delegate = newDelegate
    }
    
    func animationStart(callback: @escaping CAAnimationCallbackType) {
        if let delegate = self.delegate as? CAAnimationCallback {
            delegate.startCallBack = callback
            return
        }
        
        let newDelegate = CAAnimationCallback()
        newDelegate.startCallBack = callback
        self.delegate = newDelegate
    }
}

