//
//  Fuelster_Constants.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 09/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation

let kappName     = "Fuelster"
let kstoryBoardName = "Main"
// let  kStripeKey = "pk_test_HWexv0EcvwROn2aNo8r9a58U" //TEST
let  kStripeKey = "pk_live_wtBvjfuMgYmTUSsDVJ3hZZAh" //Appstore

//let STAGING kStripeKey = "sk_live_4zlyfjMyw9uX57evRY3k7VB6"

 //APPSTORE Publishable key pk_live_wtBvjfuMgYmTUSsDVJ3hZZAh

let FLURRY_SESSIONID = "CXWB8Q8F7DVP7WQWDNX8"
let APPSTORE_LINK = "https://itunes.apple.com/us/app/fuelster/id1159229891?ls=1&mt=8"
let kAppStoreLink = "AppStoreLink"

// MARK: User Constants
let kUserFirstName = "firstName"
let kUserLastName = "lastName"
let kUserEmail = "email"
let kUserPhone = "phone"
let kUserPassword = "password"
let kUserAuthToken = "authToken"
let kUserRefreshToken = "refreshToken"
let kUserNewPassword = "newPassword"
let kUserOldPassword = "oldPassword"
let kUserRole = "role"
let kUserRoleKey = "user"

let kUserProfilePicture = "profilePicture"
let kUserName = "username"
let kUserId = "_id"
let kDeviceToken = "deviceToken"
// MARK: Vehicle Constants

let kVehicleTitle = "title"
let kVehicleMake = "make"
let kVehicleModel = "model"
let kVehicleNumber = "vehicleNumber"
let kVehicleFuel = "fuel"
let kVehiclePicture = "vehiclePicture"
let kVehicleId = "_id"
let kVehicleCard = "card"


// MARK: Credit Card

let kCardholderName = "cardholderName"
let kCardNumber = "cardNumber"
let kCardCvv = "cvv"
let kCardHolderName = "cardholderName"
let kCardExpiry = "expiry"
let kCardZipcode = "zipcode"
let kCardId = "_id"
let kCardType = "type"



//MARK: Truck

let kTruckNumber = "truckNumber"
let kTruckId = "_id"
let kTruckDriverId = "_id"



//MARK: Driver
let kDriver =  "driver"
let kDriverName = "name"
let kDriverFirstName = "firstName"
let kDriverLastName = "lastName"

let kDriverPhone = "phone"
let kDriverPhoto = "photo"
let kDriverCity = "city"
let kDriverState = "state"
let kDriverZipcode = "zipcode"


//MARK: Fuel

let kFuel = "fuel"
let kFuelType = "fuelType"
let kFuelPrice = "price"
let kFuelId = "_id"


//MARK: Orders
let kOrderLongitude = "lon"
let kOrderLatiitude = "lat"
let kOrderQuantity = "quantity"
let kOrderStatus = "status"
let kOrderCancelReason = "cancelReason"
let kOrderEstimatedTime = "estimatedTime"
let kOrderDeliveryTimee = "deliveryTime"
let kOrderRating = "rating"
let kOrderCreateAt = "createAt"
let kOrderUpdatedAt = "updatedAt"
let kOrderFlaggedBy = "flaggedBy"
let kOrderId = "_id"
let kOrderLocation = "location"
let kOrderUser = "user"
let kOrderVehicle = "vehicle"


//MARK: Notifications

let kNotificationSenderId = "_id"
let kNotificationSenderName = "name"
let kNotificationReceiverId = "_id"
let kNotificationReceiverName = "name"
let kNotificationIsViewed = "isViewed"
let kNotificationMessage = "message"
let kNotificationCreatedAt = "createdAt"
let kNotification = "cancelReason"
let kNotificationBody = "body"
let kNotificationAPS = "aps"
let kNotificationAlert = "alert"

//MARK: Location

let kLocationLongitude = "lon"
let kLocationLattitude = "lat"
let kLocationCreatedBy = "createdBy"
let kLocation = "location"


//MARK:API Status Codes
let krequestStatusCode = "statusCode"
let kRequestSuccessCode = 200
let kRequestError400 = 400
let kRequestError401 = 401
let kRequestError403 = 403
let kRequestError404 = 404
let kRequestError405 = 405
let kRequestError415 = 415
let kRequestError500 = 500
let kRequestError426 = 426

//MARK:API Status code Messages
let kUserSignUpSuccessMessage = "registered successfully"
let kUserSignUpError400Message = "Please provide email"
let kUserSignUpError401Message = 401
let kUserSignUpError403Message = 403
let kUserSignUpError404Message = 404
let kUserSignUpError405Message = 405
let kUserSignUpError415Message = 415
let kUserSignUpError500Message = 500
let kRequestErrorMessage = "message"
let kUserLoginSuccessMessage = 200


//MARK: Hud Show mesages
let kHudLoggingMessage = "Signing In..."
let kHudRegisteringMessage = "Registering..."
let kHudLoadingMessage = "Loading..."
let kHudWaitingMessage = "Please Wait..."


//MARK: Flurry Event mesages
let kFlurryLogin = "Sign In Tapped"
let kFlurryVehiclesList = "Vehicles list view populated"
let kFlurryAddNewVehicle = "Add Vehicle"
let kFlurryUpdateVehicle = "Editing Vehicle"
let kFlurryDeleteVehicle = "Delete vehicle"
let kFlurryForgotPassword = "Forgot Password"
let kFlurryResetPassowrd = "Reset Password"
let kFlurrySignOut = "Sign-out"

//MARK: URL EndPoints


//MARK: USER End Points

let kUserSignUp = "/register" //"/signup"
let kUserEmailVerify = "/verify/"
let kUserLogin = "/login"
let kUserForgotPassword = "/forgot-password"
let kUserResetPassword = "/change-password"
let kUserLogout = "/logout"
let kGetUsers = "/users/"
let kGetUserInfo = "/user/"
let kGetUserUpdate = "/user"


//MARK: VEHICLE End Points

let kVehicleSave = "/vehicle"
let kGetVehicles = "/vehicles/"
let kGetVehicleInfo = "/vehicle/"


//MARK: CARD End Points

let kCardSave = "/card"
let kGetCards = "/cards/"
let kGetCardInfo = "/card/"


//MARK: TRUCK End Points

let kTruckSave = "/truck"
let kGetTrucks = "/trucks"
let kGetTruckInfo = "/truck/"



//MARK: DRIVER End Points

let kDriverSave = "/driver"
let kGetDrivers = "/drivers"
let kGetDriverInfo = "/driver/"


//MARK: FUEL End Points

let kFuelSave = "/fuel"
let kGetFuels = "/fuels"
let kGetFuelInfo = "/fuel/"


//MARK: ORDERS End Points

let kOrderSave = "/order"
let kGetOrders = "/orders"
let kGetOrderEstimatedTime = "/estimated-time"


//MARK: NOTIFICATION End Points

let kNotificationSave = "/notification"
let kGetNotifications = "/notifications"
let kGetNotificationInfo = "/notifications/"


//MARK: LOCATION End Points

let kUpdateLocation = "/location/"

//MARK: Alert Messages
let kLoginAllDetailsMessage = "Enter a valid email address and password. Use \"Forgot Password\" option to reset your password."

let kLoginInvalidEmailMessage = "Enter a valid email address and password. Use \"Forgot Password\" option to reset your password."

let kforgotInvalidEmailMessage = "Enter valid email address."

let kSignupInvalidEmailMessage = "Enter the email address in the format someone@example.com"

let kPasswordRequiredMessage = "Enter your password."
let kSignUpAllDetailsMessage = "Fill in all the fields."
let kEmailvalidationMessage = "Enter your email address."

let kPhoneNumberValidationMessage = "Fill in a valid phone number."

let kPhoneNumberProfileValidationMessage = "Enter your mobile number"


let kPasswordValidationMessage = "Entered password does not the requirements. Please try again."
let kLoginErrorMessage = "Entered password does not the requirements. Please try again."
let kUserSignOutConfirmMessage = "Do you want to Sign out?"
let kPasswordValidationMaxLengthMessage = "Your password must have a minimum of 6 characters and a maximum of 20 characters."
let kUserNameValidationMaxLengthMessage = "Please enter valid Firstname and Lastname"
let kUsserPasswordResetMessage = "We have emailed instructions to reset your password."
let kUserProfileUpdatedMessage = "Profile updated successfully."

let kDeleteSureMessage = "Are you sure to delete vehicle?"
let kPleaseSelectValidCreditCard = "Please select Credit card."
let kVehicleUpdatedMeggage = "Vehicle updated successfully."
let kVehicleDeleteMessage = "Vehicle deleted successfully."
let kVehicleExistMessage = "You have  already added this vehicle.Please search for the vehicle from vehicle list."
let kVehicleCreatedMessage = "Vehicle added successfully"
let kDeleteCardMessage = "Do you want to delete card?"
let kVehicleTitleMessage = "Enter title for your vehicle."
let kVehicleLicensePlateMessage = "Enter vehicle License plate no."
let kVehicleValidLicensePlateMessage = "Enter valid vehicle License plate no."
let kVehicleManufacturerMessage = "Select Vehicle Manufacturer."
let kVehicleModelMessage = "Select Vehicle Model."
let kVehicleFuelTypeMessage = "Select Fuel type."

let kVehicleAllFields = "Fill in all the fields."



let kCardAssignMessage = "Please assign a card to selected vehicle."
let kNoSearchResults = "No results found."
let kFuelsterAboutUsMessage = "Fuelster exists because you have places to go and things to do. Fuelster provides On Demand fuel delivery to anyone looking to stop wasting time on trips to the gas station. Simply request fuel, leave your gas door open, then go about your day and come back filled-up. Our certified and friendly service team helps you enjoy an uninterrupted day and you pay the same amount as you would at your nearest gas station.  We care about your time, safety, security, savings, and convenience. Enjoy your day, you deserve it."
let kFuelsterAppUpdateMessage = "We are constantly updating the app for happy customers. Please install the latest version of the app from App Store."

//MARK : Alert Titles
let kErrorTitle = "Error"

let kLoginAllDetailsTitle = "Sign In"
let kPasswordRequiredTitle = "Password"
let kSignUpAllDetailsTitle  = "Sign up"
let kEmailvalidationTitle  = "Invalid email address."
let kEmailTitle = "E-mail"
let kPhoneNumberValidationTitle  = "Invalid phone number."
let kPasswordValidationTitle  = "Password"
let kLoginErrorTitle  = "Password"
let kDeleteSureTitle  = ""
let kPleaseSelectValidCreditCardTitle  = "Credit card"
let kPasswordValidationMaxLengthTitle  = "Password"
let kUserNameValidationMaxLengthTitle  = "Name validations"

let kVehicleUpdatedTitle  = "Vehicle"
let kDeleteCardTitle  = ""
let kPleaseSelectMakeTitle  = "Make"
let kCardTitle = "Card"
//MARK: Alert BUtton Titles

let kAlertRefresh = "Refresh"
let kAlertOK = "OK"
let kAlertSubmit = "Submit"
let kAlertUpdate = "Update"
let kAlertSignOut = "Sign out"
let kAlertCancel = "Cancel"
let kAlertDelete = "Delete"

//MARK: QA Suggest messages 
let kLocationNotFoundMessage = "We are unable to get your location. Please enable location service and try again."

//MARK: Stripe Messages&titles
let kStripeCardNumberErrorMessage = "Please enter valid card number."
let kStripeCardNameOnCardErrorMessage = "Your name on card is invalid"
let kStripeCardSecurityErrorMessage = "Your card's security code is invalid"
let kStripeCardExpirationDateErrorMessage = "Your card's expiration year is invalid"
let kStripeCardExpirationYearErrorMessage = "Expiration year is invalid"
let kStripeCardExpirationMonthErrorMessage = "Your card's expiration month is invalid"
let kStripeCardCVVErrorMessage = "Your card's CVV is invalid"
let kStripeCardCVVMaxMessage = "CVV requires at least 3 characters."



let kStripeCardDetailsErrorMessage = "Enter valid card details."

let kStripeCardNumberErrorTitle = "Invalid card number."
let kStripeCardNameOnCardErrorTitle = "Invalid name"
let kStripeCardExpirationDateErrorTitle = "Invalid Exp date"
let kStripeCardExpirationYearErrorTitle = "Invalid Exp date"
let kStripeCardExpirationMonthErrorTitle = "Invalid Exp date"
let kStripeCardCVVErrorTitle = "Invalid CVV"
let kStripeCardDetailsErrorTitle = ""



let POSTMETHOD = "POST"
let GETMETHOD = "GET"
let PUTMETHOD = "PUT"
let DELETEMETHOD = "DELETE"


//MARK: KVO PATH KEYS

let MYLOCATIONKEYPATH = "myLocationAddress"
let MYLOCATIONTITLE = "title"
let KVONEWVALUEKEY = "new"

//MARK Observer Key Paths

let ORDER_REFRESH_NOTIFICATION = "OrderDetailsRefresh"

//MARK: StoryBoard IDS and ViewControllers IDS
let VEHICLE_STORYBOARD = "Fuelster_Vehicle"
let VEHICLEVC = "Fuelster_Vehicle_ListVC"
let MAIN_STORYBOARD = "Main"
let MAINVC = "MainVC"
let MENUVC = "MenuVC"
let PROFILEVC = "ProfileVC"
let SETTINGSVC = "SettingsVC"
let ABOUTVC = "Fuelster_AboutUsVC"
let HELPVC = "HelpVC"
let ORDERHISTORYVC = "OrderHistoryVC"
let VEHICLE_ADDVC = "Fuelster_AddNewVehicle"
let ORDER_FUELVC = "OrderFuelVC"
let PAYMENTCARDSTORYBOARD = "PaymentCard"
let PAYMENTCARDVC = "PaymentCardsVC"
let ADDNEWCARDVC = "AddNewCardVC"
let VIEWCARDVC = "ViewCardVC"
let ORDER_DETAILVC = "OrderDetail"
let NAVIGATIONVC = "NavigationVC"


enum UserAPIType{
    case Login
    case Register
    case EmailVerification
    case ForgotPassword
    case ResetPassword
    case Logout
}


let OrderStatusNew = "New"
let OrderStatusAccepted = "Accepted"
let OrderStatusCompleted = "Completed"
let OrderStatusCancelled = "Canceled"

//MARK: ViewControllers Tittles and Strings

let MENU_HOME = "Home"
let MENU_ABOUT = "About Fuelster"
let MENU_PROFILE = "Profile"
let MENU_ORDER_HISTORY = "Order History"
let MENU_HELP = "Help"
let MENU_SETTINGS = "Settings"
let MENU_SIGNOUT = "Sign Out"

let VEHICLE_LIST_TITLE = "Select your vehicle"
let ADD_VEHICLE_TITLE = "Add Vehicle"
let UPDATE_VEHICLE_TITLE = "Update Vehicle"

let MYVEHICLE_LIST_TITLE = "My Vehicles"

let ADD_CARD_TITLE = "Add Card"
let ADD_NEW_CARD_TITLE = "Add New Card"
let CARDS_LIST_TITLE = "My Cards"

let HELP_TITLE = "HELP"
let SELECT_FUEL_TITLE = "Select your fuel"
let ORDER_PROCESSING_TITLE = "Order Processing"
let ORDER_DECLINED_TITLE = "Order Declined"
let ORDER_CONFIRMATION_TITLE = "Order COnfirmation"
let ORDER_TRACK_TITLE = "Track Order"
let ORDER_COMLETE_TITLE = "Order Complete"
let ORDER_DETAILS = "Order Details"
let CANCEL_REASONS = "Reasons for Cancellation"

//MARK : TABLEVIEWCELL 

let MENUCELL = "cell"
let PROFILECELL = "ProfileCell"
let ORDERHISTORYCELL = "OrderHistoryCell"
let LOADINGCELL = "LoadingCell"
let OrderHistoryCell2 = "OrderHistoryCell2"
let VEHICLE_LIST_CELL_NIB = "Fuelster_VehicleListCell"
let VEHICLE_LIST_CELL = "fuelster_VehicleListCell"

let MenuIcon = "Icon"
let MenuTitle = "Title"

//MARK:--- Credit card types
let CREDITCARD_EMPTY = "EMPTY"

//MARK: Image Constants

let MENU_HOME_IMAGE = "Home_small"
let MENU_ABOUT_IMAGE = "About_small"
let MENU_PROFILE_IMAGE = "Profile_small"
let MENU_ORDER_HISTORY_IMAGE = "Order_small"
let MENU_HELP_IMAGE = "Info_small"
let MENU_SETTINGS_IMAGE = "Settings_small"
let MENU_SIGNOUT_IMAGE = "Signout_small"

let NAVIGATION_BACK_IMAGE = "Back_Small"
let FUELSTER_SMALL_LOGO = "Logo_Small"
let CAR_GRAY_IMAGE = "Car_Gray"
let CAR_ORANGE_DOUBLE = "Car2_Orange"
let MENU_SMALL_IMAGE = "Menu_small"
let EMAIL_SMALL_IMAGE = "Email_small"
let PASSWORD_SMALL_IMAGE = "Password_small"
let CALL_IMAGE = "call_small"
let SAVE_IMAGE = "Save"
let CAMERA_IMAGE = "Camera"
let EDIT_SMALL_IMAGE = "Edit_Small"
let PROFILRPIC_PLACEHOLDER_IMAGE = "Profilepic"
let HELP_IMAGE = "HelpImage"
let ILLUSTRATION_IMAGE = "Illustration"
//MARK: RBAVALIDATOR CONSTANTS  

let kValidatorField = "Field"
let kValidatorFieldKey = "Key"
