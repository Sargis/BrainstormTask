//
//  InflateAnimator.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 11.03.21.
//

import Foundation
import UIKit

class InflateAnimator : NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return InflateAnimation(isPresenting: true)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return InflateAnimation(isPresenting: false)
    }
}

