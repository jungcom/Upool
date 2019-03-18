//
//  OfferedRidesSectionHeaderCollectionViewCell.swift
//  Upool
//
//  Created by Anthony Lee on 1/25/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit

struct headerType {
    static let today = "Today"
    static let tomorrow = "Tomorrow"
    static let laterRides = "Later Rides"
}

class OfferedRidesSectionHeaderCollectionViewCell: UICollectionViewCell {
    
    var date : DateComponents? = nil {
        didSet{
            if let date = date{
                let weekday = (calculateWeekDay(day: date.weekday!))
                let month = calculateMonth(month: date.month!)
                let day = date.day!
                let string = "\(weekday), \(month) \(day)"
                titleLabel.text = string
            }
        }
    }
    
    func calculateWeekDay(day : Int) -> String{
        switch day {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    }
    
    func calculateMonth(month : Int) -> String{
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = headerType.today
        label.font = UIFont(name: Fonts.futura, size: 18)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(titleLabel)
    }
    
    func setupConstraints(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant:20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
}
