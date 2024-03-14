import 'package:flutter/material.dart';
import 'package:tv_series/src/components/header_bar.dart';
import 'package:tv_series/src/components/navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Scaffold(
        appBar: CustomHeaderBar(),
        drawer: NavBar(),
      ),
      title: 'TVseries',
      theme: ThemeData.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        /// [locale]: Cihazın dili null değilse
        if (locale != null) {
          print(
              "Algılanan cihaz dili: Dil Kodu: ${locale.languageCode}, Ülke Kodu: ${locale.countryCode}");

          /// for döngüsü yardımıyla [supportedLocales] listesi içinde arama yapıyoruz
          for (var supportedLocale in supportedLocales) {
            /// Cihazın dil kodu [locale.languageCode] ve ülke kodu [locale.countryCode]
            /// desteklenen diller arasındaki dil ve ülke kodlarının içinde [supportedLocale] var mı?
            if (supportedLocale.languageCode == locale.languageCode &&
                locale.countryCode == locale.countryCode) {
              /// Varsa desteklenen dili döndür
              return supportedLocale;
            }
          }
        }
        print("Algılanan cihaz dili desteklenen diller arasında bulunmuyor.");

        /// Yoksa [supportedLocales] Listesindeki ilk sonucu döndür.
        print(
            "Uygulamanın başlatılması istenen dil: Dil Kodu: ${supportedLocales.first.languageCode}, Ülke Kodu: ${supportedLocales.first.countryCode}");
        return supportedLocales.first;
      },

      debugShowCheckedModeBanner: false, // for debug just design material
      initialRoute: '/login',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
