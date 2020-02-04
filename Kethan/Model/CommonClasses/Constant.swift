//
//  Constant.swift
//  YupEasy
//
//  Created by Pankaj on 11/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit

struct PLACEHOLDERS {
    static let profile = "default-user"
    static let medium = "placeholder_medium"
    static let large = "placeholder_larger"
    static let small = "placeholder_smaller"

}
struct UserDefaultsKeys {
    
    static let LoggedUser = "LoggedUser"
    static let BrandName = "BrandName"
    static let Manufecture = "Manufecture"
    static let ManufectureUpload = "ManufectureUpload"
}

struct APP_COLOR {
    static let color1 = UIColor(hexString: "#0985E9")
    static let color2 = UIColor(hexString: "#0985E9") //Blue
    static let color3 = UIColor(hexString: "#EC7677") //Annual Subscription
    static let color4 = UIColor(hexString: "#0985E9") //Monthly Subscription
    static let color5 = UIColor(hexString: "#999999") //Annual button
    static let color6 = UIColor(hexString: "#00AF44") //Green
    static let color7 = UIColor(hexString: "#E44F60") //Light Red
    
}

struct APP_FONT {
    
    static func regularFont(withSize: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: getCalculated(withSize))!
    }
    
    static func mediumFont(withSize: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Medium", size: getCalculated(withSize))!
    }
    
    static func boldFont(withSize: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: getCalculated(withSize))!
    }
}

struct DATEFORMATTERS {
    static let YYYYMMDDTHHMMSSZZZZZZ: String = "yyyy-MM-dd HH:mm:ss.zzzzzz"
    static let YYYYMMDDTHHMMSSZ: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let YYYYMMDDTHHMMSS: String = "yyyy-MM-dd HH:mm:ss"
    static let MMDDYYYY: String = "MM/dd/yyyy"
    static let MMDDYY: String = "MM/dd/yy"
    static let YYYYMMDD: String = "yyyy-MM-dd"
    static let DDMMYYYY: String = "dd-MM-yyyy"
    static let MMMMDDYYYY: String =  "MMMM dd, yyyy"
    static let YYYYMMMMDD: String = "yyyy-MMMM-dd"
    static let HHMM: String = "HH:mm"
    static let EMMMMDDYYYY: String = "E, MMMM dd, yyyy"
    static let DDMMMYYYY: String = "dd MMM yyyy"
    static let MMMYYYY: String = "MMM yyyy"
    static let MMYY = "MMMM yy"
    static let DDMMYY = "dd/MM/yy"
    static let DD = "dd"
    static let MMMDD: String = "MMM dd"
    static let HHMMA: String = "hh:mm a"
    static let DDMMM: String = "dd MMM"
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

struct APP_URLS {
    static let Live = "http://3.135.146.133:3000/api/"
    static let Development = "http://3.135.146.133:3000/api/"
    static var Domain: String {
        get {
            return Development
        }
    }
}

struct SUFFIX_URL {
    static let SignIn = "auth/signin"
    static let SignUp = "auth/signup"
    static let SignUPOTP = "auth/verifyOPT"
    static let SetPassword = "auth/setpassword"
    static let ForgotPassword = "auth/forgotPassword"
    static let SignupResendOTP = "auth/resendOTP"
    static let ForgotVerifyOTP = "auth/forgotPasswordVerifyOTP"
    static let TotalManufactureName = "implant/getTotalManufactureName"
    static let GetManufactureName = "implant/getMenufectureApi"
    static let SearchByText = "implant/searchByText"
    static let SearchByImage = "implant/analyzeImage"
    static let addImplant = "implant/addImpnatApi"
    static let editImplant = "implant/editImplantApi"
    static let UpdateProfile = "user/updateProfile"
    static let ChangeEmail = "auth/changeEmail"
    static let EmailVerifyOTP = "auth/changeEmailverifyOPT"
    static let changePassword = "auth/changePassword"
    static let SignOut = "auth/signout"
    static let Support = "support/create"
    static let subscriptionUpdate = "auth/subscriptionUpdate"
    static let DuplicateManufactureName = "implant/checkDuplicateApi"
    static let CheckEmail = "auth/checkEmail"
    static let SendEmail = "implant/sendDetailMail"
    static let GetCMSPage = "cms/getPages"
    static let Credit = "user/userCreditList"
}

struct KEYS {
    static let googleKey = "365325651862-j2dmt4k5f2hupc98roosv91fs78249j4.apps.googleusercontent.com"
    static let GooglePlacesAPIKey = "AIzaSyD0SJanDGyOB3Azx1lToYnh03ocyU2M4Hs"
}

struct NOTIFICATIONS {
    static let googleUserUpdate = "googleUserUpdate"
    static let verification = "verification"
    static let referral = "referral"
    static let subscription = "subscription"
}

struct SubscriptionPlans {
    static var Monitor50Patients = "com.telemedhome.Monitor50Patients"
    static var Monitor125Patients = "com.kethan.50"
}

struct STATICDATA {
    static var arrLeftItems = [["image": "profile", "text": "Profile"], ["image": "changeEmail", "text": "Change Email "], ["image": "changePassword", "text": "Change Password "], ["image": "upgradeSubscription", "text": "Upgrade Subscription"], ["image": "userWalkthrough", "text": "User Walkthrough"], ["image": "faqs", "text": "FAQs"], ["image": "termsOfService", "text": "Terms of Service"], ["image": "privacyPolicy", "text": "Privacy Policy"], ["image": "about", "text": "About the App"], ["image": "support", "text": "Support"]]
     static var arrLeftItemsWithoutEmail = [["image": "profile", "text": "Profile"], ["image": "upgradeSubscription", "text": "Upgrade Subscription"], ["image": "userWalkthrough", "text": "User Walkthrough"], ["image": "faqs", "text": "FAQs"], ["image": "termsOfService", "text": "Terms of Service"], ["image": "privacyPolicy", "text": "Privacy Policy"], ["image": "about", "text": "About the App"], ["image": "support", "text": "Support"]]
    static let implantDropDown = ["Skyline lateran Skyline lateran Skyline lateran Skyline lateran.", "Skyline x-ray", "Skyline lateran x-ray", "Skyline a:p lateran", "Skyline a:p lateran x-ray"]
    static let manufacturerDropDown = ["Depuy Skyline", "Depuy ab sky", "Depuy a: lateran ", "Depuy a: lateran x-ray "]
    static let arrSearch = [["image": "image1", "percent": "90 % match", "title": "Skyline a:p lateran ", "subTitle": "Depuy Skyline "], ["image": "image2", "percent": "70 % match", "title": "Spine clips Implant...", "subTitle": "Ruby Healthcare, Pune"], ["image": "image3", "percent": "50 % match", "title": "Lumbar Spine X-ra...", "subTitle": "SGS Healthcare Center."], ["image": "image4", "percent": "65 % match", "title": "Spine x-ray", "subTitle": "GE Healthcare, Pune"], ["image": "image1", "percent": "90 % match", "title": "Skyline a:p lateran", "subTitle": "Depuy Skyline "], ["image": "image2", "percent": "70 % match", "title": "Spine clips Implant...", "subTitle": "Ruby Healthcare, Pune"], ["image": "image1", "percent": "90 % match", "title": "Skyline a:p lateran ", "subTitle": "Depuy Skyline "], ["image": "image2", "percent": "70 % match", "title": "Spine clips Implant...", "subTitle": "Ruby Healthcare, Pune"], ["image": "image3", "percent": "50 % match", "title": "Lumbar Spine X-ra...", "subTitle": "SGS Healthcare Center."], ["image": "image4", "percent": "65 % match", "title": "Spine x-ray", "subTitle": "GE Healthcare, Pune"], ["image": "image1", "percent": "90 % match", "title": "Skyline a:p lateran", "subTitle": "Depuy Skyline "], ["image": "image2", "percent": "70 % match", "title": "Spine clips Implant...", "subTitle": "Ruby Healthcare, Pune"]]
    static let arrImages = ["image1", "image2", "image3", "image4", "image1"]
    static let arrImagesSmall = ["image1Small", "image2Small", "image3Small", "image4Small", "lineImage"]
    static let arrProcess = ["Locate presence of 1 or 2 rod implant by palpation. Refer for further examination if ", "Anesthetise at the incision site and under the end of the capsule with upto 1ml of 1% ", "Locate presence of 1 or 2 rod implant by palpation. Refer for further examination if ", "Anesthetise at the incision site and under the end of the capsule with upto 1ml of 1% "]
    static let arrResponse = ["Locate presence of 1 or 2 rod implant by palpation. Refer for further examination if not located.", "Clean the sit with antiseptic solution", "Anesthetise at the incision site and under the end of the capsule with upto 1ml of 1% lignocaine (without epinephrine)", "Locate presence of 1 or 2 rod implant by palpation. Refer for further examination if not located.", "Anesthetise at the incision site and under the end of the capsule with upto 1ml of 1% lignocaine (without epinephrine)"]
    
    static let arrUserGuide = [["image": "step1", "title": "Leverage Artificial Intelligence", "subtitle": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"],
                               ["image": "step2", "title": "Search by names", "subtitle": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"],
                               ["image": "step3", "title": "Add Information", "subtitle": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"],
                               ["image": "step4", "title": "Refer & Earn", "subtitle": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"]]
    
    static let arrCreditHistory = [["image": "referral", "title": "Referral Rewards", "amount": "+ $ 20", "date": "November 20", "description": "Rewarded for being referred to SID by a friend"], ["image": "upload", "title": "Upload Images Rewards", "amount": "+ $ 10", "date": "November 19", "description": "Rewarded for being uploaded images on Database"], ["image": "referral", "title": "Referral Rewards", "amount": "+ $ 20", "date": "November 12", "description": ""], ["image": "referral", "title": "Referral Rewards", "amount": "+ $ 20", "date": "November 20", "description": "Rewarded for being referred to SID by a friend"]]
    
    static let arrSubscription = [["image": "monthlyBg", "price": "$4.00", "plan": "Monthly Plan", "valid": "- Ability to search for implant via text and images. Add implant information for future references.\n- Auto-renewable. Cancel Anytime.\n- Valid for 30 Days\n\nPayment will be charged to iTunes Account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period. You can manage or disable subscription by going to the Account Settings after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.", "type": "month"], ["image": "annualBg", "price": "$50.00", "plan": "Annual Plan", "valid": "- Ability to search for implant via text and images. Add implant information for future references.\n- Earn Credits and redeem during next subscription. Cancel Anytime\n- Valid for 365 Days\n\nPayment will be charged to iTunes Account at confirmation of purchase. Subscription will not automatically renew for annual subscription at the end of the current period. Account will therefore not be charged. You can cancel subscription by going to the Account Settings after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable.", "type": "year"]]
    
     static let arrProfession = ["Surgeon", "Resident", "Medical Device Representative", "Other"]
     //static let arrProfession = ["Nurse", "Technical Advisor", "Surgical Advisor", "Doctor/Surgeon"]
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
    static let CreditTableViewCell = "CreditTableViewCell"
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

struct MESSAGES {
    static let uploadFailed = "Uploading is failed. Please try again."
    static let errorOccured = "Something went to wrong try after some time"
    static let invalidFormat = "Response format is invalid. Please try later."
    static let internetOffline = "The Internet connection appears to be offline."
    static let noPayment = "No payment account available for this user."
    static let errorInLocation = "We got an error while detecting your location. Please try again."
    static let emptySearch = "Enter either manufacture or either brand/name"
    static let selectManufacture = "First select manufacturer name"

}

struct ERRORS {
    static let CameraError = "Your device dose not support this feature!"
    static let emilId = "The Email ID must not be left blank"
    static let invalidEmail: String = "Enter valid email id"
    static let validMobileNumber: String = "It seems you have entered an incorrcect phone number"
    static let MobileNumberError: String = "Entered mobile number is invalid with selected country code"
    static let socialMediaError: String = "Something went to wrong try after some time"
    
    //SignUp
    static let firstName: String = "Please enter first name"
    static let middleName: String = "Please enter middle name"
    static let lastName: String = "Please enter last name"
    static let onlyDigit: String = "Please enter only numaric values"
    static let fullName: String = "Your name must not be left blank "
    static let profession: String = "Enter Profession"
    static let professionSelect: String = "Please select profession"
    static let amountSelect: String = "Please select credits option"
    
    //OTP
    static let otp: String = "You need to input the verification code in order to proceed"
    
    //change password
    static let oldPwdEmpty: String = "Your current password cannot be blank "
    static let newPwdEmpty: String = "You have to enter a new password"
    static let confirmPwdEmpty: String = "You have to confirm your new password "
    static let matchPwd: String = "The passwords do not match. Please try again"
    static let invalidPwd: String = "Password must be alpha numeric with 6-15 characters"
    static let invalidLenghtPwd: String = "Password should be atleast 6-15 characters"
    
    static let EmptyCountryCode = "Please select county"
    static let EmptyMobileNumber = "Please enter mobile number"
    static let WrongMobileNumber = "Please enter valid mobile number"
    
    static let EmptyOTP = "Please enter OTP"
    static let WrongOTP = "Please enter valid OTP"
    
    //Upload
    static let EmptyManufacturer = "Please enter manufacturer"
    static let EmptyBrandName = "Please enter implant name/brand"
    static let EmptyRemovalProcess = "Please add key features process"
    static let EmptyImage = "Please add implant image"
    
}

struct CONSTANT {
    static let Empty = ""
    static let device = "iPhone"
    static let server = "server"
    static let ResponseStatus = "response_status"
    static let success = "success"
    static let status = "status"
    static let ErrorCode = "statusCode"
    static let Message = "message"
    static let WebServiceName = "service_name"
    static let AccessToken = "access_token"
    static let DeviceToken = "device_token"
    static let DeviceType = "device_type"
    static let Ture = "success"
    static let data = "data"
    static let StatusCodeOne = "1"
    static let StatusCodeTwo = "2"
    static let auth = "auth"
}

struct ENTITIES {
    //signup
    static let countryCode = "country_code"
    static let email = "email"
    static let password = "password"
    static let name = "name"
    static let profession = "profession"
    static let referralCode = "referralCode"
    static let otp = "otp"
    static let resetOtp = "resetOtp"
    static let userImage = "userImage"
    
    //User
    static let accesstoken = "accessToken"
    static let userId = "userId"
    static let createdUserId = "createdUserId"
    static let isSocialMediaUser = "isSocialMediaUser"
    static let socialMediaToken = "socialMediaToken"
    static let socialPlatform = "socialPlatform"
    static let creditPoint = "creditPoint"
    static let match = "match"

    //SearchResult
    static let id = "id"
    static let createdDate = "createdDate"
    static let isApproved = "isApproved"
    static let isRejected = "isRejected"
    static let _id = "_id"
    static let objectName = "objectName"
    static let implantManufacture = "implantManufacture"
    static let brand = "brand"
    static let removImplant = "removImplant"
    static let imageData = "imageData"
    static let watsonImage_id = "watsonImage_id"
    static let createdOn = "createdOn"
    static let modifiedOn = "modifiedOn"
    static let implantImage = "implantImage"
    static let imageWidth = "imageWidth"
    static let imageHeight = "imageHeight"
    static let labelWidth = "labelWidth"
    static let labelHeight = "labelHeight"
    static let labelOffsetX = "labelOffsetX"
    static let labelOffsetY = "labelOffsetY"
    static let selectedImage = "selectedImage"

    //Implant
    static let removalProcess = "removalProcess"
    static let surgeryDate = "surgeryDate"
    static let surgeryLocation = "surgeryLocation"
    
    //ImageData
    static let imageName = "imageName"
    static let objectLocation = "objectLocation"
    static let imageObjective = "imageObjective"

    //ObjectLocation
    static let top = "top"
    static let left = "left"
    static let width = "width"
    static let height = "height"
    
    //Edit Profile
    static let contactNumber = "contactNumber"
    
    //Query
    static let query = "query"
    
    //Duplicate Manufature check
    static let manufacture = "manufacture"
    static let brandName = "brandName"
    
    //Send Mail
    static let implantId = "implantId"
    
    //Credit
    static let creditPoints = "creditPoints"
    static let isApprovedDate = "isApprovedDate"
    static let manufactur = "manufactur"
}
