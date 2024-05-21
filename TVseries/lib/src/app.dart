import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'router/router.dart';





class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,

      title: 'TVseries',
      theme: ThemeData.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                locale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
        }
        return supportedLocales.first;
      },

      debugShowCheckedModeBanner: false, // for debug just design material
    );
  }
}
