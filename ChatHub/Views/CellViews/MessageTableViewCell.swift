//
//  MyMessageTableViewCell.swift
//  ChatHub
//
//  Created by Arun on 20/02/24.
//

import UIKit
import SDWebImage

final class MessageTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: MessageTableViewCell.self)
    
    private var attachLabelTopToImageContainerViewBottom: NSLayoutConstraint?
    
    private var attachMessageViewToLeft: NSLayoutConstraint?
    
    private var attachMessageViewToRight: NSLayoutConstraint?
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private let messageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let imageContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let imageView1: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo")
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    private let imageView2: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo")
        view.layer.cornerRadius = 7
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let timeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .footnote)
        view.numberOfLines = 1
        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(UILayoutPriority.init(755), for: .horizontal)
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        imageContainerView.addArrangedSubview(imageView1)
        imageContainerView.addArrangedSubview(imageView2)
        messageBackgroundView.addSubview(imageContainerView)
        messageBackgroundView.addSubview(messageLabel)
        messageBackgroundView.addSubview(timeLabel)
        contentView.addSubview(messageBackgroundView)
    }
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            
            messageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            messageBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            messageBackgroundView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
            
            imageContainerView.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 5),
            imageContainerView.leftAnchor.constraint(equalTo: messageBackgroundView.leftAnchor, constant: 5),
            imageContainerView.rightAnchor.constraint(lessThanOrEqualTo: messageBackgroundView.rightAnchor, constant: -5),
            
            imageView1.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6 * 0.5),
            imageView2.widthAnchor.constraint(equalTo: imageView1.widthAnchor),
            
            imageView1.heightAnchor.constraint(equalTo: imageView1.widthAnchor),
            imageView2.heightAnchor.constraint(equalTo: imageView2.widthAnchor),
            
            
            //imageContainerView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
            
//            imageView1.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 0),
//            imageView1.leftAnchor.constraint(equalTo: imageContainerView.leftAnchor, constant: 0),
//            imageView1.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 0),
//            
//            imageView2.leftAnchor.constraint(equalTo: imageView1.rightAnchor, constant: 0),
//            
//            imageView2.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 0),
//            imageView2.rightAnchor.constraint(equalTo: imageContainerView.rightAnchor, constant: 0),
//            imageView2.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 0),
//            
//            imageView1.widthAnchor.constraint(equalToConstant:75),
//            imageView2.widthAnchor.constraint(equalTo: imageView1.widthAnchor),
//            
//            imageView1.heightAnchor.constraint(equalTo: imageView1.widthAnchor),
//            imageView2.heightAnchor.constraint(equalTo: imageView2.heightAnchor),
            
            messageLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -15),
            messageLabel.leftAnchor.constraint(equalTo: messageBackgroundView.leftAnchor, constant: 10),
            messageLabel.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: -5),
            
            timeLabel.rightAnchor.constraint(equalTo: messageBackgroundView.rightAnchor, constant: -5),
            timeLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -3),
        ])
        
        let constraint = messageLabel.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 15)
        constraint.priority = UILayoutPriority(500)
        constraint.isActive = true
        
        attachLabelTopToImageContainerViewBottom = messageLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 15)
        attachLabelTopToImageContainerViewBottom?.priority = UILayoutPriority.defaultLow
        attachLabelTopToImageContainerViewBottom?.isActive = true
        
        // Constraints used for shifting cell left/right
        attachMessageViewToLeft = messageBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15)
        attachMessageViewToLeft?.isActive = true
        attachMessageViewToRight = messageBackgroundView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15)
    }
    
    func configure(model: ChatMessage, _ myCell: Bool) {
        
        if myCell {
            attachMessageViewToLeft?.isActive = false
            attachMessageViewToRight?.isActive = true
        }
        else {
            attachMessageViewToRight?.isActive = false
            attachMessageViewToLeft?.isActive = true
        }
        
        if
            let images = model.attachedImageNames,
            images.isEmpty == false {
            
            imageContainerView.isHidden = false
            imageView1.isHidden = false
            
            attachLabelTopToImageContainerViewBottom?.priority = UILayoutPriority.defaultHigh
            
            imageView1.sd_setImage(with: .init(string: images[0]))
            
            if images.count == 2 {
                imageView2.isHidden = false
                imageView2.sd_setImage(with: .init(string: images[1]))
            }
            else {
                imageView2.isHidden = true
            }
        }
        else {
            imageView1.isHidden = true
            imageView2.isHidden = true
            imageContainerView.isHidden = true
            attachLabelTopToImageContainerViewBottom?.priority = UILayoutPriority.defaultLow
        }
        
        messageLabel.text = model.message
        
        if model.message.isEmpty {
            messageLabel.isHidden = true
        }
        else {
            messageLabel.isHidden = false
        }
        
        if let timeStamp = model.timeStamp {
            timeLabel.text = MessageTableViewCell.dateFormatter.string(from: timeStamp.dateValue())
            timeLabel.isHidden = false
        }
        else {
            timeLabel.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
