//
//  CommentListVC.swift
//  JSONPlaceholder
//
//  Created by Viktor Olesenko on 15.01.19.
//

import UIKit

class CommentListVC: BaseVC, StoryboardInstatiatable {
    
    // MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Constants
    
    static let storyboardName: StoryboardName = .comments
    
    // MARK: - Services
    
    private lazy var commentsService: CommentsNetworkServiceProtocol = CommentsNetworkService.init()
    
    // MARK: - Variables
    
    private var comments: Array<Comment> = []
    private var idRange: ClosedRange<Int>!
    
    private var isNextPage: Bool = true
    
    // MARK: - Init
    
    func config(comments: Array<Comment>, idRange: ClosedRange<Int>) {
        self.comments = comments
        self.idRange  = idRange
    }
    
    // MARK: - Actions
    
    private func loadNextPage() {
        guard isNextPage else { return }
        
        guard let lastCommentId = comments.last?.id else { return }
        
        // Additional check, if last item from range was already loaded
        if lastCommentId == idRange.upperBound {
            isNextPage = false
            return
        }
        
        let range = lastCommentId...idRange.upperBound
        
        let request = commentsService.commentsGet(idRange: range) { (comments, errors) in
            self.loaderHide()
            
            guard let comments = comments else {
                let errors = errors ?? ErrorsDict.init(error: NetworkError.serverError)
                self.handleErrors(errors: errors)
                return
            }
            
            self.isNextPage = comments.count == Limit.Network.PageSize.commentList // Last page was loaded with not full amount of comments
            
            self.comments.append(contentsOf: comments)
            self.tableView.reloadData()
        }
        self.loaderShow {
            request.cancel()
            self.loaderHide()
        }
    }
}

// MARK: - UITableViewDataSource

extension CommentListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentListTVC = tableView.dequeueReusableCell()
        let comment = comments[indexPath.row]
        
        if comment == comments.last {
            self.loadNextPage()
        }
        
        cell.comment = comment
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CommentListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
