//
//  PlaceholderTF.swift
//  2BLocal
//
//  Created by Viktor Olesenko on 13.06.18.
//  Copyright © 2018 Steelkiwi. All rights reserved.
//

import UIKit

class DeleteHandledTextField: UITextField {
    
    override func deleteBackward() {
        super.deleteBackward()
        
        sendActions(for: .editingChanged)
    }
}

class PlaceholderTF: XibView, ErrorDisplayable, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet internal var offsetTrailing: NSLayoutConstraint!
    
    @IBOutlet private var iconWrapView      : UIView!
    @IBOutlet private var iconImageView     : UIImageView!
    
    @IBOutlet internal var contentHeight    : NSLayoutConstraint! // Height of view with placeholder and textField
    
    @IBOutlet private var placeholderLabel  : UILabel!
    @IBOutlet private var placeholderBottomOffset: NSLayoutConstraint!
    
    @IBOutlet internal var textField        : DeleteHandledTextField!
    
    @IBOutlet private var viewSecureWrapView: UIView!
    @IBOutlet private var viewSecureButton  : UIButton!
    
    @IBOutlet private var underlineView     : UIView!
    
    @IBOutlet private var sublabelsView     : UIView!
    @IBOutlet private var errorLabel        : UILabel!
    @IBOutlet private var charactersCounter : UILabel!
    
    // MARK: - Variables
    
    @IBInspectable
    public var placeholderColor: UIColor = UIColor.Components.PlaceholderTF.placeholderDefault {
        didSet {
            self.placeholderLabel.textColor = placeholderColor
        }
    }
    
    @IBInspectable
    public var textColor: UIColor = UIColor.Components.PlaceholderTF.textDefault {
        didSet {
            self.textField.textColor = textColor
        }
    }
    
    @IBInspectable
    public var activeColor: UIColor = UIColor.Components.PlaceholderTF.highlightedDefault {
        didSet {
            self.tintColor = activeColor
        }
    }
    
    @IBInspectable
    public var underlineColor: UIColor = UIColor.Components.PlaceholderTF.underlineDefault {
        didSet {
            self.underlineView.backgroundColor = underlineColor
        }
    }
    
    @IBInspectable
    public var errorColor: UIColor = UIColor.Components.PlaceholderTF.errorDefault {
        didSet {
            self.errorLabel.textColor = errorColor
        }
    }
    
    @IBInspectable
    public var icon: UIImage? {
        didSet {
            iconWrapView.isHidden = icon == nil
            iconImageView.image = icon
        }
    }
    
    // TODO: VO - adapt for all ui components. For now used only for secure button
    @IBInspectable
    public var isLightMode: Bool = false {
        didSet {
//            self.viewSecureButton.setImage(#imageLiteral(resourceName: "icons_invisible").withRenderingMode(.alwaysTemplate), for: .normal)
//            self.viewSecureButton.setImage(#imageLiteral(resourceName: "icons_visible").withRenderingMode(.alwaysTemplate), for: .selected)
            self.viewSecureButton.tintColor = isLightMode ? .white : .black
        }
    }
    
    @IBInspectable
    public var isSecureText: Bool = false {
        didSet {
            self.isSecureTextEntry = isSecureText
            
            if isSecureText {
                viewSecureWrapView.isHidden = text.isBlank
            }
        }
    }
    
    @IBInspectable
    public var charactersCountLimit: Int = 0 // No limits if zero
    
    @IBInspectable
    public var isCharactersCounterVisible: Bool = false {
        didSet {
            self.updateSublabelsState()
            self.updateCharactersCounter()
        }
    }
    
    @IBInspectable
    public var movePlaceholderToTop: Bool = true {
        didSet {
            contentHeight.constant = movePlaceholderToTop ? (placeholderLabel.bounds.height + textField.bounds.height) : (textField.bounds.height)
        }
    }
    
    public var placeholder: String? {
        get { return placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }
    
    public var text: String? {
        get { return textField.text }
        set {
            let newText = charactersCountLimit == 0 ? newValue : newValue?.substring(to: charactersCountLimit)
            textField.text = newText
            
            if movePlaceholderToTop {
                self.placeholderAtTop = !newValue.isBlank
            } else {
                self.placeholderLabel.isHidden = !newValue.isBlank
            }
            
            self.triggerTextChanged()
        }
    }
    
    public var textWrapped: String {
        return textField.textWrapped
    }
    
    public var isEmpty: Bool {
        return textField.isEmpty
    }
    
    public var error: Error? {
        didSet {
            self.updateSublabelsState()
            
            if let error = error {
                errorLabel.text = error.localizedDescription
            } else {
                errorLabel.text = nil
            }
        }
    }
    
    @IBOutlet
    public weak var textFieldDelegate: UITextFieldDelegate?
    
    /// Determines, if textField is opened for editing
    private var placeholderAtTop: Bool = false {
        didSet {
            if placeholderAtTop {
                self.placeholderLabel.font = textField.font?.withSize(textField.font!.pointSize - 2)
                self.placeholderBottomOffset.constant = self.textField.bounds.height
            } else {
                guard textField.text.isBlank else { return }
                
                self.placeholderLabel.font = textField.font
                self.placeholderBottomOffset.constant = 0
            }
            
            self.animateLayout()
        }
    }
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initUI()
    }
    
    private func initUI() {
        self.tintColor = activeColor
        
        self.iconWrapView.isHidden = true
        
        self.movePlaceholderToTop = true
        
        self.placeholderLabel.textColor = placeholderColor
        self.placeholderLabel.font = textField.font
        self.placeholderBottomOffset.constant = 0
        
        self.textField.textColor = textColor
        
        self.viewSecureWrapView.isHidden = !isSecureTextEntry
        self.viewSecureButton.imageView?.contentMode = .scaleAspectFit
        
        self.isLightMode = false // Set default value to call didSet trigger
        
        self.underlineView.backgroundColor = underlineColor
        
        self.error = nil
        self.errorLabel.textColor = errorColor
        
        self.charactersCounter.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction private func onStartEditing(_ sender: UITapGestureRecognizer) {
        self.textField.becomeFirstResponder()
    }
    
    @IBAction private func changeSecureTextVisibility() {
        self.viewSecureButton.isSelected = !self.viewSecureButton.isSelected
        
        let font = textField.font // Should store current font before changing isSecureTextEntry
        textField.font = nil
        textField.isSecureTextEntry = !self.viewSecureButton.isSelected
        textField.font = font
    }
    
    private func updateSublabelsState() {
        let isError       = self.error != nil
        let isCharCounter = self.isCharactersCounterVisible
        
        UIView.animate {
            self.sublabelsView.isHidden = !(isError || isCharCounter)
        }
    }
    
    private func updateCharactersCounter() {
        self.charactersCounter.isHidden = !self.isCharactersCounterVisible
        
        guard isCharactersCounterVisible else {
            self.charactersCounter.text = nil
            return
        }
        
        self.charactersCounter.text = "\(self.text?.count ?? 0)/\(charactersCountLimit)"
    }
    
    private func triggerTextChanged() {
        if isSecureText {
            self.viewSecureWrapView.isHidden = textField.text.isBlank
        }
        
        if !placeholderAtTop {
            self.placeholderLabel.isHidden = !textField.text.isBlank
        }
        
        self.updateCharactersCounter()
    }
    
    @IBAction public func textFieldTextDidChanged(_ textField: UITextField) {
        self.triggerTextChanged()
        
        sendActions(for: .editingChanged)
    }

    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let isAllowBeginEditing = textFieldDelegate?.textFieldShouldBeginEditing?(textField) ?? true
        
        return isAllowBeginEditing
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidBeginEditing?(textField)
        
        if movePlaceholderToTop {
            self.placeholderAtTop = true
        }
        
        placeholderLabel.textColor      = activeColor
        underlineView.backgroundColor   = activeColor
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let isAllowEndEditing = textFieldDelegate?.textFieldShouldEndEditing?(textField) ?? true
        
        return isAllowEndEditing
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidEndEditing?(textField)
        
        if movePlaceholderToTop {
            self.placeholderAtTop = !textField.text.isBlank
        }
        
        placeholderLabel.textColor      = placeholderColor
        underlineView.backgroundColor   = underlineColor
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Reset error label
        if let _ = error { self.error = nil }
        
        let changeAllowed = textFieldDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
        
        if changeAllowed && charactersCountLimit != 0 {
            let proposedString = (textField.textWrapped as NSString).replacingCharacters(in: range, with: string)
            guard proposedString.count <= charactersCountLimit else {
                self.text = proposedString // Clip text manually in didSet
                self.textFieldTextDidChanged(textField)
                return false
            }
        }
        
        return changeAllowed
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return textFieldDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let delegateShouldReturn = textFieldDelegate?.textFieldShouldReturn?(textField) {
            return delegateShouldReturn
        }
        
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - First Responder

extension PlaceholderTF {
    
    override var canBecomeFirstResponder: Bool {
        return self.textField.canBecomeFirstResponder
    }
    
    override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    override var isFirstResponder: Bool {
        return self.textField.isFirstResponder
    }
    
    override var canResignFirstResponder: Bool {
        return self.textField.canResignFirstResponder
    }
    
    override func resignFirstResponder() -> Bool {
        return self.textField.resignFirstResponder()
    }
}

// MARK: - UITextInputTraits

extension PlaceholderTF: UITextInputTraits {
    
    public var textAlignment: NSTextAlignment {
        get { return self.textField.textAlignment }
        set { self.textField.textAlignment = newValue }
    }
    
    public var autocapitalizationType: UITextAutocapitalizationType {
        get { return self.textField.autocapitalizationType }
        set { self.textField.autocapitalizationType = newValue }
    }
    
    public var autocorrectionType: UITextAutocorrectionType {
        get { return self.textField.autocorrectionType }
        set { self.textField.autocorrectionType = newValue }
    }
    
    public var spellCheckingType: UITextSpellCheckingType {
        get { return self.textField.spellCheckingType }
        set { self.textField.spellCheckingType = newValue }
    }
    
    @available(iOS 11.0, *)
    public var smartQuotesType: UITextSmartQuotesType {
        get { return self.textField.smartQuotesType }
        set { self.textField.smartQuotesType = newValue }
    }
    
    @available(iOS 11.0, *)
    public var smartDashesType: UITextSmartDashesType {
        get { return self.textField.smartDashesType }
        set { self.textField.smartDashesType = newValue }
    }
    
    @available(iOS 11.0, *)
    public var smartInsertDeleteType: UITextSmartInsertDeleteType {
        get { return self.textField.smartInsertDeleteType }
        set { self.textField.smartInsertDeleteType = newValue }
    }
    
    public var keyboardType: UIKeyboardType {
        get { return self.textField.keyboardType }
        set { self.textField.keyboardType = newValue }
    }
    
    public var keyboardAppearance: UIKeyboardAppearance {
        get { return self.textField.keyboardAppearance }
        set { self.textField.keyboardAppearance = newValue }
    }
    
    public var returnKeyType: UIReturnKeyType {
        get { return self.textField.returnKeyType }
        set { self.textField.returnKeyType = newValue }
    }
    
    public var enablesReturnKeyAutomatically: Bool {
        get { return self.textField.enablesReturnKeyAutomatically }
        set { self.textField.enablesReturnKeyAutomatically = newValue }
    }
    
    public var isSecureTextEntry: Bool {
        get { return self.textField.isSecureTextEntry }
        set { self.textField.isSecureTextEntry = newValue }
    }
}

// MARK: - Localization

extension PlaceholderTF {
    
    @IBInspectable
    public var localizationPlaceholderKey: String? {
        get { return placeholderLabel.localizationKey }
        set { placeholderLabel.localizationKey = newValue }
    }
}
