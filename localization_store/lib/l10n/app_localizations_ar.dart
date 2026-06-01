// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'متجري';

  @override
  String get productsTab => 'المنتجات';

  @override
  String get settingsTab => 'الإعدادات';

  @override
  String helloUser(String name) {
    return 'مرحباً، $name!';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منتج',
      many: '$count منتجًا',
      few: '$count منتجات',
      two: 'منتجان',
      one: 'منتج واحد',
      zero: 'لا توجد منتجات',
    );
    return '$_temp0';
  }

  @override
  String totalPrice(Object price) {
    return 'الإجمالي: $price';
  }

  @override
  String addedDate(Object date) {
    return 'أضيف في: $date';
  }

  @override
  String get languageLabel => 'اللغة';

  @override
  String get selectLanguage => 'اختر لغة التطبيق';

  @override
  String get ukrainian => 'الأوكرانية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get polish => 'البولندية';

  @override
  String get french => 'الفرنسية';

  @override
  String get german => 'الألمانية';

  @override
  String get arabic => 'العربية';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get productName => 'قميص';

  @override
  String get shoesName => 'حذاء رياضي';

  @override
  String get langChanged => 'تم تغيير اللغة بنجاح';
}
