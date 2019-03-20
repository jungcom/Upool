//
//  Colors.swift
//  Upool
//
//  Created by Anthony Lee on 1/22/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//
import UIKit

struct FirebaseDatabaseKeys{
    static let usersKey = "users"
    static let ridePostsKey = "ridePosts"
    static let rideRequestsKey = "rideRequests"
    static let userMessagesKey = "user-Messages"
    static let messagesKey = "messages"
    
    struct UserFieldKeys{
        static let fcmToken = "fcmToken"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let gradYear = "gradYear"
        static let major = "major"
        static let profileImageUrl = "profileImageUrl"
        static let carImageUrl = "carImageUrl"
    }
    
    
}

struct Colors{
    static let maroon = UIColor(hex: 0xA23243)
    static let darkMaroon = UIColor(hex: 0x5A0936)
    static let moneyGreen = UIColor(hex: 0x1DA57B)
}

struct Fonts{
    static let helvetica = "Helvetica"
    static let futura = "Futura"
    static let futuraMedium = "Futura-Medium"
}

struct Strings{
    //LoginVC
    static let login = "Log In"
    static let passwordPlaceholder = " Password"
    static let emailPlaceholder = " Email"
    static let forgotPwd = "Forgot Password?"
    static let noAccount = "Don't have an account?"
    static let signUp = "Sign Up"
    
    //SignUpVC
    static let reEnterPasswordPlaceholder = "Re-enter Password"
    static let firstNamePlaceholder = "First Name"
    static let lastNamePlaceholder = "Last Name"
    static let acceptTermsAndConditions = "By creating an account, you agree to our "
    static let termsAndConditions = "Terms & Conditions"
}

struct Images{
    static let umassBackgroundImage = "UmassBackground"
    static let rightArrow = "right-arrow"
    static let leftArrow = "left-arrow"
}
