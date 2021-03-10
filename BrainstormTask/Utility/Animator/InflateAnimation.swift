//
//  InflateAnimation.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 11.03.21.
//

import Foundation
import UIKit

class InflateAnimation : NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return isPresenting ? 0.2 : 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            self.presentAnimateTransition(transitionContext)
        } else {
            self.dismissAnimateTransition(transitionContext)
        }
    }
    
    func presentAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let alertController = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        let v = alertController.view!
        containerView.addSubview(v)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.alpha = 0
        
        alertController.view.alpha = 0.0
        alertController.view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        UIView.animate(withDuration:self.transitionDuration(using: transitionContext), animations: {
            alertController.view.alpha = 1.0
            containerView.alpha = 1.0
            alertController.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                alertController.view.transform = CGAffineTransform.identity
            }, completion: { _ in
                
                transitionContext.completeTransition(true)
                
            })
        })
    }
    
    func dismissAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let alertController = transitionContext.viewController(forKey: .from)
        let containerView = transitionContext.containerView
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            alertController?.view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            alertController?.view.alpha = 0.0
            containerView.alpha = 0.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
        
    }
}

