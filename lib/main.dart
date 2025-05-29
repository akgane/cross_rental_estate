import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/firebase_options.dart';
import 'package:rental_estate_app/pages/main/widgets/bottom_app_bar.dart';
import 'package:rental_estate_app/pages/main/widgets/categories_section.dart';
import 'package:rental_estate_app/pages/main/widgets/section.dart';
import 'package:rental_estate_app/pages/main/widgets/top_bar.dart';
import 'package:rental_estate_app/pages/pin_code_screen.dart';
import 'package:rental_estate_app/providers/auth_provider.dart';
import 'package:rental_estate_app/providers/category_provider.dart';
import 'package:rental_estate_app/providers/estate_provider.dart';
import 'package:rental_estate_app/providers/locale_provider.dart';
import 'package:rental_estate_app/providers/pin_provider.dart';
import 'package:rental_estate_app/providers/theme_provider.dart';
import 'package:rental_estate_app/providers/session_provider.dart';
import 'package:rental_estate_app/providers/font_size_provider.dart';
import 'package:rental_estate_app/routes/app_routes.dart';
import 'package:rental_estate_app/routes/route_generator.dart';
import 'package:rental_estate_app/services/connectivity_service.dart';
import 'package:rental_estate_app/services/offline_storage_service.dart';
import 'package:rental_estate_app/utils/estate_utils.dart';
import 'package:rental_estate_app/utils/theme_data.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rental_estate_app/widgets/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  final connectivityService = ConnectivityService();
  final offlineStorage = OfflineStorageService(sharedPreferences);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SessionProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => EstateProvider(connectivityService, offlineStorage)),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ChangeNotifierProvider(create: (_) => PinProvider(sharedPreferences)),
    ChangeNotifierProvider(create: (_) => FontSizeProvider()),
  ],
  child: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final pinProvider = Provider.of<PinProvider>(context);
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return MaterialApp(
      title: 'Rental Estate App',
      theme: lightTheme.copyWith(
        textTheme: scaledTextTheme(lightTheme.textTheme, fontSizeProvider.fontSize),
      ),
      darkTheme: darkTheme.copyWith(
        textTheme: scaledTextTheme(darkTheme.textTheme, fontSizeProvider.fontSize),
      ),
      themeMode: themeProvider.currentTheme,
      locale: localeProvider.currentLocale,
      home: pinProvider.isPinEntered ? const AuthWrapper() : const PinCodeScreen(),
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

  TextStyle safeApply(TextStyle? style, double factor) {
    if (style == null) return TextStyle(); // Return a default style if the original is null
    return style.copyWith(
      fontSize: (style.fontSize ?? 14.0) * factor, // Provide a default fontSize if it's null
    );
  }

  TextTheme scaledTextTheme(TextTheme baseTheme, double factor) {
    return TextTheme(
      displayLarge: safeApply(baseTheme.displayLarge, factor),
      displayMedium: safeApply(baseTheme.displayMedium, factor),
      displaySmall: safeApply(baseTheme.displaySmall, factor),
      headlineLarge: safeApply(baseTheme.headlineLarge, factor),
      headlineMedium: safeApply(baseTheme.headlineMedium, factor),
      headlineSmall: safeApply(baseTheme.headlineSmall, factor),
      titleLarge: safeApply(baseTheme.titleLarge, factor),
      titleMedium: safeApply(baseTheme.titleMedium, factor),
      titleSmall: safeApply(baseTheme.titleSmall, factor),
      bodyLarge: safeApply(baseTheme.bodyLarge, factor),
      bodyMedium: safeApply(baseTheme.bodyMedium, factor),
      bodySmall: safeApply(baseTheme.bodySmall, factor),
      labelLarge: safeApply(baseTheme.labelLarge, factor),
      labelMedium: safeApply(baseTheme.labelMedium, factor),
      labelSmall: safeApply(baseTheme.labelSmall, factor),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAndReloadUser();
  }

  void _checkAndReloadUser() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final session = Provider.of<SessionProvider>(context, listen: false);

    // if (session.isLoggedIn && auth.user == null) {
    //   Future.microtask(() => auth.reloadUser(session.userId!));
    // }

    if(session.isLoggedIn && auth.isGuest){
      Future.microtask(() => auth.reloadUser(session.userId!));
    }
  }

  void _initUserSettings(BuildContext context, AppUser user) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    themeProvider.initTheme(user.theme);
    localeProvider.initLocale(Locale(user.language));
  }

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

    if (auth.user != null) {
      debugPrint("AuthWrapper: User authenticated");
      if (!session.isLoggedIn) {
        session.login(auth.user!.uid);
      }
      if (!auth.isGuest) {
        _initUserSettings(context, auth.user!);
      }
      return const MainPage();
    } else {
      debugPrint("AuthWrapper: Guest mode");
      return const MainPage(guestMode: true);
    }
  }
}

class MainPage extends StatefulWidget{
  final bool guestMode;

  const MainPage({Key? key, this.guestMode = false}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  @override
  void initState() {
    super.initState();
    if (widget.guestMode) {
      Provider.of<AuthProvider>(context, listen: false).loginAsGuest();
    }
  }

  @override
  Widget build(BuildContext context) {
    final estateProvider = Provider.of<EstateProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context);

    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    debugPrint("MainPage building");

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
                onPressed: () => Navigator.pushNamed(context, AppRoutes.addEstate, arguments: {'estate-provider': estateProvider}),
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