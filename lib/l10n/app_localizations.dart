import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @pick_one.
  ///
  /// In en, this message translates to:
  /// **'Pick One'**
  String get pick_one;

  /// No description provided for @guardian.
  ///
  /// In en, this message translates to:
  /// **'Guardian'**
  String get guardian;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Docter'**
  String get doctor;

  /// No description provided for @real_time.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Monitoring '**
  String get real_time;

  /// No description provided for @real_time_desc.
  ///
  /// In en, this message translates to:
  /// **'Monitor heart rate, oxygen level, and locations anytime, anywhere'**
  String get real_time_desc;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get create_account;

  /// No description provided for @emergency_alert.
  ///
  /// In en, this message translates to:
  /// **'Emergency Alerts'**
  String get emergency_alert;

  /// No description provided for @emergency_desc.
  ///
  /// In en, this message translates to:
  /// **'Connect in Minutes! Pair your child’s device and start monitoring instantly'**
  String get emergency_desc;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'skip'**
  String get skip;

  /// No description provided for @easy_setup.
  ///
  /// In en, this message translates to:
  /// **'Easy Setup'**
  String get easy_setup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forget_pass.
  ///
  /// In en, this message translates to:
  /// **'Forgot password? Reset your password'**
  String get forget_pass;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @donot_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? Sign Up'**
  String get donot_have_account;

  /// No description provided for @conf_pass.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get conf_pass;

  /// No description provided for @have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get have_account;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @surgery.
  ///
  /// In en, this message translates to:
  /// **'Surgery'**
  String get surgery;

  /// No description provided for @allergy.
  ///
  /// In en, this message translates to:
  /// **'Allergy'**
  String get allergy;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @donot_know.
  ///
  /// In en, this message translates to:
  /// **'I Donot Know'**
  String get donot_know;

  /// No description provided for @drug_allergy.
  ///
  /// In en, this message translates to:
  /// **'Drug Allergies'**
  String get drug_allergy;

  /// No description provided for @food_allergy.
  ///
  /// In en, this message translates to:
  /// **'Food Allergies'**
  String get food_allergy;

  /// No description provided for @enviro_allergy.
  ///
  /// In en, this message translates to:
  /// **'Environmental Allergies'**
  String get enviro_allergy;

  /// No description provided for @insect_allergy.
  ///
  /// In en, this message translates to:
  /// **'Insect Allergies'**
  String get insect_allergy;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @more_type.
  ///
  /// In en, this message translates to:
  /// **'More Than 1 Type of Allergies'**
  String get more_type;

  /// No description provided for @select_disease.
  ///
  /// In en, this message translates to:
  /// **'Select disease type'**
  String get select_disease;

  /// No description provided for @enter_name.
  ///
  /// In en, this message translates to:
  /// **'Enter Full Name'**
  String get enter_name;

  /// No description provided for @enter_phone.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get enter_phone;

  /// No description provided for @enter_birth.
  ///
  /// In en, this message translates to:
  /// **'Enter birth date'**
  String get enter_birth;

  /// No description provided for @select_gender.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get select_gender;

  /// No description provided for @select_surg.
  ///
  /// In en, this message translates to:
  /// **'Select surgery'**
  String get select_surg;

  /// No description provided for @select_allergy.
  ///
  /// In en, this message translates to:
  /// **'Select allergy'**
  String get select_allergy;

  /// No description provided for @cardiac.
  ///
  /// In en, this message translates to:
  /// **'Cardiac Arrhythmia'**
  String get cardiac;

  /// No description provided for @cyanotic.
  ///
  /// In en, this message translates to:
  /// **'Cyanotic Congenital'**
  String get cyanotic;

  /// No description provided for @choose_doctor.
  ///
  /// In en, this message translates to:
  /// **'Choose A Doctor'**
  String get choose_doctor;

  /// No description provided for @add_photo.
  ///
  /// In en, this message translates to:
  /// **'Add a profile photo'**
  String get add_photo;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @sara.
  ///
  /// In en, this message translates to:
  /// **'Dr Sara Mahmoud'**
  String get sara;

  /// No description provided for @ahmed.
  ///
  /// In en, this message translates to:
  /// **'Dr Ahmed El-Sayed'**
  String get ahmed;

  /// No description provided for @leila.
  ///
  /// In en, this message translates to:
  /// **'Dr Leila Hassan'**
  String get leila;

  /// No description provided for @child_overall.
  ///
  /// In en, this message translates to:
  /// **'Child Overall Health'**
  String get child_overall;

  /// No description provided for @ask_ai.
  ///
  /// In en, this message translates to:
  /// **'Ask The AI Guide'**
  String get ask_ai;

  /// No description provided for @ask_doctor.
  ///
  /// In en, this message translates to:
  /// **'Ask The Doctor'**
  String get ask_doctor;

  /// No description provided for @child_location.
  ///
  /// In en, this message translates to:
  /// **'Child Location'**
  String get child_location;

  /// No description provided for @heart_beats.
  ///
  /// In en, this message translates to:
  /// **'Heart Beats'**
  String get heart_beats;

  /// No description provided for @beat_no.
  ///
  /// In en, this message translates to:
  /// **'89'**
  String get beat_no;

  /// No description provided for @bpm.
  ///
  /// In en, this message translates to:
  /// **'bpm'**
  String get bpm;

  /// No description provided for @blood_pressure.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get blood_pressure;

  /// No description provided for @press_no.
  ///
  /// In en, this message translates to:
  /// **'100/75'**
  String get press_no;

  /// No description provided for @mmHg.
  ///
  /// In en, this message translates to:
  /// **'mmHg'**
  String get mmHg;

  /// No description provided for @blood_oxgyen.
  ///
  /// In en, this message translates to:
  /// **'Blood Oxygen'**
  String get blood_oxgyen;

  /// No description provided for @oxgy_no.
  ///
  /// In en, this message translates to:
  /// **'95%'**
  String get oxgy_no;

  /// No description provided for @spo2.
  ///
  /// In en, this message translates to:
  /// **'SPO2'**
  String get spo2;

  /// No description provided for @lang.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get lang;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @notfication.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notfication;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get color;

  /// No description provided for @rate_us.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rate_us;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share with a friend'**
  String get share;

  /// No description provided for @log.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get log;

  /// No description provided for @eng.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get eng;

  /// No description provided for @arb.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arb;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply Notification'**
  String get apply;

  /// No description provided for @color_theme.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get color_theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure'**
  String get sure;

  /// No description provided for @first_aid.
  ///
  /// In en, this message translates to:
  /// **'First Aid'**
  String get first_aid;

  /// No description provided for @heart_health.
  ///
  /// In en, this message translates to:
  /// **'Heart Health'**
  String get heart_health;

  /// No description provided for @lifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get lifestyle;

  /// No description provided for @read_more.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get read_more;

  /// No description provided for @great.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get great;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Child Location'**
  String get location;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get track;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @easy_desc.
  ///
  /// In en, this message translates to:
  /// **'Connect in Minutes! Pair your child’s device and start monitoring instantly'**
  String get easy_desc;

  /// No description provided for @no_account.
  ///
  /// In en, this message translates to:
  /// **'No account found for this email.'**
  String get no_account;

  /// No description provided for @wrong_pass.
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided for that user.'**
  String get wrong_pass;

  /// No description provided for @login_sucess.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully with Google 🎉'**
  String get login_sucess;

  /// No description provided for @reg_again.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email'**
  String get reg_again;

  /// No description provided for @email_first.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email first.'**
  String get email_first;

  /// No description provided for @pass_send.
  ///
  /// In en, this message translates to:
  /// **'Password Reset Email Sent'**
  String get pass_send;

  /// No description provided for @reset_link.
  ///
  /// In en, this message translates to:
  /// **'A reset link has been sent to your email. Please check your inbox to reset your password.'**
  String get reset_link;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get invalid_email;

  /// No description provided for @failed_email_send.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset email. Try again later.'**
  String get failed_email_send;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @return_six.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get return_six;

  /// No description provided for @sign_google.
  ///
  /// In en, this message translates to:
  /// **'Signin with Google'**
  String get sign_google;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enter_email;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @enter_reset.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email'**
  String get enter_reset;

  /// No description provided for @account_sucess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully 🎉. Please verify your email.'**
  String get account_sucess;

  /// No description provided for @acc_exists.
  ///
  /// In en, this message translates to:
  /// **'The account already exists for that email.'**
  String get acc_exists;

  /// No description provided for @password_weak.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak.'**
  String get password_weak;

  /// No description provided for @sign_sucess.
  ///
  /// In en, this message translates to:
  /// **'Signed up successfully with Google 🎉'**
  String get sign_sucess;

  /// No description provided for @pass_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get pass_match;

  /// No description provided for @sigup_google.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get sigup_google;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup;

  /// No description provided for @child_details.
  ///
  /// In en, this message translates to:
  /// **'child details'**
  String get child_details;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get phone;

  /// No description provided for @phone_rule.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 11 digits'**
  String get phone_rule;

  /// No description provided for @birth_date.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birth_date;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @child_invalid.
  ///
  /// In en, this message translates to:
  /// **'Child ID is invalid!'**
  String get child_invalid;

  /// No description provided for @choose_doc_first.
  ///
  /// In en, this message translates to:
  /// **'Please select a doctor first!'**
  String get choose_doc_first;

  /// No description provided for @choose_lang.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get choose_lang;

  /// No description provided for @choose_theme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get choose_theme;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @turn_off.
  ///
  /// In en, this message translates to:
  /// **'Turn Off'**
  String get turn_off;

  /// No description provided for @tap_rate.
  ///
  /// In en, this message translates to:
  /// **'Tap a star to rate the app!'**
  String get tap_rate;

  /// No description provided for @please_lang.
  ///
  /// In en, this message translates to:
  /// **'Please select language first'**
  String get please_lang;

  /// No description provided for @real_mont.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Monitoring'**
  String get real_mont;

  /// No description provided for @real_mont_desc.
  ///
  /// In en, this message translates to:
  /// **'Real time data access! View live heart rate, oxygen level, blood pressure'**
  String get real_mont_desc;

  /// No description provided for @instant_alert.
  ///
  /// In en, this message translates to:
  /// **'Instant Alerts'**
  String get instant_alert;

  /// No description provided for @instant_alert_desc.
  ///
  /// In en, this message translates to:
  /// **'Got Alerted Instantly! Receive emergency notifications when a child’s health is at risk '**
  String get instant_alert_desc;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @total_patients.
  ///
  /// In en, this message translates to:
  /// **'Total Patients'**
  String get total_patients;

  /// No description provided for @unstable_patient.
  ///
  /// In en, this message translates to:
  /// **'Unstable Patients'**
  String get unstable_patient;

  /// No description provided for @pat_danger.
  ///
  /// In en, this message translates to:
  /// **'Patients in Danger'**
  String get pat_danger;

  /// No description provided for @view_patients.
  ///
  /// In en, this message translates to:
  /// **'View Patients'**
  String get view_patients;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @case_studies.
  ///
  /// In en, this message translates to:
  /// **'Case Studies'**
  String get case_studies;

  /// No description provided for @ai_tech.
  ///
  /// In en, this message translates to:
  /// **'AI Technology'**
  String get ai_tech;

  /// No description provided for @family_support.
  ///
  /// In en, this message translates to:
  /// **'Family Support'**
  String get family_support;

  /// No description provided for @email_sent.
  ///
  /// In en, this message translates to:
  /// **'Email Sent'**
  String get email_sent;

  /// No description provided for @only_numbers.
  ///
  /// In en, this message translates to:
  /// **'Only numbers allowed'**
  String get only_numbers;

  /// No description provided for @doctor_details_saved.
  ///
  /// In en, this message translates to:
  /// **'Doctor details saved successfully'**
  String get doctor_details_saved;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
