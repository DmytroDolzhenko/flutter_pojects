import '../l10n/app_localizations.dart';

class LanguageModel {
  final String code;
  final String flag;
  final String Function(AppLocalizations) getLocalizedName;

  const LanguageModel({
    required this.code,
    required this.flag,
    required this.getLocalizedName,
  });

  static List<LanguageModel> languages = [
    LanguageModel(code: 'uk', flag: '🇺🇦', getLocalizedName: (l) => l.ukrainian),
    LanguageModel(code: 'en', flag: '🇬🇧', getLocalizedName: (l) => l.english),
    LanguageModel(code: 'pl', flag: '🇵🇱', getLocalizedName: (l) => l.polish),
    LanguageModel(code: 'fr', flag: '🇫🇷', getLocalizedName: (l) => l.french),
    LanguageModel(code: 'de', flag: '🇩🇪', getLocalizedName: (l) => l.german),
    LanguageModel(code: 'ar', flag: '🇸🇦', getLocalizedName: (l) => l.arabic),
  ];
}