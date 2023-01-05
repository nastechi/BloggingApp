//
//  PostsTableViewCell.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(messageLabel)
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelMessage(withMessage message: String) {
        messageLabel.text = message
    }
    
    private func setConstrains() {
        messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
