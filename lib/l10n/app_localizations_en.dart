// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Book Log';

  @override
  String get loginSubtitle => 'Track your reading journey';

  @override
  String get selectRegion => 'Select your region';

  @override
  String get countryKorea => '한국';

  @override
  String get countryOther => 'Other';

  @override
  String get navBooks => 'Books';

  @override
  String get navSettings => 'Settings';

  @override
  String get myBooks => 'My Books';

  @override
  String get noBooksYet => 'No books registered yet';

  @override
  String get recordFirstSentence => 'Record your first sentence';

  @override
  String get noCover => 'No Cover';

  @override
  String get savedSentences => 'Saved Sentences';

  @override
  String get noSentencesHint => 'Save a sentence you want to remember from this book';

  @override
  String sentencesWithRepresentative(int count) {
    return '$count sentences, one selected as representative';
  }

  @override
  String sentencesChooseRepresentative(int count) {
    return '$count sentences · Choose a representative sentence';
  }

  @override
  String get setRepresentativeTitle => 'Set as representative sentence?';

  @override
  String get setRepresentativeContent => 'This sentence will be marked as the representative sentence for this book.';

  @override
  String get cancel => 'Cancel';

  @override
  String get setConfirm => 'Set';

  @override
  String get representativeSetSuccess => 'Set as representative sentence';

  @override
  String get representativeSetFailed => 'Failed to set representative sentence';

  @override
  String get noSentencesChip => 'No recorded sentences';

  @override
  String sentenceCountChip(int count) {
    return '$count sentences';
  }

  @override
  String get representativeLine => 'Representative Line';

  @override
  String get noRepresentativeYet => 'No representative sentence yet';

  @override
  String get recentSentenceTitle => 'Recently saved sentence';

  @override
  String get noSentencesYet => 'No saved sentences yet';

  @override
  String get noSentencesSubtitle => 'Save a sentence you want to remember from this book.';

  @override
  String get saveFirstSentence => 'Save first sentence';

  @override
  String get representativeChip => 'Representative';

  @override
  String get setAsRepresentative => 'Set as representative';

  @override
  String get searchForBook => 'Search for a book by title or author';

  @override
  String get searchFieldHint => 'Title or author...';

  @override
  String bookAdded(String title) {
    return '\"$title\" added';
  }

  @override
  String get failedToAddBook => 'Failed to add book';

  @override
  String get sentenceRequired => 'Please enter a sentence';

  @override
  String get pageNumberOnly => 'Enter page number as a number';

  @override
  String get saveSentenceTitle => 'Save sentence';

  @override
  String get sentenceLabel => 'Sentence';

  @override
  String get sentenceHint => 'Enter a sentence you want to remember';

  @override
  String get pageNumberLabel => 'Page number (optional)';

  @override
  String get pageNumberHint => 'Ex: 142';

  @override
  String get save => 'Save';

  @override
  String get sentenceAppBarTitle => 'Sentence';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get emailLabel => 'Email';

  @override
  String get countryLabel => 'Country';

  @override
  String get logout => 'Logout';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountConfirm => 'Are you sure you want to withdraw?\nAll data related to your account will be deleted.';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageKorean => 'Korean';

  @override
  String get languageEnglish => 'English';

  @override
  String get bestseller => 'Bestsellers';

  @override
  String get addFirstBook => '+ Add your first book';

  @override
  String get sentenceTooLong => 'Too long Text';
}
