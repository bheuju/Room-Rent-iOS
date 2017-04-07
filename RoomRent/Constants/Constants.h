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
static NSString *DEVICE_TOKEN = @"";


//** JSON KEYS **//
//***************//
static NSString *KEY_USER_ID = @"id";
static NSString *KEY_NAME = @"name";
static NSString *KEY_PHONE = @"phone";
static NSString *KEY_USERNAME = @"username";
static NSString *KEY_EMAIL = @"email";
static NSString *KEY_PASSWORD = @"password";
static NSString *KEY_API_TOKEN = @"api_token";
static NSString *KEY_CREATED_AT = @"created_at";

static NSString *JSON_KEY_CODE = @"code";
static NSString *JSON_KEY_MESSAGE = @"message";


//** Resonse Codes **//
//*******************//

// basic messages
static NSString *ERROR = @"0000";
static NSString *SUCCESS = @"0001";

// login messages
static NSString *LOGIN_SUCCESS = @"0011";
static NSString *LOGIN_ERROR = @"0012";

// registration messages
static NSString *REGISTER_SUCCESS = @"0013";
static NSString *VALIDATION_ERROR = @"0014";
static NSString *EMAIL_VERIFIED = @"0015";
static NSString *USER_NOT_REGISTERED = @"0016";
static NSString *UNABLE_TO_SEND_EMAIL = @"0017";

// logout message
static NSString *LOGOUT_SUCCESS = @"0020";

// profile update messages
static NSString *PASSWORD_DOES_NOT_MATCH = @"0021";
static NSString *EAMIL_NOT_FOUND = @"0022";
static NSString *PASSWORD_RESET_LINK_SENT = @"0023";
static NSString *PASSWORD_UPDATE_SUCCESS = @"0024";
static NSString *CONFIRM_PASSWORD_ERROR = @"0025";

// basic errors
static NSString *USER_UNVERIFIED = @"0031";
static NSString *USER_NOT_LOGGED_IN = @"0032";
static NSString *USER_ALREADY_ACTIVE = @"0033";
static NSString *PASSWORD_RESET_REQUEST = @"0034";

// invalid request
static NSString *INVALID_USER = @"0051";
static NSString *INVALID_TOKEN = @"0052";
static NSString *INVALID_REQUEST = @"0053";


#endif /* Constants_h */
