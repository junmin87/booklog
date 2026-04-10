// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Book Log';

  @override
  String get loginSubtitle => '나의 독서 여정을 기록해보세요';

  @override
  String get selectRegion => '지역을 선택해주세요';

  @override
  String get countryKorea => '한국';

  @override
  String get countryOther => '기타';

  @override
  String get navBooks => '책';

  @override
  String get navSettings => '설정';

  @override
  String get myBooks => '내 책';

  @override
  String get noBooksYet => '아직 등록된 책이 없어요';

  @override
  String get recordFirstSentence => '첫 문장을 기록해보세요';

  @override
  String get noCover => '표지 없음';

  @override
  String get savedSentences => '저장된 문장';

  @override
  String get noSentencesHint => '이 책에서 기억하고 싶은 문장을 남겨보세요';

  @override
  String sentencesWithRepresentative(int count) {
    return '$count개의 문장 중 하나가 대표문장으로 선택되어 있어요';
  }

  @override
  String sentencesChooseRepresentative(int count) {
    return '$count개의 문장이 있어요 · 대표문장을 골라보세요';
  }

  @override
  String get setRepresentativeTitle => '대표문장으로 설정할까요?';

  @override
  String get setRepresentativeContent => '이 문장이 이 책을 대표하는 한 문장으로 표시돼요.';

  @override
  String get cancel => '취소';

  @override
  String get setConfirm => '설정';

  @override
  String get representativeSetSuccess => '대표문장으로 설정했어요';

  @override
  String get representativeSetFailed => '대표문장 설정에 실패했어요';

  @override
  String get noSentencesChip => '기록된 문장 없음';

  @override
  String sentenceCountChip(int count) {
    return '문장 $count개';
  }

  @override
  String get representativeLine => '대표 문장';

  @override
  String get noRepresentativeYet => '아직 대표문장이 없어요';

  @override
  String get recentSentenceTitle => '최근 남긴 문장';

  @override
  String get noSentencesYet => '아직 남겨둔 문장이 없어요';

  @override
  String get noSentencesSubtitle => '이 책에서 기억하고 싶은 문장을 남겨보세요.';

  @override
  String get saveFirstSentence => '첫 문장 남기기';

  @override
  String get representativeChip => '대표 문장';

  @override
  String get setAsRepresentative => '대표로 설정';

  @override
  String get searchForBook => '제목이나 저자로 책을 검색하세요';

  @override
  String get searchFieldHint => '제목 또는 저자...';

  @override
  String bookAdded(String title) {
    return '\"$title\" 추가됨';
  }

  @override
  String get failedToAddBook => '책 추가에 실패했어요';

  @override
  String get sentenceRequired => '문장을 입력해주세요';

  @override
  String get pageNumberOnly => '페이지는 숫자로 입력해주세요';

  @override
  String get saveSentenceTitle => '문장 남기기';

  @override
  String get sentenceLabel => '문장';

  @override
  String get sentenceHint => '기억하고 싶은 문장을 입력하세요';

  @override
  String get pageNumberLabel => '페이지 번호 (선택)';

  @override
  String get pageNumberHint => '예: 142';

  @override
  String get save => '저장하기';

  @override
  String get sentenceAppBarTitle => '문장';

  @override
  String get settings => '설정';

  @override
  String get account => '계정';

  @override
  String get emailLabel => '이메일';

  @override
  String get countryLabel => '국가';

  @override
  String get logout => '로그아웃';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get deleteAccountConfirm => '정말로 탈퇴하시겠습니까?\n계정과 관련된 모든 데이터가 삭제됩니다.';

  @override
  String get withdraw => '탈퇴하기';

  @override
  String get languageLabel => '언어';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageEnglish => 'English';

  @override
  String get bestseller => '베스트셀러';

  @override
  String get addFirstBook => '+ 첫 번째 책 추가하기';
}
