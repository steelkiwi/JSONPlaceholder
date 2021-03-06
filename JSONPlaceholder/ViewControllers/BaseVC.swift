//
//  BaseVC.swift
//  2BLocal
//
//  Created by Viktor Olesenko on 11.06.18.
//  Copyright © 2018 Steelkiwi. All rights reserved.
//

import UIKit
import SKLocalizable
import SKExtensions
import PKHUD

class BaseVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var bottomConstraintForKeyboard: NSLayoutConstraint?
    
    // MARK: - Variables
    
    var isNavBarHidden: Bool = false {
        didSet {
            self.navigationController?.setNavigationBarHidden(isNavBarHidden, animated: true)
        }
    }
    
    // MARK: - Init
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        subscribeKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        hideKeyboard()
        unsubscribeKeyboard()
    }
    
    // MARK: - Keyboard

    private func subscribeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unsubscribeKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func keyboardHeight(_ notification: NSNotification) -> CGFloat {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return 0
        }
        // Take children VCs into account
        let keyboardY = UIApplication.shared.keyWindow!.convert(keyboardFrame.origin, to: self.view).y
        
        let bottomOffset = self.view.safeAreaInsets.bottom
        let kbHeight = self.view.bounds.height - keyboardY - bottomOffset
        
        return kbHeight
    }

    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        let bottomOffset = keyboardHeight(notification)
        setBottomConstraintForKeyboard(bottomOffset)
    }

    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        setBottomConstraintForKeyboard(0)
    }

    func setBottomConstraintForKeyboard(_ newValue: CGFloat) {
        guard bottomConstraintForKeyboard?.constant != newValue else { return }
        
        bottomConstraintForKeyboard?.constant = newValue
        animateLayout()
    }
    
    // MARK: - Layout

    func animateLayout() {
        UIView.animate {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Loader
    
    private var cancelAction: Block?
    
    func loaderShow(cancelAction: Block? = nil) {
        let loaderView = UIView.init(frame: CGRect.init(origin: .zero, size: .init(width: 140, height: 150)))
        loaderView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        loaderView.cornerRadius = 8
        
        let loader = UIActivityIndicatorView.init()
        loader.style = .whiteLarge
        loader.startAnimating()
        
        let cancelButton = UIButton.init()
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        cancelButton.borderWidth = 1
        cancelButton.borderColor = .white
        cancelButton.cornerRadius = 4
        cancelButton.addTarget(self, action: #selector(loaderCancel), for: .touchUpInside)
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let stack = UIStackView.init(arrangedSubviews: [loader, cancelButton])
        stack.axis = .vertical
        
        loaderView.addSubviewWithConstraints(stack, top: 0, left: 16, bottom: 16, right: 16)
        
        self.cancelAction = cancelAction
        
        PKHUD.sharedHUD.contentView = loaderView
        PKHUD.sharedHUD.show()
    }
    
    func loaderHide() {
        cancelAction = nil
        
        pullToRefresh?.endRefreshing()
        
        PKHUD.sharedHUD.hide()
    }
    
    @objc
    private func loaderCancel() {
        cancelAction?()
        cancelAction = nil
    }
        
    // MARK: - Pull-to-refresh
    
    private var pullToRefresh: UIRefreshControl?
    
    func addRefreshController(scrollView: UIScrollView, action: Selector) {
        self.pullToRefresh = UIRefreshControl.init()
        pullToRefresh?.tintColor = UIColor.Components.PullToRefresh.tintColor
        pullToRefresh?.addTarget(self, action: action, for: .valueChanged)
        
        scrollView.refreshControl = pullToRefresh
    }
    
    // MARK: - Error
    
    func handleErrors(errors: ErrorsDict) {
        
        var alertKey: String? // Only one error should be displayed as popup
        
        for (key, error) in errors {
            if let edisp = errorDisplayable(for: key) {
                edisp.error = error
            } else {
                alertKey = key
            }
        }
        
        if let key = alertKey,
            let error = errors[key] {
            self.showAlert(title: key, error: error)
        }
    }
    
    // MARK: - Alert
    
    func showAlert(title: String = "Error".localized(), error: Error) {
        self.showAlert(title: title, message: error.localizedDescription)
    }
    
    func showAlert(title: String? = nil, message: String!, buttonTitle: String! = "OK".localized(), action: ((UIAlertAction) -> Void)? = nil) {
        showAlert(title: title, message: message, buttons: [
            UIAlertAction.init(title: buttonTitle, style: .default, handler: action)
            ])
    }
    
    // MARK: - ErrorDisplayable
    
    func errorDisplayable(in view: UIView) -> Array<ErrorDisplayable> {
        var eds: Array<ErrorDisplayable> = []
        
        for subview in view.subviews {
            if let edisp = subview as? ErrorDisplayable { eds.append(edisp) }
            if subview.subviews.count > 0 { eds.append(contentsOf: errorDisplayable(in: subview)) }
        }
        
        return eds
    }
    
    func errorDisplayable(for identifier: String) -> ErrorDisplayable? {
        return errorDisplayable(in: self.view).first(where: { (edisp) -> Bool in
            let identifiers = edisp.accessibilityIdentifier?.trimmingCharacters(in: .whitespaces).components(separatedBy: ",")
            return identifiers?.contains(identifier) ?? false
        })
    }
    
    // MARK: - Actions    
    
}
