//
//  OtherMessageTableViewCell.swift
//  ChatHub
//
//  Created by Arun on 20/02/24.
//

import UIKit

class OtherMessageTableViewCell: UITableViewCell {
    
    private static var backgroundColor = UIColor(red: 217, green: 216, blue: 216, alpha: 1)
    
    static let identifier = String(describing: OtherMessageTableViewCell.self)
    
    let messageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        messageBackgroundView.addSubview(messageLabel)
        contentView.addSubview(messageBackgroundView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            messageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            messageBackgroundView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            messageBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -10),
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
