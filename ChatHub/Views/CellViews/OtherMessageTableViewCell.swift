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
    
    private let messageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(red: 0.246, green: 0.316, blue: 0.707, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        addConstraints()
    }
    
    private func setupView() {
        contentView.addSubview(nameLabel)
        messageBackgroundView.addSubview(messageLabel)
        messageBackgroundView.addSubview(timeLabel)
        contentView.addSubview(messageBackgroundView)
        messageBackgroundView.clipsToBounds = true
        messageBackgroundView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.5),
            
            messageBackgroundView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            messageBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            messageBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            messageBackgroundView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.5),
            
            messageLabel.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 15),
            messageLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -15),
            messageLabel.leftAnchor.constraint(equalTo: messageBackgroundView.leftAnchor, constant: 10),
            messageLabel.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: -6),
            
            timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: -5),
            timeLabel.rightAnchor.constraint(equalTo: messageBackgroundView.rightAnchor, constant: -6),
            timeLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -6)
        ])
    }
    
    func configure(message: ChatMessage) {
        messageLabel.text = message.message
        nameLabel.text = message.userName
        if let date = message.timeStamp?.dateValue() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            timeLabel.text = dateFormatter.string(from: date)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
