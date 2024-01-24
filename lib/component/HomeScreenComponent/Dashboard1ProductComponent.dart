import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tazawad/AppLocalizations.dart';
import 'package:tazawad/main.dart';
import 'package:tazawad/network/rest_apis.dart';
import 'package:tazawad/utils/Countdown.dart';
import 'package:nb_utils/nb_utils.dart';

import '/../models/ProductResponse.dart' as p;
import '/../models/ProductResponse.dart';
import '/../utils/AppWidget.dart';
import '/../utils/Common.dart';
import '/../utils/ProductWishListExtension.dart';

class Dashboard1ProductComponent extends StatefulWidget {
  static String tag = '/Product';
  final double? width;
  final ProductResponse? mProductModel;

  Dashboard1ProductComponent({Key? key, this.width, this.mProductModel}) : super(key: key);

  @override
  Dashboard1ProductComponentState createState() => Dashboard1ProductComponentState();
}

class Dashboard1ProductComponentState extends State<Dashboard1ProductComponent> {
  bool mIsInWishList = false;

  @override
  void initState() {
    super.initState();
    // init();
  }
  
init() async {
    // afterBuildCreated(() {
      // adShow();
      // productDetail();
      productMetaData();
      // fetchReviewData();
      // setTimer();
    // });
  }
  
  // setTimer() {
  //   Timer.periodic(Duration(seconds: 10), (Timer timer) {
  //     if (_currentPage < 2) {
  //       _currentPage++;
  //     } else {
  //       _currentPage = 0;
  //     }
  //     if (_pageController.hasClients) {
  //       _pageController.animateToPage(
  //         _currentPage,
  //         duration: Duration(milliseconds: 350),
  //         curve: Curves.easeIn,
  //       );
  //     }
  //   });
  // }
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
 Widget countDownWidget(ProductResponse? productDetailNew, String? value) {
    // return Text(productDetailNew!.metaData!.length.toString());

    if (getMetaDataExpireDate(productDetailNew!.metaData!)['visible'] == true) {
      var endTime =
          getMetaDataExpireDate(productDetailNew.metaData!)['expireDate']
                  .toString() +
              "23:59:59.000";
      var endDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(endTime);
      var currentDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(DateTime.now().toString());

      if (endDate.isBefore(currentDate)) {
        return Text('End ');
      } else {
        var format = endDate.subtract(Duration(
            days: currentDate.day,
            hours: currentDate.hour,
            minutes: currentDate.minute,
            seconds: currentDate.second));
        log(format);

        return Countdown(
          duration: Duration(
              days: format.day,
              hours: format.hour,
              minutes: format.minute,
              seconds: format.second),
          onFinish: () {
            log('finished!');
          },
          builder: (BuildContext ctx, Duration? remaining) {
            var seconds = ((remaining!.inMilliseconds / 1000) % 60).toInt();
            var minutes =
                (((remaining.inMilliseconds / (1000 * 60)) % 60)).toInt();
            var hours =
                (((remaining.inMilliseconds / (1000 * 60 * 60)) % 24)).toInt();
            log(hours);
            return Container(
              decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(4),
                  backgroundColor: colorAccent!.withOpacity(0.3)),
              child: Text(
                value! +
                    " " +
                    '${remaining.inDays}d ${hours}h ${minutes}m ${seconds}s',
                style: primaryTextStyle(),
              ).paddingAll(8),
            ).paddingOnly(left: 16, right: 16, top: 16, bottom: 16);
          },
        );
      }
    } else {
      return SizedBox();
    }
  }
 List<p.MetaData> metaData = [];

  Future productMetaData() async {
    appStore.setLoading(true);
    await getProductMetaData(widget.mProductModel!.id).then((res) {
      if (!mounted) return;
      setState(() {
        Iterable mInfo = res;
     var   mPlainProducts = mInfo.map((model) {
          return ProductResponse.fromJson(model);
        }).toList();

        // logger.e('DATA   DATA DATA      ');

        if (mPlainProducts.isNotEmpty) {
          try {
            var mProductData = mPlainProducts
                .firstWhere((element) => element.id == widget.mProductModel!.id);

            metaData = mProductData.metaData!;
            log('Meta Data'+ metaData.length.toString());
          } catch (e) {
            // logger.e('ERROR' + e.toString());
          }

          metaData.forEach((element) {
            // logger.e('DATA   DATA DATA    ${element.key}   ');
          });
        }

        appStore.setLoading(false);
      });
    }).catchError((error) {
      log('error:$error');
      // debugPrint('error:$error');
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var productWidth = MediaQuery.of(context).size.width;

    String? img = widget.mProductModel!.images!.isNotEmpty ? widget.mProductModel!.images!.first.src : '';



   var appLocalization = AppLocalizations.of(context)!;

return GestureDetector(
  onTap: (){
     setState(() {
          onClickProduct(context, widget.mProductModel!);
        });
  },
  child: 
    Container(
     width: widget.width ,
     height:  240,
      // width: MediaQuery.of(context).size.width/2,
      // height: MediaQuery.of(context).size.height*.25,
      margin: const EdgeInsets.all(5),
      //  padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
// border: Border.all(
//   width: 1 ,
//   color: Color(0xFFDFDFDF)
// ) ,
//   borderRadius: BorderRadius.circular(
//         0
//       )
      ),
      child: Stack(
        children: [

          Container(
  // height: MediaQuery.of(context).size.height*.80,
  // padding: const EdgeInsets.all(8),
  child: Column(
    
    children: [
      ClipRRect(
        borderRadius:  BorderRadius.circular(
10
          // topLeft: Radius.circular(0),
          // topRight: Radius.circular(0),
        ),
        child: 
        
        widget.mProductModel!.images!.isNotEmpty ?
        Image.network(
          widget.mProductModel!.images!.first.src! ,
         fit: BoxFit.cover,
        
  height:      MediaQuery.of(context).size.height*.25 /1.5, 
        width: double.infinity,
        ):
        Image.asset(
        
          
         'assets/image/png/placeholder.png',
        fit: BoxFit.cover,
        width: double.infinity,
  height: 160 ,
//  width: MediaQuery.of(context).size.width*.40,
        ),
      ) ,
      const Spacer() ,

      Padding(
  padding: const EdgeInsets.all(5.0),
  child:   Column(
    crossAxisAlignment: CrossAxisAlignment.start ,
children: 
[
Text(widget.mProductModel!.name, style: primaryTextStyle(), maxLines: 1),
            Text(parseHtmlString(widget.mProductModel!.shortDescription!.isNotEmpty ? widget.mProductModel!.shortDescription : ''), style: secondaryTextStyle(size: 12), maxLines: 1)
                .visible(widget.mProductModel!.shortDescription!.isNotEmpty)
                .paddingTop(2),
            2.height,
            
            Row(
              children: [
                PriceWidget(
                  price:
                  0.0,
                  //  widget.mProductModel!.onSale == true
                  //     ? widget.mProductModel!.salePrice.validate().isNotEmpty
                  //         ? double.parse(widget.mProductModel!.salePrice.toString()).toStringAsFixed(2)
                  //         : double.parse(widget.mProductModel!.price.validate()).toStringAsFixed(2)
                  //     : widget.mProductModel!.regularPrice!.isNotEmpty
                  //         ? double.parse(widget.mProductModel!.regularPrice.validate().toString()).toStringAsFixed(2)
                  //         : double.parse(widget.mProductModel!.price.validate().toString()).toStringAsFixed(2),
                 
                 
                 
                  size: 14,
                  color: Colors.red[900],
                ),
                4.width,
                PriceWidget(
                  price:
                  0.0.toString(),
                  //  widget.mProductModel!.regularPrice.validate().toString(), 
                   
                   size: 12, isLineThroughEnabled: true, color: Theme.of(context).textTheme.titleMedium!.color)
                    .visible(widget.mProductModel!.salePrice.validate().isNotEmpty && widget.mProductModel!.onSale == true),


              ],
            ).visible(!widget.mProductModel!.type!.contains("grouped")&&!widget.mProductModel!.type!.contains("variable")).paddingOnly(bottom: 8),


// ProductCountDownWidget(

//   product: widget.mProductModel!.id,
// )  
    
    ]
 
 
 
  )) , 
 

        ],
      )
   ) , 


Positioned(
  top: 5,
  right: 5,
child: 

                  ProductWishListExtension(mProductModel: widget.mProductModel)
  
)
 , 
 Positioned(
  top: 5,
  left: 5,
child: 

               Container(
                //  height: 40,
                 padding: EdgeInsets.all(5),
decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
  color: Colors.red
),
child: Center(

  child: Text( 
'%${getDicountPercentage(
          // 1000,900
          isNumericUsingRegularExpression(widget.mProductModel!.regularPrice.toString())
&&
          isNumericUsingRegularExpression(widget.mProductModel!.salePrice.toString())
?
          double.parse(widget.mProductModel!.regularPrice!):0,
          //widget.mProductModel!.salePrice!
                 isNumericUsingRegularExpression(widget.mProductModel!.regularPrice.toString())
&&
          isNumericUsingRegularExpression(widget.mProductModel!.salePrice.toString())
?
          double.parse(widget.mProductModel!.salePrice!):0,

          // : 0 ,0
        )}' ,

        style: TextStyle(
          color: Colors.white ,
          fontSize: 15
        ),

  ),
),

               )
  
)








        ]
        )
        )
        );
return GestureDetector(
      onTap: () async {
        setState(() {
          onClickProduct(context, widget.mProductModel!);
        });
      },
      child: Banner(
        location: BannerLocation.topStart,
        message: '%${getDicountPercentage(
          // 0.1,
          double.parse(widget.mProductModel!.regularPrice!),
          //widget.mProductModel!.salePrice!
          double.parse(45.55.toString()),
        )}',
        child: Container(
          width: widget.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(8.0),
                    backgroundColor: Theme.of(context).colorScheme.background),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    commonCacheImageWidget(img.validate(),
                            height: 170, width: productWidth, fit: BoxFit.cover)
                        .cornerRadiusWithClipRRect(8),
                    mSale(widget.mProductModel!),
                    ProductWishListExtension(
                        mProductModel: widget.mProductModel)
                  ],
                ),
              ),
              2.height,
              Text(widget.mProductModel!.name,
                  style: primaryTextStyle(size: 14), maxLines: 1),

              Text(
                      parseHtmlString(
                          widget.mProductModel!.shortDescription!.isNotEmpty
                              ? widget.mProductModel!.shortDescription
                              : ''),
                      overflow: TextOverflow.fade,
                      style: secondaryTextStyle(size: 12),
                      maxLines: 1)
                  .visible(widget.mProductModel!.shortDescription!.isNotEmpty)
                  .paddingTop(2),
              2.height,
              Row(
                children: [
                  PriceWidget(
                    price: widget.mProductModel!.onSale == true
                        ? widget.mProductModel!.salePrice.validate().isNotEmpty
                            ? double.parse(
                                    widget.mProductModel!.salePrice.toString())
                                .toStringAsFixed(2)
                            : double.parse(
                                    widget.mProductModel!.price.validate())
                                .toStringAsFixed(2)
                        : widget.mProductModel!.regularPrice!.isNotEmpty
                            ? double.parse(widget.mProductModel!.regularPrice
                                    .validate()
                                    .toString())
                                .toStringAsFixed(2)
                            : double.parse(widget.mProductModel!.price
                                    .validate()
                                    .toString())
                                .toStringAsFixed(2),
                    size: 14,
                    color: Colors.green,
                  ),
                  4.width,
                  PriceWidget(
                          price: widget.mProductModel!.regularPrice
                              .validate()
                              .toString(),
                          size: 12,
                          isLineThroughEnabled: true,
                          color: Theme.of(context).textTheme.titleMedium!.color)
                      .visible(widget.mProductModel!.salePrice
                              .validate()
                              .isNotEmpty &&
                          widget.mProductModel!.onSale == true),
                ],
              )
                  .visible(!widget.mProductModel!.type!.contains("grouped") &&
                      !widget.mProductModel!.type!.contains("variable"))
                  .paddingOnly(bottom: 8),

  // Text('End After') ,

countDownWidget(
  widget.mProductModel! ,

  appLocalization.translate('lbl_special_msg'))
            ],
          ),
        ),
      ),
    );
  






    return 
    
  GestureDetector(
    onTap: (){} 


    , child: Container(),
  );
    
    
    GestureDetector(
      onTap: () async {
        setState(() {
          onClickProduct(context, widget.mProductModel!);
        });
      },
      child: Container(
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8.0), backgroundColor: Theme.of(context).colorScheme.background),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  commonCacheImageWidget(img.validate(), height: 170, width: productWidth, fit: BoxFit.cover).cornerRadiusWithClipRRect(8),
                  mSale(widget.mProductModel!),
                  ProductWishListExtension(mProductModel: widget.mProductModel)
                ],
              ),
            ),
            2.height,
            Text(widget.mProductModel!.name, style: primaryTextStyle(), maxLines: 1),
            Text(parseHtmlString(widget.mProductModel!.shortDescription!.isNotEmpty ? widget.mProductModel!.shortDescription : ''), style: secondaryTextStyle(size: 12), maxLines: 1)
                .visible(widget.mProductModel!.shortDescription!.isNotEmpty)
                .paddingTop(2),
            2.height,

            Row(
              children: [
                PriceWidget(
                  price: widget.mProductModel!.onSale == true
                      ? widget.mProductModel!.salePrice.validate().isNotEmpty
                          ? double.parse(widget.mProductModel!.salePrice.toString()).toStringAsFixed(2)
                          : double.parse(widget.mProductModel!.price.validate()).toStringAsFixed(2)
                      : widget.mProductModel!.regularPrice!.isNotEmpty
                          ? double.parse(widget.mProductModel!.regularPrice.validate().toString()).toStringAsFixed(2)
                          : double.parse(widget.mProductModel!.price.validate().toString()).toStringAsFixed(2),
                  size: 14,
                ),
                4.width,
                PriceWidget(price: widget.mProductModel!.regularPrice.validate().toString(), size: 12, isLineThroughEnabled: true, color: Theme.of(context).textTheme.titleMedium!.color)
                    .visible(widget.mProductModel!.salePrice.validate().isNotEmpty && widget.mProductModel!.onSale == true),
              ],
            ).visible(!widget.mProductModel!.type!.contains("grouped")&&!widget.mProductModel!.type!.contains("variable")).paddingOnly(bottom: 8),
          
          
          
          ],
        ),
      ),
    );
  }
}
