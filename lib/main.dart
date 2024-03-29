import 'dart:async';
import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// import 'package:flutter_stripe/flutter_stripe.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tazawad/firebase_options.dart';
import 'package:tazawad/screen/ChristmasScreens/ChristmasSplashScreen.dart';
import 'package:tazawad/screen/SplashScreen.dart';
import 'package:tazawad/store/AppStore.dart';
import 'package:tazawad/store/CartStore/CartStore.dart';
import 'package:tazawad/store/WishListStore/WishListStore.dart';
import 'package:nb_utils/nb_utils.dart';

import '/../AppTheme.dart';
import '/../models/BuilderResponse.dart';
import '/../models/CartModel.dart';
import '/../models/LanguageModel.dart';
import '/../models/WishListResponse.dart';
import '/../screen/NoInternetScreen.dart';
import '/../utils/Colors.dart';
import '/../utils/Constants.dart';
import 'AppLocalizations.dart';


bool isMember = false;
BuilderResponse builderResponse = BuilderResponse();
Color? primaryColor;
Color? colorAccent;
Color? textPrimaryColour;
Color? textSecondaryColour;
Color? backgroundColor;
String? baseUrl;
// ignore: non_constant_identifier_names
String? ConsumerKey;
// ignore: non_constant_identifier_names
String? ConsumerSecret;
AppStore appStore = AppStore();
WishListStore wishListStore = WishListStore();
CartStore cartStore = CartStore();
Language? language;
List<Language> languages = Language.getLanguages();

Future<String> loadBuilderData() async {
  return await rootBundle.loadString('assets/builder.json');
}

Future<BuilderResponse> loadContent() async {
  String jsonString = await loadBuilderData();
  final jsonResponse = json.decode(jsonString);
  return BuilderResponse.fromJson(jsonResponse);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  /* FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };*/
  await initialize();
  // await FlutterDownloader.initialize(debug: kDebugMode, ignoreSsl: true);
  // Stripe.publishableKey = stripPaymentPublishKey;
  // Stripe.merchantIdentifier = merchantId;
  // await Stripe.instance.applySettings();

  if (isMobile && isAndroid) {
    //await setupRemoteConfig();

    // OneSignal.initialize(mOneSignalAPPKey);
    // OneSignal.
    // OneSignal.consentRequired(true);
    // final status = await OneSignal.
    // await setValue(PLAYER_ID, status?.userId.toString());

    // MobileAds.instance.initialize();
    //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  appStore.setCount(getIntAsync(CARTCOUNT, defaultValue: 0));
  appStore
      .setNotification(getBoolAsync(IS_NOTIFICATION_ON, defaultValue: true));

  await setValue(DASHBOARD_PAGE_VARIANT, 1);
  await setValue(PRODUCT_DETAIL_VARIANT, 1);

  builderResponse = await loadContent();

  if (isHalloween) {
    await setValue(PRIMARY_COLOR, mChristmasBg);
    if (base_URL.isEmpty) {
      await setValue(APP_URL, builderResponse.appsetup!.appUrl);
      await setValue(CONSUMER_KEY, builderResponse.appsetup!.consumerKey);
      await setValue(CONSUMER_SECRET, builderResponse.appsetup!.consumerSecret);
    } else {
      await setValue(APP_URL, base_URL);
      await setValue(CONSUMER_KEY, consumerKey);
      await setValue(CONSUMER_SECRET, consumerSecret);
    }
  } else {
    await setValue(PRIMARY_COLOR, builderResponse.appsetup!.primaryColor);
    await setValue(APP_URL, builderResponse.appsetup!.appUrl);
    await setValue(CONSUMER_KEY, builderResponse.appsetup!.consumerKey);
    await setValue(CONSUMER_SECRET, builderResponse.appsetup!.consumerSecret);
  }

  await setValue(BACKGROUND_COLOR, builderResponse.appsetup!.backgroundColor);
  await setValue(SECONDARY_COLOR, builderResponse.appsetup!.secondaryColor);
  await setValue(
      TEXT_PRIMARY_COLOR, builderResponse.appsetup!.textPrimaryColor);
  await setValue(
      TEXT_SECONDARY_COLOR, builderResponse.appsetup!.textSecondaryColor);

  if (isHalloween) {
    if (getIntAsync(THEME_MODE_INDEX) == ThemeModeDark) {
      primaryColor = Colors.white;
    } else {
      primaryColor = getColorFromHex(getStringAsync(PRIMARY_COLOR),
          defaultColor: appColorPrimary);
    }
  } else {
    primaryColor = getColorFromHex(getStringAsync(PRIMARY_COLOR),
        defaultColor: appColorPrimary);
  }

  colorAccent = getColorFromHex(getStringAsync(SECONDARY_COLOR),
      defaultColor: appColorAccent);
  textPrimaryColour = getColorFromHex(getStringAsync(TEXT_PRIMARY_COLOR),
      defaultColor: textColorPrimary);
  textSecondaryColour = getColorFromHex(getStringAsync(TEXT_SECONDARY_COLOR),
      defaultColor: textColorSecondary);
  backgroundColor = getColorFromHex(getStringAsync(BACKGROUND_COLOR),
      defaultColor: itemBackgroundColor);

  String cartString = getStringAsync(CART_ITEM_LIST);
  if (cartString.isNotEmpty) {
    cartStore.addAllCartItem(jsonDecode(cartString)
        .map<CartModel>((e) => CartModel.fromJson(e))
        .toList());
  }

  String wishListString = getStringAsync(WISHLIST_ITEM_LIST);
  if (wishListString.isNotEmpty) {
    wishListStore.addAllWishListItem(jsonDecode(wishListString)
        .map<WishListResponse>((e) => WishListResponse.fromJson(e))
        .toList());
  }

  baseUrl = getStringAsync(APP_URL);
  ConsumerKey = getStringAsync(CONSUMER_KEY);
  ConsumerSecret = getStringAsync(CONSUMER_SECRET);

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(aIsDarkMode: false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(aIsDarkMode: true);
  }

  appStore.setLanguage(getStringAsync(LANGUAGE, defaultValue: defaultLanguage));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() async {
      await 1.seconds.delay;
      if (!await isNetworkAvailable()) {
        log('not connected');
        push(NoInternetScreen());
      }

      _connectivitySubscription =
          Connectivity().onConnectivityChanged.listen((e) {
        if (e == ConnectivityResult.none) {
          log('not connected');
          push(NoInternetScreen());
        } else {
          pop();
          log('connected');
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          navigatorKey: navigatorKey,
          themeMode: appStore.isDarkMode! ? ThemeMode.dark : ThemeMode.light,
          supportedLocales: [
            const Locale('ar', ''),
            const Locale('en', 'US'),
          ],
          localizationsDelegates: [
            CountryLocalizations.delegate,
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) => Locale("ar"),
          locale: Locale(appStore.selectedLanguageCode),
          home:
              // MembershipPage(),

              // OtpScreen(phoneNumber: '+966536627478',) ,

              isHalloween ? ChristmasSplashScreen() : SplashScreen(),
          builder: scrollBehaviour(),
        );
      },
    );
  }
}
