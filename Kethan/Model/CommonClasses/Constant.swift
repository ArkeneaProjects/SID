//
//  Constant.swift
//  YupEasy
//
//  Created by Pankaj on 11/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit

struct APP_COLOR {
    static let color1 = UIColor(hexString: "#0985E9")
    static let color2 = UIColor(hexString: "#0985E9") //Blue
    static let color3 = UIColor(hexString: "#EC7677") //Annual Subscription
    static let color4 = UIColor(hexString: "#0985E9") //Monthly Subscription
    static let color5 = UIColor(hexString: "#999999") //Annual button
    static let color6 = UIColor(hexString: "#00AF44") //Green
    static let color7 = UIColor(hexString: "#E44F60") //Light Red

}

struct DEVICES {
    static let iPhoneSE: String = "iPhoneSE"
    static let iPhone6: String = "iPhone6"
    static let iPhonePlus: String = "iPhonePlus"
    static let iPhoneX: String = "iPhoneX"
    static let iPhoneXR: String = "iPhoneXR"
    //     static let iPhone_XS: String = "iPhone XS"
    //    static let iPhone_XS_Max: String = "iPhone XS Max"
}

struct KEYS {
    static let googleKey = "23307698272-psgd5pqvanqohndhmpu3en11t6o50ja9.apps.googleusercontent.com"
}

struct NOTIFICATIONS {
    static let googleUserUpdate = "googleUserUpdate"
}

struct STATICDATA {
    static let arrLeftItems = [["image": "profile", "text": "Profile"], ["image": "changeEmail", "text": "Change Email "], ["image": "changePassword", "text": "Change Password "], ["image": "upgradeSubscription", "text": "Upgrade Subscription"], ["image": "userWalkthrough", "text": "User Walkthrough"], ["image": "faqs", "text": "FAQs"], ["image": "termsOfService", "text": "Terms of Service"], ["image": "privacyPolicy", "text": "Privacy Policy"], ["image": "about", "text": "About the App"], ["image": "support", "text": "Support"]]
    static let implantDropDown = ["Skyline lateran", "Skyline x-ray", "Skyline lateran x-ray", "Skyline a:p lateran", "Skyline a:p lateran x-ray"]
    static let manufacturerDropDown = ["Depuy Skyline", "Depuy ab sky", "Depuy a: lateran ", "Depuy a: lateran x-ray "]
    static let arrSearch = [["image": "image1", "percent": "90 % match", "title": "Skyline a:p lateran ", "subTitle": "Depuy Skyline "], ["image": "image2", "percent": "70 % match", "title": "Spine clips Implant...", "subTitle": "Ruby Healthcare, Pune"], ["image": "image3", "percent": "50 % match", "title": "Lumbar Spine X-ra...", "subTitle": "SGS Healthcare Center."], ["image": "image4", "percent": "65 % match", "title": "Spine x-ray", "subTitle": "GE Healthcare, Pune"], ["image": "image1", "percent": "90 % match", "title": "Skyline a:p lateran", "subTitle": "Depuy Skyline "], ["image": "image2", "percent": "70 % match", "title": "Spine clips Implant...", "subTitle": "Ruby Healthcare, Pune"]]
    static let arrImages = ["image1", "image2", "image3", "image4", "image1"]
    static let arrImagesSmall = ["image1Small", "image2Small", "image3Small", "image4Small", "lineImage"]
    static let arrProcess = ["Locate presence of 1 or 2 rod implant by palpation. Refer for further examination if ", "Anesthetise at the incision site and under the end of the capsule with upto 1ml of 1% "]
    static let arrResponse = ["Locate presence of 1 or 2 rod implant by palpation. Refer for further examination if not located.", "Clean the sit with antiseptic solution", "Anesthetise at the incision site and under the end of the capsule with upto 1ml of 1% lignocaine (without epinephrine)", "Locate presence of 1 or 2 rod implant by palpation. Refer for further examination if not located.", "Anesthetise at the incision site and under the end of the capsule with upto 1ml of 1% lignocaine (without epinephrine)"]
    
    static let arrUserGuide = [["image": "step1", "title": "Leverage Artificial Intelligence", "subtitle": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"],
                            ["image": "step2", "title": "Search by names", "subtitle": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"],
                            ["image": "step3", "title": "Add Information", "subtitle": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"],
                            ["image": "step4", "title": "Refer & Earn", "subtitle": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"]]
    
    static let arrCreditHistory = [["image": "referral", "title": "Referral Rewards", "amount": "+ $ 20", "date": "November 20", "description": "Rewarded for being referred to SID by a friend"], ["image": "upload", "title": "Upload Images Rewards", "amount": "+ $ 10", "date": "November 19", "description": "Rewarded for being uploaded images on Database"], ["image": "referral", "title": "Referral Rewards", "amount": "+ $ 20", "date": "November 12", "description": ""], ["image": "bank", "title": "Credited in Bank", "amount": "- $ 120", "date": "November 10", "description": "Transfered to your bank account"], ["image": "referral", "title": "Referral Rewards", "amount": "+ $ 20", "date": "November 20", "description": "Rewarded for being referred to SID by a friend"]]
    
    static let arrSubscription = [["image": "monthlyBg", "price": "$2.99", "plan": "Monthly Plan", "valid": "Valid for 30 Days", "type": "month"], ["image": "annualBg", "price": "$4.99", "plan": "Annual Plan", "valid": "Valid for 365 Days", "type": "year"]]
}

struct IDENTIFIERS {
    static let LeftMenuTableViewCell = "LeftMenuTableViewCell"
    static let SearchListCollectionViewCell = "SearchListCollectionViewCell"
    static let CustomCollectionViewCell = "CustomCollectionViewCell"
    static let DetailRow1TableViewCell = "DetailRow1TableViewCell"
    static let DetailRow2TableViewCell = "DetailRow2TableViewCell"
    static let AddDetail1CollectionViewCell = "AddDetail1CollectionViewCell"
    static let AddDetailHeader1Cell = "AddDetailHeader1Cell"
    static let AddDetailHeader2Cell = "AddDetailHeader2Cell"
    static let AddDetailHeader3Cell = "AddDetailHeader3Cell"
    static let GuideCollectionViewCell = "GuideCollectionViewCell"
    static let CreditHistoryTableViewCell = "CreditHistoryTableViewCell"
    static let SubScriptionCollectionViewCell = "SubScriptionCollectionViewCell"
}

struct YESNO {
    static let yes = "Yes"
    static let no = "No"
}

struct STORYBOARD {
    static let main = "Main"
    static let signup = "SignUp"
    static let leftMenu = "LeftMenu"
}
