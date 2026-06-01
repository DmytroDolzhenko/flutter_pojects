// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Store';

  @override
  String get productsTab => 'Products';

  @override
  String get settingsTab => 'Settings';

  @override
  String helloUser(String name) {
    return 'Hello, $name!';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String totalPrice(Object price) {
    return 'Total: $price';
  }

  @override
  String addedDate(Object date) {
    return 'Added: $date';
  }

  @override
  String get languageLabel => 'Language';

  @override
  String get selectLanguage => 'Select application language';

  @override
  String get ukrainian => 'Ukrainian';

  @override
  String get english => 'English';

  @override
  String get polish => 'Polish';

  @override
  String get french => 'French';

  @override
  String get german => 'German';

  @override
  String get arabic => 'Arabic';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get productName => 'T-Shirt';

  @override
  String get shoesName => 'Sneakers';

  @override
  String get langChanged => 'Language changed successfully';
}
