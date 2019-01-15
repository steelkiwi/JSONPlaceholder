//
//  XibView.swift
//  
//
//  Created by Viktor Olesenko on 05.12.17.
//

import UIKit
import SKExtensions

class XibView: UIControl {
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    /// Init view content
    func initialize() {
        guard let contentView = loadViewFromNib() else { return }
        backgroundColor = .clear
        
        self.addSubviewWithConstraints(contentView)
    }
    
    /// Load view from .xib file with passed name
    ///
    /// - Parameter nibName: Name of the .xib file. If nil - class name will be used
    /// - Returns: view, loaded from .xib file
    func loadViewFromNib(nibName: String? = nil) -> UIView! {
        let nib = UINib.init(nibName: nibName ?? "\(self.classForCoder)", bundle: nil)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            assertionFailure("Failed to load nib with given name")
            return UIView.init()
        }
        
        return view
    }
}

extension XibView {
    
    func animateLayout() {
        UIView.animate {
            self.layoutIfNeeded()
        }
    }
}
