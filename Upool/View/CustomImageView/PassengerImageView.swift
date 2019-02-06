//
//  PassengerImageView.swift
//  Upool
//
//  Created by Anthony Lee on 2/5/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

class PassengerImageView: UIView {

    //let rideRequest : RideRequest?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //we use lazy properties for each view
    lazy var passengerLabel : UILabel = {
        let label = UILabel()
        label.text = "Anthony"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "MockProfileImage")
        contentView.contentMode = .scaleAspectFill
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 5
        return contentView
    }()
    
    lazy var statusLabel : UILabel = {
        let label = UILabel()
        let stringAtt : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont(name: Fonts.helvetica, size: 11)!,
            NSAttributedString.Key.foregroundColor : Colors.maroon]
        let myString = NSMutableAttributedString(string: "Pending...", attributes: stringAtt)
        label.attributedText = myString
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        addSubview(passengerLabel)
        addSubview(profileImageView)
        addSubview(statusLabel)
    }
    
    func setupConstraints(){
        //Constraint Passenger Label
        passengerLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        passengerLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        passengerLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        passengerLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
        
        //Constraint Passenger Profile Image
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier:0.9).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier:0.9).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        //Constraint Status Label
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func changeToJoined(){
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "CheckMark")
        let attachmentString = NSAttributedString(attachment: attachment)
        let stringAtt : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont(name: Fonts.helvetica, size: 11)!,
            NSAttributedString.Key.foregroundColor : Colors.maroon]
        let myString = NSMutableAttributedString(string: "Joined", attributes: stringAtt)
        myString.append(attachmentString)
        passengerLabel.attributedText = myString
    }

}
