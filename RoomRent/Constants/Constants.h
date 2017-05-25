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


//** App Defaults **//
//******************//
static float SIDEBAR_WIDTH = 300.0f;

static NSString *DEVICE_TYPE = @"1";
static NSString *DEVICE_TOKEN = @"diYcDiJx_cU:APA91bGcSXcN3ev27AuH8740hztSVahqU0rM1OyQNAA18vYrWZaoKk0gxo1R1ibjiSIyAQuodu-bWD6-N8-9nb9VGNXnMQAKap4AcI9gcarouXTZU6p6XMBmvoshe-CAWywIxIpnao9f";

static NSString *POSTS_ALL_STRING = @"all";
static NSString *POSTS_OFFER_STRING = @"offers";
static NSString *POSTS_REQUEST_STRING = @"asks";

static NSString *OFFER = @"1";
static NSString *REQUEST = @"2";



//** URLs **//
//**********//
static NSString *BASE_URL = @"http://192.168.0.143:81/api/v1";

static NSString *LOGIN_PATH = @"/login";
static NSString *LOGOUT_PATH = @"/logout";
static NSString *FORGOT_PASSWORD_PATH = @"/forgotpassword";
static NSString *SIGNUP_PATH = @"/register";

static NSString *GETFILE_PATH = @"/getfile/";

static NSString *IMAGE_UPLOAD_PATH = @"/upload";

static NSString *POST_PATH = @"/posts";
static NSString *MY_POST_PATH = @"/myposts/";
static NSString *USER_POST_PATH = @"/user/posts/";

static NSString *POST_BULKDELETE = @"/bulkdelete";

static NSString *APP_API_TOKEN = @"OD44GCYFpHYHcwYFTG1QsQBGPOLcHjk8OMOMPkd3Ew3RTaLX0ox2ES3UASxE";
//static NSString *USER_API_TOKEN = @"";



//** JSON KEYS **//
//***************//

//Account
static NSString *JSON_KEY_IDENTITY = @"identity";

static NSString *JSON_KEY_USER_ID = @"id";
static NSString *JSON_KEY_NAME = @"name";
static NSString *JSON_KEY_PHONE = @"phone";
static NSString *JSON_KEY_USERNAME = @"username";
static NSString *JSON_KEY_EMAIL = @"email";
static NSString *JSON_KEY_PASSWORD = @"password";
static NSString *JSON_KEY_PROFILE_IMAGE_URL_REQUEST = @"profile_image";
static NSString *JSON_KEY_PROFILE_IMAGE_URL = @"profile_image";
static NSString *JSON_KEY_API_TOKEN = @"api_token";
static NSString *JSON_KEY_CREATED_AT = @"created_at";

static NSString *JSON_KEY_DEVICE_TYPE = @"device_type";
static NSString *JSON_KEY_DEVICE_TOKEN = @"device_token";

static NSString *JSON_KEY_USER_OBJECT = @"user";

static NSString *JSON_KEY_CODE = @"code";
static NSString *JSON_KEY_MESSAGE = @"message";
static NSString *JSON_KEY_VALIDATION_ERROR = @"errors";

//POST
static NSString *JSON_KEY_POST_OBJECT = @"post";

static NSString *JSON_KEY_POST_ID = @"id";
static NSString *JSON_KEY_POST_TITLE = @"title";
static NSString *JSON_KEY_POST_DESCRIPTION = @"description";
static NSString *JSON_KEY_POST_NO_OF_ROOMS = @"no_of_rooms";
static NSString *JSON_KEY_POST_PRICE = @"price";
static NSString *JSON_KEY_POST_ADDRESS = @"address";
static NSString *JSON_KEY_POST_ADDRESS_LATITUDE = @"latitude";
static NSString *JSON_KEY_POST_ADDRESS_LONGITUDE = @"longitude";
static NSString *JSON_KEY_POST_IMAGES_REQUEST = @"images[]";
static NSString *JSON_KEY_POST_IMAGE = @"image";
static NSString *JSON_KEY_POST_IMAGES = @"images";
static NSString *JSON_KEY_POST_TYPE = @"post_type";

static NSString *JSON_KEY_POST_SLUG = @"slug";

static NSString *JSON_KEY_POST_OFFSET = @"offset";
static NSString *JSON_KEY_POST_IS_LAST_PAGE = @"is_last_page";



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
