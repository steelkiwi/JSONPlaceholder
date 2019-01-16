//
//  ErrorDisplayable.swift
//
//
//  Created by Viktor Olesenko on 22.12.17.
//

import UIKit

protocol ErrorDisplayable: UIAccessibilityIdentification {
    var error: Error? { get set }
}
