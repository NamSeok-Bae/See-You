//
//  HorizontallyFadeAnimator.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/03.
//

import UIKit

@objc protocol HorizontallyFadeAnimatorDelegate: AnyObject {
    
    @objc optional func transitionWillStartWith(animator: HorizontallyFadeAnimator)
    @objc optional func transitionDidEndWith(animator: HorizontallyFadeAnimator)
}

class HorizontallyFadeAnimator: NSObject {

    weak var fromDelegate: HorizontallyFadeAnimatorDelegate?
    weak var toDelegate: HorizontallyFadeAnimatorDelegate?
    
    enum FadeHorizontallyDirection {
        case leftToRight
        case rightToLeft
    }
    
    var fadeHorizontallyDirection: FadeHorizontallyDirection = .leftToRight
    
    let duration = 0.2
    
    // left to right
    fileprivate func animateFadeHorizontallyTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
            else { return }
        
        let container = transitionContext.containerView
        let distanceX = self.fadeHorizontallyDirection == .leftToRight
            ? container.frame.width / 10
            : -(container.frame.width / 10)
        let whiteBackView = UIView(frame: container.bounds)
        
        whiteBackView.backgroundColor = UIColor.Palette.gray0
        
        self.fromDelegate?.transitionWillStartWith?(animator: self)
        
        container.addSubview(whiteBackView)
        container.addSubview(fromView)
        container.addSubview(toView)
        
        toView.layoutIfNeeded()
        
        toView.center.x += distanceX
        toView.alpha = 0.0
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 2/3) {
                fromView.center.x -= distanceX * (2/3)
                toView.center.x -= distanceX * (2/3)
                fromView.alpha = 0.0
            }
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                fromView.center.x -= distanceX * (1/3)
                toView.center.x -= distanceX * (1/3)
                toView.alpha = 1.0
            }
        }) { (isSuccess) in
            transitionContext.completeTransition(isSuccess)
            fromView.alpha = 1.0
            self.toDelegate?.transitionDidEndWith?(animator: self)
        }
    }
}

extension HorizontallyFadeAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        print("transitionContext.containerView ", transitionContext.containerView)
        animateFadeHorizontallyTransition(using: transitionContext)
    }
}
