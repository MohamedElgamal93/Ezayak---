import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//fonts
const double SMALL_ICON_FONT_SIZE = 10.0;
const double ICON_FONT_SIZE = 12.0;
const double LABEL_FONT_SIZE = 15.0;
const double BUTTON_FONT_SIZE = 18.0;
const double SUBTITLE_FONT_SIZE = 22.0;
const double TITLE_FONT_SIZE = 25.0;
const double EZYEK_FONT_SIZE = 35.0;

const String BOLD_FONT = "VodafoneFontRg-Bold";
const String REGULAR_FONT = "VodafoneFontRg-Regular";
const String ExBd = 'Vodafone-Font';
const String Lt_Regular = 'VodafoneLt-Regular';
const String AR_VODAFONE_LIGHT = 'vodafone_Ar_GE_SS_Two_Light';
const String AR_VODAFONE_MID = 'vodafone_Ar_GE_SS_Two_Medium';
const String AR_VODAFONE_BOLD = 'vodafone_Ar_GE_SS_Two_Bold';

//dimens
const double BUTTON_BORDER_RADIUS = 5.0;
const double V_SMALL_BUTTON_WIDTH_PERCENTAGE = 0.15;
const double M_SMALL_BUTTON_WIDTH_PERCENTAGE = 0.25;
const double SMALL_BUTTON_WIDTH_PERCENTAGE = 0.28;
const double BUTTON_WIDTH_PERCENTAGE = 0.35;
const double S_MID_BUTTON_WIDTH_PERCENTAGE = 0.45;
const double MID_BUTTON_WIDTH_PERCENTAGE = 0.50;
const double LARGE_BUTTON_WIDTH_PERCENTAGE = 0.70;
const double XLARGE_BUTTON_WIDTH_PERCENTAGE = 0.80;
const double BUTTON_HEIGHT_PERCENTAGE = 0.06;
const double LARGE_BUTTON_HEIGHT_PERCENTAGE = 0.095;
const double GENERAL_BUTTON_HEIGHT = 48;
const double LARGE_BUTTON_HEIGHT = 58;

//colors
const Color VODA_WHITE = Color(0xFFFFFFFF);
const Color VODA_RED = Color(0xFFE60000);
Color RED = Colors.red;
Color LITE_GREY = Colors.grey[300];
Color GREY = Colors.grey;
Color LITE_BLUE = Colors.cyan[200];
Color LITE_BLACK = Colors.black38;
Color BLACK = Colors.black;
Color TRANSPARENT = Colors.transparent;

const double OPACITY = 0.5;

//url End Point
const String AUTHENTICATE_URL = "/authenticate";
const String LOGIN_URL = "/login";
const String LOCALISATION_URL =
    "https://c8728bdc-4a3b-481b-9526-d33f7c62e974.mock.pstmn.io/demo";
const String GOOGLE_COM = "google.com";
const String APPLICATION_JSON = "application/json";
const String BEARER = "Bearer";

//routs
const String HOME_ROUT = "/Home";
const String LOGIN_ROUT = "/Login";
const String PIN_ROUT = "/PinScreen";
const String SPLASH_ROUT = "/PinScreen";
const String FINGERPRINT_ROUT = "/EnterFingerPrintScreen";
const String FAMILY_PROFILE = "/FamilyProfile";
const String FORM_ROUT = "/form";
const String CHAT_SCREEN_ROUT = "/ChatScreen";
const String CHAT_APP_ROUT = "/ChatApp";
const String CHANGE_PASSWORD_ROUT = "/ChangePass";
const String SIGNUP_ROUT = "/SignUp";
const String ONBOARDING_ROUT = "/OnBoardingPage";
const String LANDINGPAGE_ROUT = "/LandingPage";
const String USERPROFILE_ROUT = "/UserProfile";
const String PRIVACY_ROUT = "/PrivacyScreen";
const String CALENDER_ROUT = "/CalenderScreen";

//jsonKeys
const String KEY = "key";
const String ENGLISH_MESSAGE = "englishMessage";
const String ARABIC_MESSAGE = "arabicMessage";
const String CODE = "code";
const String MESSAGE = "message";
const String OTP_TOKEN = "pinCode";
const String JWT_TOKEN = "jwtToken";
const String LOGIN_JWT_TOKEN = "jwttoken";
const String IS_EXPIRED_DATE = "isExpiredDate";
const String USER_NAME = "username";
const String LOGIN_USER_NAME = "userName";
const String PASSWORD = "password";
const String USER_ID = "userId";
const String REQUEST_ID = "requestId";
const String USE_CASE_ID = "useCaseId";
const String RESULT = "result";
const String STATUS = "status";
const String TIME_STAMP = "key";
const String ERROR = "error";
const String LOGIN_TOKEN = "token";
const String OLD_PASSWORD = "oldPassword";
const String NEW_PASSWORD = "newPassword";
const String TEMP_PASSWORD = "tempPassword";
const String ID = "id";
const String VALUE = "value";

//notification
const String YOUR_CHANNEL_ID = "your channel id";
const String YOUR_CHANNEL_NAME = "your channel name";
const String YOUR_CHANNEL_DESCRIPTION = "your channel description";
const String SILENT_CHANNEL_ID = "silent channel id";
const String SILENT_CHANNEL_NAME = "silent channel name";
const String SILENT_CHANNEL_DESCRIPTION = "silent channel description";

//error cods
const String CODE_401 = "401";
const String CODE_9 = "9";
const String CODE_2 = "2";
const String CODE_1 = "1";
const String CODE_0 = "0";
const String CODE_40001 = "40001";
const String CODE_40002 = "40002";
const String CODE_40006 = "40006";
const String CODE_LOGOUT = "000";
const String KEY_INVALID_PINCODE = "Invalid Pincode";

//image assets
const String VODAFONE_SMALL_ICON = "assets/vodafone.png";
const String VODAFONE_BG = "assets/bg_c.png";
const String VODAFONE_READY_ICON = "assets/ready.png";
const String FINGERPRINT = "assets/fingerprint.png";
const String VFINGERPRINT = "assets/vfingerprint.png";
const String CORRECT = "assets/correct.png";
const String VODAFONE_NEXT_ICON = "assets/ic_next.png";
const String VODAFONE_SPLASH = "assets/splashBg.png";
const EZYEAK_LOGO = "assets/ezyeakLogo.png";
const SOS = "assets/sos.png";
const PROFILE = "assets/profile.png";
const String VODAFONE_SMALL = "assets/ic_vodafone.png";
const String IC_BACK = "assets/ic_back.png";
const String IC_LAUNCHER = "@mipmap/ic_launcher";
const String CORONA = "assets/icons8-coronavirus-64.png";
const String MAN_SIGN = "assets/malesign.png";
const String WOMAN_SIGN = "assets/woman.png";
const String MALE = "assets/male.png";
const String OLD_MAN = "assets/old-man.png";
const String WHEELCHAIR = "assets/wheelchair.png";
const String FEMALE = "assets/female.png";
const String PREGNANT = "assets/pregnant.png";
const String ELDERLY = "assets/elderly.png";
const String BOOK = "assets/book.png";
const String CAR = "assets/car.png";
const String COOK = "assets/cook.png";
const String GYM = "assets/gym.png";
const String SLEEP = "assets/sleep.png";
const String SOFA = "assets/sofa.png";
const String STUDYING = "assets/studying.png";
const String SWEEPING = "assets/sweeping.png";
const String WATCHING_TV = "assets/XMLID_757_.png";
const String WORKING_FROM_HOME = "assets/working-at-home.png";
const String WORKING_FROM_OFFICE = "assets/Office.png";
const String VF_ICON = "assets/vf_icon.png";
const String BLUE_HAPPY = "assets/blue_happy.png";
const String Green_HAPPY = "assets/green_happy.png";
const String ISSUE_HOME = "assets/issue_home.png";
const String ISSUE_WORK = "assets/issue_work.png";
const String MULTITASK = "assets/multitask.png";
const String NEUTRAL2 = "assets/neutral2.png";
const String NOT_GOOD = "assets/not_good.png";
const String SAD2 = "assets/sad2.png";
const String SAD3 = "assets/sad3.png";
const String SMILE2 = "assets/smile2.png";
const String WORRY = "assets/worry.png";
const String GROUP = "assets/group.png";
const String HEADACHE = "assets/headache.png";
const String HEAT = "assets/heat.png";
const String COUGH = "assets/cough.png";
const String MOUTH = "assets/mouth.png";
const String STOMACH = "assets/stomach.png";
const String QUESTION = "assets/question.png";
const String TUTORIAL = "assets/informatiosn.png";
const String F1 = "assets/F1.png";
const String F2 = "assets/F2.png";
const String F3 = "assets/F3.png";
const String F4 = "assets/F4.png";
const String F5 = "assets/F5.png";
const String F6 = "assets/F6.png";
const String F7 = "assets/F7.png";
const String F8 = "assets/F8.png";
const String F9 = "assets/F9.png";
const String F10 = "assets/F10.png";
const String F11 = "assets/F11.png";
const String F12 = "assets/F12.png";
const String F13 = "assets/F13.png";
const String SETTING = "assets/settings.png";

//shared preferences
const String LAST_VODAFONER_USER = "lastVodafonerUser";
const String LAST_USER = "lastUser";
const String TOKEN = "Token";
const String HAS_SPLUNK = "hasSplunk";
const String FINGERPRINT_LOGIN = "fingerprint_login";
const String FIRST_LOGIN = "first_login";
const String ACCEPT_PRIVACY = "accept_privacy";
const String PIN = "Pin";
const String PHONENUMBER = "phoneNumber";
const String NOTIFICATION_MESSAGE = "notification_message";

//status
const String SUCCESS = "SUCCESS";
const String PENDING = "PENDING";
const String FAILED = "FAILED";

//method name
const String HIDE_TEXT_INPUT = "TextInput.hide";

//scripts

const String RESEND_OTP = "Resend The OTP";

const String ENTER_OTP = "Please Enter the OTP";
const String HINT_MESSAGE = "hint_message";

const String SERVER_ERROR = "server_error";
const String INTERNET_ERROR = "internet_error";
const String ERROR_HAPPENED = "Error happened"; //
const String REQUEST_FAILED = "requestFailed"; //
const String TOKEN_EXPIRED = "token_expired";
const String TIME_OUT = "Client timeout";
const String LINE_BREAK = "\n";
const String NO_SUCH_METHOD_ERROR = " NoSuchMethodError";
const String SOCKET_EXCEPTION = " SocketException";
const String TIMEOUT_EXCEPTION = " TimeoutException";
const String HANDSHAKE_EXCEPTION = " HandshakeException";
const String FORMAT_EXCEPTION = " FormatException";
const String TYPE_ERROR = " TypeError";
const String STATUS_CODE = "statusCode:";

const String INVALID_NATIONAL_ID = "invalid_nationalID";
const String INVALID_NATIONAL_ID_OR_PASS = "invalid_nationalID_or_pass";
const String MATCH_PASSWORD = "match_password";
const String MANDATORY_FIELDS = "mandatory_fields";
const String INVALID_USER_OR_PASS = "invalid_user_or_pass";
const String INVALID_TOKEN = "invalid_token";
const String USER_EXPIRED_ERROR = "user_expired_error";
const String NATIONAL_ID_MANDATORY = "ational_id_mandatory";
const String PASSWORD_RESET_SUCCESS_MESSAGE = "password_reset";
const String SIGNUP_SUCCESS_MESSAGE = "success_signUp";
const String CONFIRM_PASSWORD = "confirm_password";
const String PASSWORD_POLICY = "password_policy";
const String VODAFONE_EMPLOYEE = "vodafone_employee";
const String NON_VODAFONE_EMPLOYEE = "non_vodafone_employee";
const String PRIVACY = "privacy";
const String ACCEPT = "accept";
const String TEMP_PASSWORD_FIELD = "temp_password";
const String NEW_PASSWORD_FIELD = "new_password";
const String OLD_PASSWORD_FIELD = "old_password";
const String WAITING = "Waiting.....";
const String FINGER_PRINT = 'finger_print';
const String FINGER_PRINT_MESSAGE = "finger_print_message";

const String NATIONAL_ID_TXT = "national_id";
const String USER_NAME_TXT = "user_name";
const String PASSWORD_TXT = "password";
const String SIGN_UP = "sign_up";
const String FORGET_IT = "forget_it";
const String FIRST_TIME = "first_time";
const String COPY_RIGHTS = "copyrights";
const String SERVICE_MANAGEMENT_SYSTEM = "Service";
const String SEND_BTN = "send_btn";
const String HOME = "Home";
const String SPLUNK_KPIS = "SPLUNK KPIs";
const String CHANGE_PASSWORD = "Change Password"; //
const String ABOUT = "About";
const String LOGOUT = "Logout";
const String LOGOUT_MESSAGE = "logout_message";
const String YES = "yes";
const String NO = "no";
const String WELCOME = "welcome";
const String OTP_HINT = "OTP";
const String RESEND_OTP_IN = "resend_otp_in";
const String LOGIN = "login";
const String LOGIN_TITLE = "login_title";
const String LOGIN_SUBTITLE = "login_subtitle";

const String LANGUAGE_CODE = "language_code";
const String COUNTRY_CODE = "countryCode";
const String AR_LANG = "ar_lang";
const String AR = "ar";
const String EN = "en";
const String US = "US";
const String EN_TXT = "En";

const String EZAYAK = "إزيك؟";
const String DASH = " - ";
const String NULL = "null";
const String STATUS_KEY = "Status : ";
const String AUTHORITIES = "authorities";
const String ROLE_SPLUNK = "ROLE_SPLUNK";
const String TRUE = "true";

//log keys
const String REQUEST = "request";
const String EXCEPTION = "Exception";
const String EXCEPTION_KEY = "Exception:";
const String LIST_SIZE = "list size:";
const String DOWN = "DOWN";
const String UP = "UP";
const String SCROLL_IN_Y_DIRECTION = "Scroll in Y Direction:";
// activity screen 
const String What_are_you_going_to_do_today = "What are you going to do today" ;
const String You_can_choose_more_than_1_activity = "You can choose more than 1 activity";
const String What_is_wrong = "What's wrong?";
const String Ok ="Ok";
const String I_have_issues_at_home = "I have issues at home";
const String I_have_issues_at_work = "I have issues at work";
const String Iam_tired = "I'm tired";
const String Iam_stressed ="I'm stressed";
const String Other ="Other";
const String Staying_home ="Staying home";
const String Working_from_home ="Working from home";
const String Working_from_office ="Working from office";
const String Going_out ="Going out";
const String Exercising ="Exercising";
const String Sleeping ="Sleeping";
const String Cooking ="Cooking";
const String Schooling_from_home ="Schooling from home";
const String Doing_house_chores ="Doing house chores";
const String Watching_TV ="Watching TV";
const String Doing_my_hobby ="Doing my hobby";

//calendar
const String Profile ="Profile";
const String Your_daily_mood ="Your daily mood";
const String Your_mood_during_the_month ="Your mood during the month";
const String Click_on_each_mood_to_know_more ="Click on each mood to know more";
const String Excellent = "Excellent";
const String Good = "Good";
const String Bad ="Bad";
const String Awful ="Awful";
const String Make_sure_that_you_are_connected_to_the_internet ="Make sure that you are connected to the internet";
const String Server_error_please_try_again ="Server error, please try again";

//chatbot
const String Loading ="Loading";
const String Please_allow_access_to_the_internal_space_of_the_device_settings ="Please allow access to the internal space of the device settings";
 const String Open ="Open";
 // covid_helper
 const String Fever ="Fever";
 const String Dry_cough ="Dry cough";
 const String Tiredness = "Tiredness";
 const String We_are_here_to_help_you = "We are here to help you";
 const String Do_you_have_COVID_19_symptoms = "Do you have COVID-19 symptoms?";
 const String You_feel_highly_exhausted_with_some_aches_and_pains ="You feel highly exhausted with some aches and pains";
  const String You_have_a_continuous_dry_cough ="You have a continuous dry cough";
  const String No ="No";
  const String Yes ="Yes";
  const String You_have_a_high_body_temperature_that_exceeds_37_4_degrees = "You have a high body temperature that exceeds 37.4 degrees";
//fingerprint
const String Sign_in_with_the_verification_code = "Sign in with the verification code" ;

//family_profile
const String This_field_cannot_be_empty = "This field cannot be empty";
const String Not_now ="Not now";
const String Name ="Name";
const String Mobile_number ="Mobile number";
const String Age ="Age";
const String Governorate ="Governorate";
const String Area ="Area";
const String Proceed = "Proceed";
const String Family_member_added ="Family member added";
const String Would_you_like_to ="Would you like to";
const String Registration ="Registration";
const String Family_member ="family member?";
const String Proceed_add_another_family_member ="Proceed & add another family member";
//helpDesk
const String Donot_panic_We_are_here_for_you ="Don’t panic! We are here for you";
const String We_are_connecting_you_now_with = "We are connecting you now with";
const String For_immediate_support_and_care ="for immediate support and care";
const String Click_here_to_start_the_call = "Click here to start the call";
//login

const String Ezayak = "Ezayak";
const String Stay_safe_every_day ="Stay safe every day";
const String Lets_go ="Let’s go";
const String First_Notifi ="Want to spend a healthy & happy day? Know more!";
const String Second_Notifi ="A new advice for you every day! Check them out now";
const String Third_Notifi ="Are you cooking today? Learn a new recipe with us!";
const String Fouth_Notifi ="Let's try some workouts together!";
const String Five_Notifi ="Take a break… and record your mood";
const String Sex_Notifi ="Planning your day? We can support you with some ideas!";
const String Seven_Notifi ="Going out? Read this advise first";
const String Eight_Notifi ="Help people.. Be happy.. Get on Ezayak now!";
const String Username ="Username";
const String Password ="Password";
const String CHANGE_LANGUAGE = "login_language";
const String ENGLISH_LANGUAGE = "English_language";
const String Arabic_LANGUAGE = "Arabic_language";

// moodsWidget
const String Hello =  "Hello";
const String How_are_you ="How are you?";
const String Next ="Next";
//onBoardingPage
const String Skip ="Skip";
const String Done ="Done";
//pin_screen
const String Write_down_the_verification_code ="Write down the verification code";
const String Send_an_SMS_with_the_verification_code ="Send an SMS with the verification code";
const String Enter_With_Finger_Print ="Enter With Finger Print";
const String Your_Verification_code_is_updated_successfully ="Your verification code is updated successfully";
//privacy
const String Your_privacy_matters_Read_this_privacy_policy_first ="Your privacy matters!Read this privacy policy first";
const String Introduce_yourself ="Introduce yourself";
//profilesHomePage
const String Profiles ="Profiles";
const String Update_your_profile_information ="Update your profile information";
const String My_profile ="My profile";
const String Add_a_new_family_member ="Add a new family member";
const String Add_the_new_members_information ="Add the new member's information";
const String Are_you_sure_you_want_to_delete_names_profile ="Are you sure you want to delete (name)'s profile?";
const String Are_you_sure_you_want_to_delete_your_account ="Are you sure you want to delete your account?Deleting your account will remove your & your family members' profiles and you will be signed out";
const String Select_your_location = "Select your location";
//UserProfile

const String Your_location_is_saved_successfully ="Your location is saved successfully";
const String Your_name ="Your name";
const String Your_Mobile_number ="Your mobile number";
const String Your_age ="Your age";
const String Your_location ="Your location";
 const String Please_allow_Ezayak_to_access_your_location ="Please allow Ezayak to access your location";
 const String Please_allow_the_site_to_access_the_device_settings ="Please allow the site to access the device settings";

 //App_Utils

 const String Are_you_sure_you_want_to_close_Ezayak="Are you sure you want to close Ezayak?";
 // BottomBar

 const String I_need_emergency_support ="I need emergency support";
 const String I_want_to_know_more_about_COVID ="I want to know more about COVID-19";
 const String App_tutorial ="App tutorial";
 const String I_want_to_contact ="I want to contact";
 const String I_need_more_support ="I need more support";
 //TopBar

 const String Back ="Back";
 const String Exit = "Exit";
//api Cleint 
const String No_content = "No content";