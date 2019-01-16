//
//  UIStoryboard.swift
//  
//
//  Created by Viktor Olesenko on 16.11.17.
//

import UIKit

extension UIStoryboard {
    
    convenience init(name: StoryboardName) {
        self.init(name: name.rawValue, bundle: nil)
    }
    
    func instantiateVC<T: UIViewController>(identifier: String = T.identifier) -> T {
        // swiftlint:disable force_cast
        let controller = self.instantiateViewController(withIdentifier: identifier) as! T
        // swiftlint:enable force_cast
        controller.removeBackButtonTitle()
        return controller
    }
    
    func instantiateInitialVC() -> UIViewController {
        return self.instantiateInitialViewController()!
    }
}
