//
//  StoryboardInstatiatable.swift
//  2BLocal
//
//  Created by Viktor Olesenko on 08.08.18.
//  Copyright © 2018 Steelkiwi. All rights reserved.
//

import UIKit

protocol StoryboardInstatiatable {
    static var storyboardName: StoryboardName { get }
}

extension StoryboardInstatiatable where Self: UIViewController {
    
    static func instantiateVC() -> Self {
        let viewController: Self = UIStoryboard.init(name: storyboardName).instantiateVC() as Self
        
        return viewController
    }
}
