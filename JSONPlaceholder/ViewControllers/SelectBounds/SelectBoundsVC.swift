//
//  SelectBoundsVC.swift
//  JSONPlaceholder
//
//  Created by Viktor Olesenko on 15.01.19.
//

import UIKit

class SelectBoundsVC: BaseVC, StoryboardInstatiatable {
    
    // MARK: - Outlets
    
    @IBOutlet private var lowerBoundTF: PlaceholderTF!
    @IBOutlet private var upperBoundTF: PlaceholderTF!
    
    // MARK: - Constants
    
    static let storyboardName: StoryboardName = .main
    
    // MARK: - Services
    
    private lazy var commentsService: CommentsNetworkServiceProtocol = CommentsNetworkService.init()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    private func initUI() {
        lowerBoundTF.keyboardType = .numberPad
        upperBoundTF.keyboardType = .numberPad
    }
    
    // MARK: - Actions
    
    @IBAction
    private func loadComments() {
        self.hideKeyboard()
        
        // Only numbers allowed
        guard let lowerRangeValue = Int(lowerBoundTF.textWrapped) else {
            lowerBoundTF.error = AppError.invalidValue
            return
        }
        
        // Should be > 0 - id starts from 1
        guard lowerRangeValue > 0 else {
            lowerBoundTF.error = AppError.custom(text: "Error.Range.NonPositive".localized())
            return
        }
        
        // Only numbers allowed
        guard let upperRangeValue = Int(upperBoundTF.textWrapped) else {
            upperBoundTF.error = AppError.invalidValue
            return
        }
        
        // Should be > 0 - id starts from 1
        guard upperRangeValue > 0 else {
            upperBoundTF.error = AppError.custom(text: "Error.Range.NonPositive".localized())
            return
        }
        
        // Upper bounds should be greated than lower
        guard upperRangeValue >= lowerRangeValue else {
            self.showAlert(message: "Error.Range.LowerBiggerThanUpper".localized())
            return
        }
        
        let range = (lowerRangeValue - 1)...upperRangeValue // id starts with '1', but index with '0'
        
        self.loaderShow()
        self.currentRequest = commentsService.commentsGet(idRange: range) { (comments, errors) in
            self.loaderHide()
            
            self.currentRequest = nil
            
            guard let comments = comments else {
                let errors = errors ?? ErrorsDict.init(error: NetworkError.serverError)
                self.handleErrors(errors: errors)
                return
            }
            
            let commentsVC = CommentListVC.instantiateVC()
            commentsVC.config(comments: comments, idRange: range)
            
            self.navigationController?.pushViewController(commentsVC, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension SelectBoundsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Allow backspace
        if string.isEmpty {
            return true
        }
        
        // Only numbers allowed
        guard let _ = Int(string) else {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide keyboard
        textField.resignFirstResponder()
        return true
    }
}
