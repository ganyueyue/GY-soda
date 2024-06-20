//
//  KYPopupViewController.swift
//  Pods
//
//  Created by Kyle on 2017/8/28.
//
//

import UIKit

public enum KYPopupType: Int {
    case alert
    case sheet
    case drop
    case custom
    case none
}

public typealias ky_completion =  () -> Void

open class KYPopupViewController: UIViewController {

    @objc open var timeDuration : TimeInterval = 0.0

    internal var timer : Timer?

    fileprivate var isInitialized : Bool = false

    internal var buttons = [KYPopupButton]()
    internal var gestureDismissal : Bool = false
    internal var offset : Bool = false

    @objc internal var contentView : KYBaseContentView!
    internal var contentYConstraint : NSLayoutConstraint!

    internal var presentationManager: KYPopupPresentationManager!
    internal lazy var interactor = KYPopupInteractiveTransition()

    internal var completion : (() -> Void)? = nil
    @objc public var dismissCompletion : (() -> Void)? = nil
    
    internal var containerView : KYPopupContainerView{
        return view as! KYPopupContainerView
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        presentationManager = KYPopupPresentationManager(transitionStyle: .bounceUp, interactor: interactor)
        interactor.viewController = self

        transitioningDelegate = presentationManager
        modalPresentationStyle = .custom
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard !isInitialized else { return }
        setupViews()
        isInitialized = true
    }


    open override func loadView() {
        view = KYPopupContainerView(frame: UIScreen.main.bounds)
    }

    //setupView
    internal func setupViews(){

        for button in self.buttons {
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }

        if self.gestureDismissal {
            let tapDismiss = UITapGestureRecognizer(target: self, action:#selector(tapDismisAction(_:)))
            self.view.addGestureRecognizer(tapDismiss)
        }
    }

    //MARK: private method
    @objc fileprivate func buttonTapped(_ button: KYPopupButton) {
        if button.dismissOnTap {
            dismiss() { button.buttonAction?() }
        } else {
            button.buttonAction?()
        }
    }

    @objc fileprivate func tapDismisAction(_ sender : UIGestureRecognizer ){
        dismiss()
    }
    //public method
    @objc open func addButton(_ button :KYPopupButton ){
        self.buttons.append(button);
    }

    @objc open func addButtons(_ buttons :[KYPopupButton]){
        self.buttons.append(contentsOf: buttons)
    }

    @objc open func bePresented(viewcontroller : UIViewController? = nil, animated:Bool = true,completion:(() -> Void)?=nil){

        self.completion = completion

        var currentVC : UIViewController?
        if let _ = viewcontroller {
            currentVC = viewcontroller!
        }else{
            currentVC = UIWindow.topViewController()
        }

        currentVC?.present(self, animated: animated, completion: {
            self.completion?()
            if self.timeDuration <= 0.001 {
                return;
            }

            self.timer = Timer.scheduledTimer(timeInterval: self.timeDuration, target: self, selector: #selector(KYPopupViewController.timerEnd), userInfo: nil, repeats: false)
            guard let timer = self.timer else{
                return
            }
            RunLoop.main.add(timer, forMode: .common);

        })
    }

    @objc public func dismiss(_ completion: (() -> Void)? = nil) {
        self.dismiss(animated: true) {
            if let _ = self.dismissCompletion {
                self.dismissCompletion!()
            }else{
                completion?()
            }
        }
    }

    @objc internal func timerEnd(){

        DispatchQueue.main.async {
            guard let timer = self.timer else{
                return
            }

            timer.invalidate();
            self.timer = nil;
            self.dismiss()
        };
    }


    

}
