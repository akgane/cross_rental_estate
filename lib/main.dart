import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/firebase_options.dart';
import 'package:rental_estate_app/pages/main/widgets/bottom_app_bar.dart';
import 'package:rental_estate_app/pages/main/widgets/categories_section.dart';
import 'package:rental_estate_app/pages/main/widgets/section.dart';
import 'package:rental_estate_app/pages/main/widgets/top_bar.dart';
import 'package:rental_estate_app/providers/auth_provider.dart';
import 'package:rental_estate_app/providers/category_provider.dart';
import 'package:rental_estate_app/providers/estate_provider.dart';
import 'package:rental_estate_app/providers/locale_provider.dart';
import 'package:rental_estate_app/providers/theme_provider.dart';
import 'package:rental_estate_app/providers/session_provider.dart';
import 'package:rental_estate_app/routes/app_routes.dart';
import 'package:rental_estate_app/routes/route_generator.dart';
import 'package:rental_estate_app/utils/estate_utils.dart';
import 'package:rental_estate_app/utils/theme_data.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rental_estate_app/widgets/splash_screen.dart';



Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SessionProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => EstateProvider()),
    ChangeNotifierProvider(create: (_) => CategoryProvider())
  ],
  child: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Rental Estate App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.currentTheme,
      locale: localeProvider.currentLocale,
      home: const AuthWrapper(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: RouteGenerator.generateRoute,
      localizationsDelegates: const
      [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en'),
        Locale('ru'),
        Locale('kk')
      ],
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final session = Provider.of<SessionProvider>(context);

    debugPrint("AuthWrapper building");

    if (auth.isLoading || !session.isInitialized) {
      debugPrint("AuthWrapper: Loading state");
      return Scaffold(
        body: SplashScreen()
      );
    }

    if (session.isLoggedIn && auth.user == null) {
      auth.reloadUser(session.userId!);
      return Scaffold(
        body: SplashScreen()
      );
    }

    if (auth.user != null) {
      debugPrint("AuthWrapper: User authenticated");
      if (!session.isLoggedIn) {
        session.login(auth.user!.uid);
      }
      return const MainPage();
    } else {
      debugPrint("AuthWrapper: Guest mode");
      return const MainPage(guestMode: true);
    }
  }
}

class MainPage extends StatelessWidget{
  final bool guestMode;

  const MainPage({Key? key, this.guestMode = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final estateProvider = Provider.of<EstateProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    debugPrint("MainPage building");

    if(guestMode) authProvider.loginAsGuest();
    else{
      themeProvider.initTheme(authProvider.user!.theme);
      localeProvider.initLocale(Locale(authProvider.user!.language));
    }

    return FutureBuilder<void>(
        future: Future.wait([
          estateProvider.loadEstates(),
          categoryProvider.loadCategories()
        ]),
        builder: (context, snapshot){
          debugPrint("MainPage builder");
          if(snapshot.connectionState == ConnectionState.waiting){
            debugPrint("MainPage builder snapshot.connectionState == ConnectionState.waiting");
            return SplashScreen();
          }else if (snapshot.hasError) {
            debugPrint("MainPage builder snapshot.hasError");
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          debugPrint("MainPage builder ended");

          return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              body: SafeArea(
                  child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        TopBar(
                          username: authProvider.user?.username ?? 'Guest',
                          avatarUrl: authProvider.user?.avatarUrl ?? 'https://randomuser.me/api/portraits/men/1.jpg'
                        ),
                        SizedBox(height: 16),
                        CategoriesSection(estates: estateProvider.estates, categories: categoryProvider.categories,),
                        SizedBox(height: 24),

                        Section(title: loc!.m_section_new, estates: EstateUtils.getRandomEstates(estateProvider.estates, 10)),
                        SizedBox(height: 24,),
                        Section(title: loc.m_section_hot, estates: EstateUtils.getRandomEstates(estateProvider.estates, 10)),
                        SizedBox(height: 24,),
                        Section(title: loc.m_section_popular, estates: EstateUtils.getRandomEstates(estateProvider.estates, 10)),
                      ]
                  )
              ),
            
            bottomNavigationBar: MyBottomAppBar(isGuest: authProvider.isGuest),
            floatingActionButton: FloatingActionButton(
                onPressed: () => debugPrint('opening map page'),
                backgroundColor: theme.primaryColor,
                shape: CircleBorder(),
                child: Icon(Icons.create_outlined)
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          );
        }
    );
  }
}