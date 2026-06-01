// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Mon Magasin';

  @override
  String get productsTab => 'Produits';

  @override
  String get settingsTab => 'Paramètres';

  @override
  String helloUser(String name) {
    return 'Bonjour, $name!';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
      zero: 'Pas d\'articles',
    );
    return '$_temp0';
  }

  @override
  String totalPrice(Object price) {
    return 'Total: $price';
  }

  @override
  String addedDate(Object date) {
    return 'Ajouté le: $date';
  }

  @override
  String get languageLabel => 'Langue';

  @override
  String get selectLanguage => 'Choisir la langue de l\'application';

  @override
  String get ukrainian => 'Ukrainien';

  @override
  String get english => 'Anglais';

  @override
  String get polish => 'Polonais';

  @override
  String get french => 'Français';

  @override
  String get german => 'Allemand';

  @override
  String get arabic => 'Arabe';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get add => 'Ajouter';

  @override
  String get productName => 'T-shirt';

  @override
  String get shoesName => 'Baskets';

  @override
  String get langChanged => 'Langue changée avec succès';
}
