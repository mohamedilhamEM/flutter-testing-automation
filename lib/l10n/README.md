# Localization (l10n) Guide

This guide covers how to add new strings and how to implement dynamic multi-language support in the application.

---

## Part 1: Adding New Strings

Follow these 3 simple steps to add a new string.

### 1. Add to ARB File
Open `lib/l10n/arb/app_en.arb` and add your new key-value pair.
**Tip**: Use camelCase for keys.

```json
{
    ...
    "myNewButton": "Click Me",
    "@myNewButton": {
        "description": "Label for the new click me button"
    }
}
```

### 2. Generate Code
- **VS Code**: Just save the file (Cmd+S). The extension handles generation automatically.
- **Terminal**: Run `flutter gen-l10n` manually if needed.

### 3. Use in Code
Use the `context.l10n` extension to access your new string.

```dart
Text(context.l10n.myNewButton),
```

---

## Part 2: Implementing Dynamic Multi-language Support

Follow these steps to enable dynamic language switching (e.g., between English and Spanish) using the project's existing architecture.

### 1. LocaleProvider
Define the `LocaleProvider` in `lib/app/controller/locale_provider.dart`.

```dart
class LocaleProvider with ChangeNotifier {
  LocaleProvider({String languageCode = 'en'}) : _locale = Locale(languageCode);

  Locale _locale;
  Locale get locale => _locale;

  void changeLocale(String languageCode) {
    _locale = Locale(languageCode);
    Hive.box<String>('locale').put('languageCode', languageCode);
    notifyListeners();
  }

  void toggleLocale() {
    if (_locale.languageCode == 'en') {
      changeLocale('es');
    } else {
      changeLocale('en');
    }
  }
}
```

### 2. Register in Service Locator
In `lib/bootstrap.dart`, register the `LocaleProvider` in the `setup` function so it can be accessed globally via `GetIt`.

```dart
// lib/bootstrap.dart
..registerSingletonAsync<LocaleProvider>(() async {
  await Hive.openBox<String>('locale');
  final languageCode = Hive.box<String>('locale').get('languageCode') ?? 'en';
  return LocaleProvider(languageCode: languageCode);
})
```

### 3. Setup Provider in App
In `lib/app/view/app.dart`, add the `ChangeNotifierProvider` to the `MultiProvider` list and bind the `locale` to `MaterialApp`.

```dart
// lib/app/view/app.dart
return MultiProvider(
  providers: [
    ...
    ChangeNotifierProvider(create: (_) => GetIt.instance<LocaleProvider>()),
  ],
  child: Builder(
    builder: (context) {
      return MaterialApp.router(
        ...
        locale: context.watch<LocaleProvider>().locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    },
  ),
);
```

### 4. Create Spanish ARB File
Create `lib/l10n/arb/app_es.arb` for the new locale translations.

```json
{
    "appName": "Mi Aplicación",
    "home": "Inicio"
}
```

### 5. UI Integration
Access the provider in your settings page to toggle or change the language using a Switch.

```dart
ListTile(
  title: Text(context.l10n.language),
  trailing: Switch(
    value: context.watch<LocaleProvider>().locale.languageCode == 'es',
    onChanged: (_) => context.read<LocaleProvider>().toggleLocale(),
  ),
)
```
