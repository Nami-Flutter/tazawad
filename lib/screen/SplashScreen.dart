import 'package:flutter/material.dart';
import 'package:tazawad/AppLocalizations.dart';
import 'package:nb_utils/nb_utils.dart';

import '/../main.dart';
import '/../screen/DashBoardScreen.dart';
import '/../screen/ProductDetail/ProductDetailScreen1.dart';
import '/../utils/AppImages.dart';
import '/../utils/Colors.dart';
import '/../utils/Common.dart';
import '/../utils/Constants.dart';
import 'WalkThroughScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  // ..repeat(reverse: false);
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.fastOutSlowIn,
    );
    init();
  }

  init() async {
    setStatusBarColor(isHalloween ? mChristmasColor : primaryColor!,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark);
    await Future.delayed(Duration(seconds: 2));

    // String productId = await getProductIdFromNative();
    // print(productId);

    if (false) {
      // ProductDetailScreen1(mProId: productId.toInt()).launch(context);
    } else {
      checkFirstSeen();
    }
  }

  Future checkFirstSeen() async {
    bool _seen = (getBoolAsync('seen'));
    if (_seen) {
      DashBoardScreen().launch(context, isNewTask: true);
    } else {
      await setValue('seen', true);
      WalkThroughScreen().launch(context, isNewTask: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
              scale: _animation!,
              alignment: Alignment.center,
              child: Center(
                  child: AnimatedContainer(
                      duration: const Duration(seconds: 3),
                      padding: const EdgeInsets.all(5),
                      width: width * 0.65,
                      height: 200,
                      child: Image.asset(splash, fit: BoxFit.contain)))),
          Text(appLocalization.translate('app_name')!,
              style: boldTextStyle(
                  color: Theme.of(context).textTheme.subtitle2!.color,
                  size: 26)),
        ],
      ).center(),
      bottomSheet: Container(
        height: 50,
        width: double.infinity,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Made with ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Icon(
                Icons.favorite,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                'in Jeddah  ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(splash,
              width: width * 0.65, height: 200, fit: BoxFit.cover),
          Text(appLocalization.translate('app_name')!,
              style: boldTextStyle(
                  color: Theme.of(context).textTheme.titleSmall!.color,
                  size: 26)),
        ],
      ).center(),
    );
  }
}
