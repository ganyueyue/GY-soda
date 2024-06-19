//
//  UIView+KYPopup.swift
//  Pods
//
//  Created by Kyle on 2017/8/29.
//
//
/*!
 The intended direction of the animation
 - in:  Animate in
 - out: Animate out
 */
internal enum KYPopupAnimationDirection {
    case `in`
    case out
}

internal extension UIView {

    /// The key for the fade animation
    internal var ky_fadeKey: String { return "FadeAnimation" }

    /*!
     Applies a fade animation to this view
     - parameter direction: Animation direction
     - parameter value:     The end value of this animation
     - parameter duration:  The duration of this animation
     */
    internal func ky_fade(_ direction: KYPopupAnimationDirection, _ value: Float, duration: CFTimeInterval = 0.08) {
        layer.removeAnimation(forKey: ky_fadeKey)
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = duration
        animation.fromValue = layer.presentation()?.opacity
        layer.opacity = value
        animation.fillMode = CAMediaTimingFillMode.forwards
        layer.add(animation, forKey: ky_fadeKey)
    }

    internal func ky_layoutIfNeededAnimated(duration: CFTimeInterval = 0.08) {
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
