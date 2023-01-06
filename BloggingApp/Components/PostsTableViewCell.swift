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
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.font = label.font.withSize(13)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(messageLabel)
        addSubview(timeLabel)
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFeedCell(withMessage message: String, time: String) {
        messageLabel.text = message
        timeLabel.text = time
    }
    
    private func setConstrains() {
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    }
}
