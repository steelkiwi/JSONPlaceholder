//
//  CommentListTVC.swift
//  JSONPlaceholder
//
//  Created by Viktor Olesenko on 15.01.19.
//

import UIKit

class CommentListTVC: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var idLabel       : UILabel!
    @IBOutlet private var postIdLabel   : UILabel!
    @IBOutlet private var nameLabel     : UILabel!
    @IBOutlet private var emailLabel    : UILabel!
    @IBOutlet private var bodyLabel     : UILabel!
    
    // MARK: - Variables
    
    var comment: Comment! {
        didSet {
            self.idLabel.text       = "\(comment.id)"
            self.postIdLabel.text   = "\(comment.postId)"
            self.nameLabel.text     = comment.name
            self.emailLabel.text    = comment.email
            self.bodyLabel.text     = comment.body
        }
    }
    
    // MARK: - Init
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset ui state
        self.idLabel.text       = nil
        self.postIdLabel.text   = nil
        self.nameLabel.text     = nil
        self.emailLabel.text    = nil
        self.bodyLabel.text     = nil
    }
    
    // MARK: - Actions
    
}
