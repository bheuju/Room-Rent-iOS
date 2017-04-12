//
//  Constants.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Constants_h
#define Constants_h

// login email verification response
//{
//    "code": "0018",
//    "message": "Email verified. Your account is active. Login to use Roomrent"
//}


//** URLs **//
//**********//
static NSString *BASE_URL = @"http://192.168.0.143:81/api/v1/";
static NSString *LOGIN_PATH = @"login";
static NSString *LOGOUT_PATH = @"logout";
static NSString *FORGOT_PASSWORD_PATH = @"forgetpassword";
static NSString *SIGNUP_PATH = @"register";

//static NSString *API_TOKEN = @"OD44GCYFpHYHcwYFTG1QsQBGPOLcHjk8OMOMPkd3Ew3RTaLX0ox2ES3UASxE";
//static NSString *USER_API_TOKEN = @"";

static NSString *DEVICE_TYPE = @"1";
static NSString *DEVICE_TOKEN = @"iOS Device";


//** JSON KEYS **//
//***************//
static NSString *JSON_KEY_IDENTITY = @"identity";

static NSString *JSON_KEY_USER_ID = @"id";
static NSString *JSON_KEY_NAME = @"name";
static NSString *JSON_KEY_PHONE = @"phone";
static NSString *JSON_KEY_USERNAME = @"username";
static NSString *JSON_KEY_EMAIL = @"email";
static NSString *JSON_KEY_PASSWORD = @"password";
static NSString *JSON_KEY_API_TOKEN = @"api_token";
static NSString *JSON_KEY_CREATED_AT = @"created_at";

static NSString *JSON_KEY_DEVICE_TYPE = @"device_type";
static NSString *JSON_KEY_DEVICE_TOKEN = @"device_token";


static NSString *JSON_KEY_USER_OBJECT = @"user";

static NSString *JSON_KEY_CODE = @"code";
static NSString *JSON_KEY_MESSAGE = @"message";
static NSString *JSON_KEY_VALIDATION_ERROR = @"errors";



//static NSString *JSON_KEY_IDENTITY = @"identity";
//
//static NSString *JSON_KEY_USER_ID = @"id";
//static NSString *JSON_KEY_NAME = @"name";
//static NSString *JSON_KEY_PHONE = @"phone";
//static NSString *JSON_KEY_USERNAME = @"userName";
//static NSString *JSON_KEY_EMAIL = @"email";
//static NSString *JSON_KEY_PASSWORD = @"password";
//static NSString *JSON_KEY_API_TOKEN = @"apiToken";
//static NSString *JSON_KEY_CREATED_AT = @"createdAt";
//
//static NSString *JSON_KEY_DEVICE_TYPE = @"deviceType";
//static NSString *JSON_KEY_DEVICE_TOKEN = @"deviceToken";
//
//
//static NSString *JSON_KEY_USER_OBJECT = @"user";
//
//static NSString *JSON_KEY_CODE = @"code";
//static NSString *JSON_KEY_MESSAGE = @"message";
//static NSString *JSON_KEY_VALIDATION_ERROR = @"errors";



//** Resonse Codes **//
//*******************//

// basic messages
static NSString *CODE_ERROR = @"0000";
static NSString *CODE_SUCCESS = @"0001";

// login messages
static NSString *CODE_LOGIN_SUCCESS = @"0011";
static NSString *CODE_LOGIN_ERROR = @"0012";

// registration messages
static NSString *CODE_REGISTER_SUCCESS = @"0013";
static NSString *CODE_VALIDATION_ERROR = @"0014";
static NSString *CODE_EMAIL_VERIFIED = @"0015";
static NSString *CODE_USER_NOT_REGISTERED = @"0016";
static NSString *CODE_UNABLE_TO_SEND_EMAIL = @"0017";

// logout message
static NSString *CODE_LOGOUT_SUCCESS = @"0020";

// profile update messages
static NSString *CODE_PASSWORD_DOES_NOT_MATCH = @"0021";
static NSString *CODE_EAMIL_NOT_FOUND = @"0022";
static NSString *CODE_PASSWORD_RESET_LINK_SENT = @"0023";
static NSString *CODE_PASSWORD_UPDATE_SUCCESS = @"0024";
static NSString *CODE_CONFIRM_PASSWORD_ERROR = @"0025";

// basic errors
static NSString *CODE_USER_UNVERIFIED = @"0031";
static NSString *CODE_USER_NOT_LOGGED_IN = @"0032";
static NSString *CODE_USER_ALREADY_ACTIVE = @"0033";
static NSString *CODE_PASSWORD_RESET_REQUEST = @"0034";

// invalid request
static NSString *CODE_INVALID_USER = @"0051";
static NSString *CODE_INVALID_TOKEN = @"0052";
static NSString *CODE_INVALID_REQUEST = @"0053";


#endif /* Constants_h */
