// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Mein Shop';

  @override
  String get productsTab => 'Produkte';

  @override
  String get settingsTab => 'Einstellungen';

  @override
  String helloUser(String name) {
    return 'Hallo, $name!';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel',
      one: '1 Artikel',
      zero: 'Keine Artikel',
    );
    return '$_temp0';
  }

  @override
  String totalPrice(Object price) {
    return 'Gesamt: $price';
  }

  @override
  String addedDate(Object date) {
    return 'Hinzugefügt: $date';
  }

  @override
  String get languageLabel => 'Sprache';

  @override
  String get selectLanguage => 'Anwendungssprache auswählen';

  @override
  String get ukrainian => 'Ukrainisch';

  @override
  String get english => 'Englisch';

  @override
  String get polish => 'Polnisch';

  @override
  String get french => 'Französisch';

  @override
  String get german => 'Deutsch';

  @override
  String get arabic => 'Arabisch';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get add => 'Hinzufügen';

  @override
  String get productName => 'T-Shirt';

  @override
  String get shoesName => 'Sneaker';

  @override
  String get langChanged => 'Sprache erfolgreich geändert';
}
