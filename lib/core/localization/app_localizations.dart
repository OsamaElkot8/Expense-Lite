import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('ar', ''),
  ];

  // Dashboard
  String get goodMorning => _getLocalizedValue('Good Morning', 'صباح الخير');
  String get totalBalance =>
      _getLocalizedValue('Total Balance', 'الرصيد الإجمالي');
  String get income => _getLocalizedValue('Income', 'الدخل');
  String get expenses => _getLocalizedValue('Expenses', 'المصروفات');
  String get recentExpenses =>
      _getLocalizedValue('Recent Expenses', 'المصروفات الأخيرة');
  String get seeAll => _getLocalizedValue('see all', 'عرض الكل');
  String get thisMonth => _getLocalizedValue('This month', 'هذا الشهر');
  String get manually => _getLocalizedValue('Manually', 'يدوياً');
  String get delete => _getLocalizedValue('Delete', 'مسح');
  String get exportAsPdf =>
      _getLocalizedValue('Export as PDF', 'تصدير بصيغة PDF');
  String get exportAsCsv =>
      _getLocalizedValue('Export as CSV', 'تصدير بصيغة CSV');
  String get retry => _getLocalizedValue('Retry', 'أعد المحاولة');
  String get noExpensesFound =>
      _getLocalizedValue('No expenses found', 'لم يتم العثور على نفقات');
  String get loadingMoreExpenses => _getLocalizedValue(
    'Loading more expenses...',
    'جاري تحميل المزيد من النفقات...',
  );
  String get noMoreExpenses =>
      _getLocalizedValue('No more expenses', 'لا مزيد من النفقات');

  // Add Expense
  String get addExpense => _getLocalizedValue('Add Expense', 'إضافة مصروف');
  String get categories => _getLocalizedValue('Categories', 'الفئات');
  String get amount => _getLocalizedValue('Amount', 'المبلغ');
  String get date => _getLocalizedValue('Date', 'التاريخ');
  String get attachReceipt =>
      _getLocalizedValue('Attach Receipt', 'إرفاق إيصال');
  String get uploadImage => _getLocalizedValue('Upload image', 'رفع صورة');
  String get save => _getLocalizedValue('Save', 'حفظ');
  String get selectCategory =>
      _getLocalizedValue('Select Category', 'اختر الفئة');
  String get enterAmount => _getLocalizedValue('Enter Amount', 'أدخل المبلغ');
  String get selectDate => _getLocalizedValue('Select Date', 'اختر التاريخ');
  String get currency => _getLocalizedValue('Currency', 'العملة');
  String get imageSelected =>
      _getLocalizedValue('Image selected', 'تم تحديد الصورة');

  // Categories
  String get groceries => _getLocalizedValue('Groceries', 'البقالة');
  String get entertainment => _getLocalizedValue('Entertainment', 'الترفيه');
  String get gas => _getLocalizedValue('Gas', 'البنزين');
  String get shopping => _getLocalizedValue('Shopping', 'التسوق');
  String get newsPaper => _getLocalizedValue('News Paper', 'الجريدة');
  String get transport => _getLocalizedValue('Transport', 'المواصلات');
  String get rent => _getLocalizedValue('Rent', 'الإيجار');
  String get addCategory => _getLocalizedValue('Add Category', 'إضافة فئة');
  String get addCategoryComingSoon => _getLocalizedValue(
    'Add category feature coming soon',
    'إضافة ميزة الفئة قريبًا',
  );

  // Errors
  String get error => _getLocalizedValue('Error', 'خطأ');
  String get success => _getLocalizedValue('Success', 'نجح');
  String get pleaseFillAllFields =>
      _getLocalizedValue('Please fill all fields', 'يرجى ملء جميع الحقول');
  String get failedToPickImage =>
      _getLocalizedValue('Failed to pick image', 'فشل في اختيار الصورة');

  // Success
  String get expenseAddedSuccessfully => _getLocalizedValue(
    'Expense added successfully',
    'تمت إضافة النفقات بنجاح',
  );

  String _getLocalizedValue(String english, String arabic) {
    switch (locale.languageCode) {
      case 'ar':
        return arabic;
      default:
        return english;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
