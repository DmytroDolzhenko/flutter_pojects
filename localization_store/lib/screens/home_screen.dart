import 'package:flutter/material.dart';
import 'package:localization_store/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Product> _products = [
    Product(keyName: 'productName', basePriceUSD: 6.25, dateAdded: DateTime(2026, 2, 13)),
    Product(keyName: 'shoesName', basePriceUSD: 37.5, dateAdded: DateTime(2026, 2, 12)),
  ];

  String _getFormattedPrice(BuildContext context, double priceInUSD) {
    final locale = Localizations.localeOf(context);
    String currencySymbol;
    double conversionRate;

    switch (locale.languageCode) {
      case 'uk':
        currencySymbol = '₴';
        conversionRate = 40.0;
        break;
      case 'pl':
        currencySymbol = 'zł';
        conversionRate = 4.0;
        break;
      case 'fr':
      case 'de':
        currencySymbol = '€';
        conversionRate = 0.92;
        break;
      case 'ar':
        currencySymbol = 'د.إ';
        conversionRate = 3.67;
        break;
      case 'en':
      default:
        currencySymbol = '\$';
        conversionRate = 1.0;
    }

    final calculatedPrice = priceInUSD * conversionRate;
    final formatter = NumberFormat.currency(
      locale: locale.toString(),
      symbol: currencySymbol,
      decimalDigits: 2,
    );
    
    return formatter.format(calculatedPrice);
  }

  String _getLocalizedProductName(AppLocalizations l10n, String keyName) {
    if (keyName == 'productName') return l10n.productName;
    if (keyName == 'shoesName') return l10n.shoesName;
    return keyName;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeStr = Localizations.localeOf(context).toString();
    
    final dateFormatter = DateFormat.yMd(localeStr);

    double totalUSD = _products.fold(0, (sum, item) => sum + item.basePriceUSD);

    final List<Widget> pages = [
      Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.shopping_bag)),
                      title: Text(
                        _getLocalizedProductName(l10n, product.keyName),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_getFormattedPrice(context, product.basePriceUSD)),
                          Text(
                            l10n.addedDate(dateFormatter.format(product.dateAdded)),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.itemsCount(_products.length), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.totalPrice(_getFormattedPrice(context, totalUSD)),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? l10n.appTitle : l10n.settingsTab),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.store),
            label: l10n.productsTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settingsTab,
          ),
        ],
      ),
    );
  }
}