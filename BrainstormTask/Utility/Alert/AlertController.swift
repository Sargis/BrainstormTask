//
//  JHTAlertAction.swift
//  JHTAlertController
//
//  Created by Jessel, Jeremiah on 11/15/16.
//  Copyright © 2016 Jacuzzi Hot Tubs, LLC. All rights reserved.
//
import UIKit

class AlertAction: UIButton {
    enum AlertActionStyle {
        case `default`
        case cancel
        case destructive
        case custom(backgroundColor: UIColor, titleColor: UIColor, font: UIFont)
    }
    
    struct BorderOptions: OptionSet {
        let rawValue: Int
        
        static let left = BorderOptions(rawValue: 1 << 0)
        static let right = BorderOptions(rawValue: 1 << 1)
        static let top = BorderOptions(rawValue: 1 << 2)
        static let bottom = BorderOptions(rawValue: 1 << 3)
        
        static let all = [left, right, top, bottom]
        static let none:BorderOptions = []
    }

    var actionStyle : AlertActionStyle {
        didSet {
            self.updateStyle()
        }
    }
    var title: String? {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }
    
    fileprivate var borders: BorderOptions = [.none] {
        didSet {
            self.updateBorders()
        }
    }
    fileprivate var borderColor:UIColor = UIColor.gray {
        didSet {
            self.borderLayer.borderColor = borderColor.cgColor
        }
    }
    
    private let borderWidth: CGFloat = 0.5
    private let borderLayer = CALayer()
    private let highlightLayer = CALayer()
    fileprivate let handler: (() -> Void)?
    fileprivate let handlerWithArg: ((AlertAction) -> Void)?

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        self.actionStyle = .cancel
        self.handler = nil
        self.handlerWithArg = nil
        
        super.init(frame: CGRect.zero)
    }
    
    private init(title: String?, style: AlertActionStyle = .default, handler: (() -> Void)? = nil, handlerWithArg: ((AlertAction) -> Void)? = nil) {
        self.actionStyle = style
        self.handler = handler
        self.handlerWithArg = handlerWithArg
        
        super.init(frame: CGRect.zero)
        self.layer.masksToBounds = true
        
        borderLayer.borderWidth = borderWidth
        borderLayer.borderColor = borderColor.cgColor
        self.layer.addSublayer(borderLayer)
        
        highlightLayer.backgroundColor = UIColor(white: 0.0, alpha: 0.1).cgColor
        highlightLayer.opacity = 0.0
        self.layer.addSublayer(highlightLayer)
        
        self.title = title
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        
        self.updateStyle()
    }
    
    convenience init(title: String?, style: AlertActionStyle = .default, handler: (() -> Void)? = nil) {
        self.init(title: title, style: style, handler: handler, handlerWithArg: nil)
    }
    convenience init(title: String?, style: AlertActionStyle = .default, handler: @escaping ((AlertAction) -> Void)) {
        self.init(title: title, style: style, handler: nil, handlerWithArg: handler)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width, height: 43)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.highlightLayer.frame = self.bounds
        self.updateBorders()
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.highlightLayer.opacity = isHighlighted ? 1.0 : 0.0
        }
    }
    
    private func updateBorders() {
        var frame = self.bounds.insetBy(dx: -borderWidth, dy: -borderWidth)
        
        if self.borders.contains(.left) {
            frame.origin.x += self.borderWidth
            frame.size.width -= self.borderWidth
        }
        if self.borders.contains(.right) {
            frame.size.width -= self.borderWidth
        }
        if self.borders.contains(.top) {
            frame.origin.y += self.borderWidth
            frame.size.height -= self.borderWidth
        }
        if self.borders.contains(.bottom) {
            frame.size.height -= self.borderWidth
        }
        self.borderLayer.frame = frame
    }
    
    private func updateStyle() {
        switch actionStyle {
        case .cancel, .default:
            self.backgroundColor = UIColor.clear
            self.setTitleColor(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        case .destructive:
            self.backgroundColor = UIColor.clear
            self.setTitleColor(UIColor.red, for: .normal)
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        case .custom(let backgroundColor, let titleColor, let font):
            self.setTitleColor(titleColor, for: .normal)
            self.backgroundColor = backgroundColor
            self.titleLabel?.font = font
        }
    }
}


class AlertController: UIViewController {
    
    // MARK: private
    @IBOutlet fileprivate weak var alertView: UIView!

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var customViewPlaceholder: UIView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var stackViewButtons: UIStackView!
    @IBOutlet fileprivate weak var stackViewTextFields: UIStackView!
    @IBOutlet fileprivate weak var scrollViewBody: UIScrollView!
    @IBOutlet fileprivate weak var scrollViewButtons: UIScrollView!
    @IBOutlet fileprivate weak var buttonsViewMinimumHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var horzSeparator: UIView!

    fileprivate var keyboardObservers : [NSObjectProtocol]?
    required init?(coder aDecoder: NSCoder) {
        fatalError("Please use init() or init(title: String?, message: String? initializers instead")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Please use init() or init(title: String?, message: String? initializers instead")
    }
    convenience init() {
        self.init(title: nil, message: nil)
    }
    init(title: String?, message: String?) {
        super.init(nibName: nil, bundle: nil)

        if let nib = Bundle.main.loadNibNamed("AlertView", owner: self, options: nil) {
            let alertView = nib[0] as! UIView
            alertView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(alertView)
            
            let views = ["view" : alertView]
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: views))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: views))
        }
        
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = Utility.inflateAnimator
        
        self.alertView.layer.cornerRadius = 15
        self.alertView.clipsToBounds = true
        
        self.titleLabel.text = title
        self.descriptionLabel.text = message
        
        self.updateBodyViewConstraints()
        self.updateSeparatorColor()

        self.alertView.backgroundColor = alertBackgroundColor
        self.titleLabel.textColor = alertTitleColor
        self.descriptionLabel.textColor = alertMessageColor

    }
    static func alert(title: String?, message : String, completion : (()->Void)? = nil) -> AlertController {
        let alert = AlertController(title: title, message: message)
        alert.addAction(AlertAction(title: "OK", style: .cancel, handler: completion))
        return alert
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.stackViewTextFields.arrangedSubviews.count > 0 {
            (self.stackViewTextFields.arrangedSubviews.first as! UITextField).becomeFirstResponder()
        }
    }
    @IBAction private func backgroundViewTaped(_ sender: UITapGestureRecognizer) {
        if dismissOnTouchOutside {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.view.endEditing(true)
        }
    }
    
    @objc private func actionButtonTapped(_ action: AlertAction) {
        self.dismiss(animated: true, completion: nil)
        action.handler?()
        action.handlerWithArg?(action)
    }
    
    private func updateBodyViewConstraints() {
        let allViews:[UIView] = [titleLabel,
                                 customViewPlaceholder,
                                 descriptionLabel,
                                 stackViewTextFields]
        
        let isActive:[Bool] = [titleLabel.text != nil || titleLabel.attributedText != nil,
                               customView != nil,
                               descriptionLabel.text != nil || descriptionLabel.attributedText != nil,
                               stackViewTextFields.arrangedSubviews.count > 0]
        
        var constant:CGFloat = 16
        for i in 0..<allViews.count {
            if isActive[i] {
                allViews[i].constraint(attribute: .top)?.constant = constant
                constant = 6
            } else {
                allViews[i].constraint(attribute: .top)?.constant = 0
            }
            
        }
        allViews.last!.constraint(attribute: .bottom)?.constant = isActive.contains(true) ? 16 : 0
    }
    private func updateSeparatorColor() {
        self.horzSeparator.backgroundColor = self.separatorColor
        (self.stackViewButtons.arrangedSubviews as! [AlertAction]).forEach {
            $0.borderColor = self.separatorColor
        }
    }
    

    // MARK: public properties
    var actions: [AlertAction] {
        return self.stackViewButtons.arrangedSubviews as! [AlertAction]
    }
    var alertTitle: String? {
        didSet {
            self.titleLabel.text = alertTitle
            self.updateBodyViewConstraints()
        }
    }
    var alertAttributedTitle: NSAttributedString? {
        didSet {
            self.titleLabel.attributedText = alertAttributedTitle
            self.updateBodyViewConstraints()
        }
    }
    var alertTitleColor: UIColor = UIColor.black {
        didSet {
            self.titleLabel.textColor = alertTitleColor
        }
    }

    var alertMessage: String? {
        didSet {
            self.descriptionLabel.text = alertMessage
            self.updateBodyViewConstraints()
        }
    }
    var alertAttributedMessage: NSAttributedString? {
        didSet {
            self.descriptionLabel.attributedText = alertAttributedMessage
            self.updateBodyViewConstraints()
        }
    }
    var alertMessageColor: UIColor = UIColor.black {
        didSet {
            self.descriptionLabel.textColor = alertMessageColor
        }
    }

    var separatorColor: UIColor = UIColor.gray {
        didSet {
            self.updateSeparatorColor()
        }
    }
    var alertBackgroundColor: UIColor = UIColor.clear {
        didSet {
            self.alertView.backgroundColor = alertBackgroundColor
        }
    }

    var customView: UIView? {
        didSet {
            self.updateBodyViewConstraints()
            oldValue?.removeFromSuperview()
            if let customView = customView {
                customView.translatesAutoresizingMaskIntoConstraints = false
                self.customViewPlaceholder.addSubview(customView)
                
                let views = ["view" : customView]
                self.customViewPlaceholder.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
                                                                                         options: [],
                                                                                         metrics: nil,
                                                                                         views: views))
                self.customViewPlaceholder.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view(\(customView.frame.size.height)@500)]-0-|",
                                                                                         options: [],
                                                                                         metrics: nil,
                                                                                         views: views))
            }
        }
    }
    var dismissOnTouchOutside = false

    // MARK: public functions
    func addAction(_ alertAction: AlertAction){
        self.horzSeparator.isHidden = false
        
        stackViewButtons.addArrangedSubview(alertAction)
        stackViewButtons.axis = stackViewButtons.arrangedSubviews.count > 2 ? .vertical : .horizontal

        alertAction.addTarget(self, action: #selector(AlertController.actionButtonTapped(_:)), for: .touchUpInside)
        alertAction.borderColor = self.separatorColor
        
        let rowCount = stackViewButtons.arrangedSubviews.count > 2 ? stackViewButtons.arrangedSubviews.count : 1
        buttonsViewMinimumHeightConstraint.constant = CGFloat(min(3.5, Double(rowCount)))*alertAction.intrinsicContentSize.height
        
        let buttons = stackViewButtons.arrangedSubviews as! [AlertAction]
        if buttons.count == 2 {
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                buttons.first!.borders = .left
            } else {
                buttons.first!.borders = .right
            }
        } else {
            for i in 0..<buttons.count-1 {
                buttons[i].borders = .bottom
            }
        }
        buttons.last!.borders = .none
    }
    func addTextField(configurationHandler handler: ((UITextField)->Void)?) {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14.0)
        textField.borderStyle = .roundedRect
        textField.delegate = self
        
        stackViewTextFields.arrangedSubviews.forEach {
            ($0 as! UITextField).returnKeyType = .next
        }
        
        stackViewTextFields.addArrangedSubview(textField)
        handler?(textField)
        
        self.updateBodyViewConstraints()
    }

}

extension AlertController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view === self.alertView || (touch.view?.isDescendant(of: self.alertView))!)
    }
}

extension AlertController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFields = stackViewTextFields.arrangedSubviews
        textField.resignFirstResponder()
        if let index = textFields.firstIndex(of: textField) {
            if index + 1 < textFields.count {
                (textFields[index+1] as! UITextField).becomeFirstResponder()
            }
        }
        
        return true
    }
}

extension UIView {
    func constraint(attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint?{
        if let constraint = self.constraint(attribute: attribute, in: self.constraints) {
            return constraint
        }
        if self.superview != nil, let constraint = self.constraint(attribute: attribute, in: self.superview!.constraints) {
            return constraint
        }
        return nil
    }
    
    private func constraint(attribute: NSLayoutConstraint.Attribute, in constraints: [NSLayoutConstraint]) -> NSLayoutConstraint? {
        for constraint in constraints {
            if (constraint.firstItem as! NSObject == self && constraint.firstAttribute == attribute) ||
               (constraint.secondItem != nil && constraint.secondItem as! NSObject == self && constraint.secondAttribute == attribute) {
                return constraint
            }
        }
        return nil
    }
}





