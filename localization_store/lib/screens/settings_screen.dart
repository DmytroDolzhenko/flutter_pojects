// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization_store/l10n/app_localizations.dart';
import '../models/language_model.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTab),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.language, color: Colors.blue),
            title: Text(l10n.languageLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(l10n.selectLanguage),
          ),
          const Divider(),
          
          // Рендеринг списку доступних мов
          ...LanguageModel.languages.map((language) {
            final isSelected = localeProvider.locale.languageCode == language.code;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.withValues(alpha:0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: RadioListTile<String>(
                value: language.code,
                groupValue: localeProvider.locale.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    localeProvider.setLocale(Locale(value));
                    
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.langChanged),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                title: Row(
                  children: [
                    Text(language.flag, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Text(language.getLocalizedName(l10n)),
                  ],
                ),
                selected: isSelected,
              ),
            );
          }),
        ],
      ),
    );
  }
}