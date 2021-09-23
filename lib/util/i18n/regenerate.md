## Regenerating the i18n files

The files in this directory are based on `../lib/util/MyLocalization.dart`
which defines all of the localizable strings used by the app.
The app uses the [Dart `intl` package](https://github.com/dart-lang/intl).

Rebuilding everything requires two steps.

With the project directory as the current directory, generate `intl_messages.arb` from `lib/util/my_localization.dart`:

```
flutter pub pub run intl_generator:extract_to_arb --output-dir=lib/util/i18n lib/util/my_localization.dart
```

The `intl_messages.arb` file is a JSON format map with one entry for each `Intl.message()` function
defined in `MyLocalization.dart`.

With the project directory as the current directory, generate a `strings_messages_<locale>.dart`
for each `strings_<locale>.arb` file and `strings_messages_all.dart`, which imports all of the messages files:

Remove default `intl_messages.arb` before calling next command

```
flutter pub pub run intl_generator:generate_from_arb --output-dir=lib/util/i18n --generated-file-prefix=strings_ --no-use-deferred-loading lib/util/my_localization.dart lib/util/i18n/intl_messages.arb
```

The `MyLocalizationsDelegate` class uses the generated `initializeMessages()` function
(`strings_messages_all.dart`) to load the localized messages and `Intl.message()` to look them up.
