import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Book Log'**
  String get appTitle;

  /// Subtitle shown on the login screen
  ///
  /// In en, this message translates to:
  /// **'Track your reading journey'**
  String get loginSubtitle;

  /// Title on the country selection screen
  ///
  /// In en, this message translates to:
  /// **'Select your region'**
  String get selectRegion;

  /// Korea option on the country selection screen
  ///
  /// In en, this message translates to:
  /// **'한국'**
  String get countryKorea;

  /// Other country option on the country selection screen
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get countryOther;

  /// Bottom nav label for books tab
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get navBooks;

  /// Bottom nav label for settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Title on the books list page
  ///
  /// In en, this message translates to:
  /// **'My Books'**
  String get myBooks;

  /// Empty state message on books page
  ///
  /// In en, this message translates to:
  /// **'No books registered yet'**
  String get noBooksYet;

  /// CTA on a book card with no sentences
  ///
  /// In en, this message translates to:
  /// **'Record your first sentence'**
  String get recordFirstSentence;

  /// Fallback text when a book cover image is missing
  ///
  /// In en, this message translates to:
  /// **'No Cover'**
  String get noCover;

  /// Section header on book detail page
  ///
  /// In en, this message translates to:
  /// **'Saved Sentences'**
  String get savedSentences;

  /// Section subtitle when no sentences exist
  ///
  /// In en, this message translates to:
  /// **'Save a sentence you want to remember from this book'**
  String get noSentencesHint;

  /// Section subtitle when sentences exist and one is representative
  ///
  /// In en, this message translates to:
  /// **'{count} sentences, one selected as representative'**
  String sentencesWithRepresentative(int count);

  /// Section subtitle when sentences exist but none is representative
  ///
  /// In en, this message translates to:
  /// **'{count} sentences · Choose a representative sentence'**
  String sentencesChooseRepresentative(int count);

  /// Dialog title for setting representative sentence
  ///
  /// In en, this message translates to:
  /// **'Set as representative sentence?'**
  String get setRepresentativeTitle;

  /// Dialog body for setting representative sentence
  ///
  /// In en, this message translates to:
  /// **'This sentence will be marked as the representative sentence for this book.'**
  String get setRepresentativeContent;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button label for setting representative sentence
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get setConfirm;

  /// Snackbar on success setting representative sentence
  ///
  /// In en, this message translates to:
  /// **'Set as representative sentence'**
  String get representativeSetSuccess;

  /// Snackbar on failure setting representative sentence
  ///
  /// In en, this message translates to:
  /// **'Failed to set representative sentence'**
  String get representativeSetFailed;

  /// Chip label when no sentences are recorded
  ///
  /// In en, this message translates to:
  /// **'No recorded sentences'**
  String get noSentencesChip;

  /// Chip label showing sentence count
  ///
  /// In en, this message translates to:
  /// **'{count} sentences'**
  String sentenceCountChip(int count);

  /// Label above the representative sentence in book detail
  ///
  /// In en, this message translates to:
  /// **'Representative Line'**
  String get representativeLine;

  /// Placeholder when no representative sentence is set
  ///
  /// In en, this message translates to:
  /// **'No representative sentence yet'**
  String get noRepresentativeYet;

  /// Title of the recent sentence card
  ///
  /// In en, this message translates to:
  /// **'Recently saved sentence'**
  String get recentSentenceTitle;

  /// Empty state title in book detail
  ///
  /// In en, this message translates to:
  /// **'No saved sentences yet'**
  String get noSentencesYet;

  /// Empty state subtitle in book detail
  ///
  /// In en, this message translates to:
  /// **'Save a sentence you want to remember from this book.'**
  String get noSentencesSubtitle;

  /// Button label to add the first sentence
  ///
  /// In en, this message translates to:
  /// **'Save first sentence'**
  String get saveFirstSentence;

  /// Chip/button label indicating a representative sentence
  ///
  /// In en, this message translates to:
  /// **'Representative'**
  String get representativeChip;

  /// Button label to set a sentence as representative
  ///
  /// In en, this message translates to:
  /// **'Set as representative'**
  String get setAsRepresentative;

  /// Empty search state message on book search page
  ///
  /// In en, this message translates to:
  /// **'Search for a book by title or author'**
  String get searchForBook;

  /// Search field hint text
  ///
  /// In en, this message translates to:
  /// **'Title or author...'**
  String get searchFieldHint;

  /// Snackbar message when a book is successfully added
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" added'**
  String bookAdded(String title);

  /// Snackbar message when adding a book fails
  ///
  /// In en, this message translates to:
  /// **'Failed to add book'**
  String get failedToAddBook;

  /// Validation error when sentence field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a sentence'**
  String get sentenceRequired;

  /// Validation error when sentence exceeds 500 characters
  ///
  /// In en, this message translates to:
  /// **'Sentence must be 500 characters or less'**
  String get sentenceTooLong;

  /// Validation error when page number is not numeric
  ///
  /// In en, this message translates to:
  /// **'Enter page number as a number'**
  String get pageNumberOnly;

  /// AppBar title on sentence input page
  ///
  /// In en, this message translates to:
  /// **'Save sentence'**
  String get saveSentenceTitle;

  /// Form field label for sentence
  ///
  /// In en, this message translates to:
  /// **'Sentence'**
  String get sentenceLabel;

  /// Hint text for sentence text field
  ///
  /// In en, this message translates to:
  /// **'Enter a sentence you want to remember'**
  String get sentenceHint;

  /// Form field label for page number
  ///
  /// In en, this message translates to:
  /// **'Page number (optional)'**
  String get pageNumberLabel;

  /// Hint text for page number field
  ///
  /// In en, this message translates to:
  /// **'Ex: 142'**
  String get pageNumberHint;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// AppBar title on sentence card page
  ///
  /// In en, this message translates to:
  /// **'Sentence'**
  String get sentenceAppBarTitle;

  /// Title on the settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Section header for account info in settings
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Email label in settings
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Country label in settings
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// Logout button label
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Delete account button label and dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// Delete account confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to withdraw?\nAll data related to your account will be deleted.'**
  String get deleteAccountConfirm;

  /// Confirm withdrawal button label
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// Language label in settings
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// Korean language option
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get languageKorean;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Bestsellers section header on book search page
  ///
  /// In en, this message translates to:
  /// **'Bestsellers'**
  String get bestseller;

  /// CTA button on empty books page
  ///
  /// In en, this message translates to:
  /// **'+ Add your first book'**
  String get addFirstBook;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
