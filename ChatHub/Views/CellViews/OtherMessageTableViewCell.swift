//
//  OtherMessageTableViewCell.swift
//  ChatHub
//
//  Created by Arun on 20/02/24.
//

import UIKit

class OtherMessageTableViewCell: UITableViewCell {
    
    private static var backgroundColor = UIColor.systemIndigo
    
    static let identifier = String(describing: OtherMessageTableViewCell.self)
    
    let messageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        addConstraints()
    }
    
    private func setupView() {
        messageBackgroundView.addSubview(messageLabel)
        contentView.addSubview(messageBackgroundView)
        messageBackgroundView.clipsToBounds = true
        messageBackgroundView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            messageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            messageBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            messageBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            messageBackgroundView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.5),
            
            messageLabel.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 15),
            messageLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -15),
            messageLabel.leftAnchor.constraint(equalTo: messageBackgroundView.leftAnchor, constant: 10),
            messageLabel.rightAnchor.constraint(equalTo: messageBackgroundView.rightAnchor, constant: -10),
        ])
    }
    
    func configure(message: ChatMessage) {
        messageLabel.text = message.message
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
