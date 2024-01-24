import 'package:flutter/material.dart';
import 'package:tazawad/AppLocalizations.dart';
import 'package:tazawad/models/membership_model.dart';

class MembersipItem extends StatelessWidget {
  final Color? themeColor;
  final Function()? onTap;
  final MembershipModel? membershipModel;

  const MembersipItem(
      {Key? key, this.themeColor, this.membershipModel, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Stack(
        children: [
          ClipPath(
            child: Container(
              height: MediaQuery.of(context).size.height * .20,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: themeColor!.withOpacity(.15),
                  borderRadius: BorderRadius.circular(25)),
            ),
            clipper: Clipper(),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .25,
            decoration: BoxDecoration(
                color: themeColor!.withOpacity(.25),
                borderRadius: BorderRadius.circular(25)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${membershipModel!.membershipName}',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        membershipModel!.details!.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${membershipModel!.planPrice} ${appLocalization!.locale.languageCode == "ar" ? "ر.س" : "SAR"}',
                      style: TextStyle(
                          color: themeColor, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      ' ${appLocalization.translate("duration")}  ${membershipModel!.planDuration}',
                      style: TextStyle(
                          color: themeColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                  /*  PaymentPageScreen(
                      membershipModel: membershipModel,
                    ).launch(context);*/
                  },
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: Text(
                        "${appLocalization.translate("buy_txt")}",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          PositionedDirectional(
            end: 20,
            top: 0,
            child: ClipPath(
              child: Container(
                alignment: Alignment.center,
                height: 100,
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: .5, color: themeColor!),
                    boxShadow: [
                      BoxShadow(
                        color: themeColor!.withOpacity(0.5), //color of shadow
                        spreadRadius: 20, //spread radius
                        blurRadius: 7, // blur radius
                        offset: Offset(.5, .5), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      ),
                    ]),
                child: Column(
                  children: [
                    Center(
                        child: Image.asset(
                      'images/mightystore/ic_logo.png',
                      height: 60,
                      width: 80,
                    )),
                    Text(
                      '${membershipModel!.planPrice} ${appLocalization.locale.languageCode == "ar" ? "ر.س" : "SAR"}',
                      style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              clipper: DiscountClipper(),
            ),
          ),
        ],
      ),
    );

    Container(
      height: MediaQuery.of(context).size.height * .30,
      decoration: BoxDecoration(
          color: themeColor!.withOpacity(.10),
          borderRadius: BorderRadius.circular(25)),
      child: CustomPaint(
        foregroundPainter: PlanPainter(themeColor: themeColor),
      ),
    );
  }
}

class PlanPainter extends CustomPainter {
  final Color? themeColor;

  PlanPainter({this.themeColor});

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;
    var wave1Painter = Paint()
      ..color = themeColor!.withOpacity(.20)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    var wave2Painter = Paint()
      ..color = themeColor!.withOpacity(.30)
      ..style = PaintingStyle.fill;

    var wave1Path = Path()
      ..moveTo(0, height * .80)
      ..quadraticBezierTo(
          size.width / 4, size.height * .90, width / 2, height * .80)
      ..quadraticBezierTo(
          size.width / 4, size.height * .90, width / 2, height * .80)
      ..close();

    var wave2Path = Path()
      ..moveTo(width * .10, height)
      ..quadraticBezierTo(size.width / 2, size.height, width * .90, height)
      ..close();

    canvas.drawPath(wave1Path, wave1Painter);

// canvas.drawPath(wave2Path, wave2Painter);
  }

  @override
  bool shouldRepaint(PlanPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(PlanPainter oldDelegate) => false;
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 50, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(Clipper oldClipper) => true;
}

class DiscountClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * .80);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height * .80);
    path.lineTo(size.width, 0);
    path.close();
    // path.quadraticBezierTo(
    //     size.width / 4, size.height-50, size.width / 2,
    //      size.height - 20);
    // path.quadraticBezierTo(
    //     3 / 4 * size.width, size.height, size.width,
    //      size.height - 30);
    // path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(DiscountClipper oldClipper) => true;
}
