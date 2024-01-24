import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';
import 'package:tazawad/AppLocalizations.dart';
import 'package:tazawad/main.dart';
import 'package:tazawad/models/CreateOrderRequestModel.dart';
import 'package:tazawad/models/CustomerResponse.dart';
import 'package:tazawad/models/OrderModel.dart';
import 'package:tazawad/models/membership_model.dart';
import 'package:tazawad/network/rest_apis.dart';
import 'package:tazawad/screen/DashBoardScreen.dart';
import 'package:tazawad/screen/WebViewPaymentScreen.dart';
import 'package:tazawad/utils/AppBarWidget.dart';
import 'package:tazawad/utils/AppWidget.dart';
import 'package:tazawad/utils/Colors.dart';
import 'package:tazawad/utils/Constants.dart';
import 'package:tazawad/utils/SharedPref.dart';
// import 'package:moyasar/moyasar.dart';
import 'package:nb_utils/nb_utils.dart';

class MemberShipSummary extends StatefulWidget {
    static String tag = '/MembershipSummary';

  final MembershipModel?  membershipModel;
  const MemberShipSummary({ Key? key, this.membershipModel }) : super(key: key);

  @override
  _MemberShipSummaryState createState() => _MemberShipSummaryState();
}

class _MemberShipSummaryState extends State<MemberShipSummary> {
  var mOrderModel = OrderResponse();
    bool? isSelected = false;
  num mAmount = 0;
  num remainAmount = 0;
 Shipping? shipping;
  Billing? billing;
  void paymentCount() {
    if (isSelected == true) {

         mAmount = widget.membershipModel!.planPrice.toString().toDouble();
      // if (widget.mPrice.toString().toDouble() < mTotalBalance.toDouble()) {
      //   mAmount = widget.mPrice.toString().toDouble();
      // } else if (widget.mPrice.toString().toDouble() == mTotalBalance.toDouble()) {
      //   mAmount = mTotalBalance.toDouble();
      // } else {
      //   mAmount = double.parse(widget.mPrice) - mTotalBalance.toDouble();
      // }
    } else {
      mAmount = double.parse(widget.membershipModel!.planPrice.toString());
    }
  }

    Future createWebViewOrder() async {
    if (!accessAllowed) {
      return;
    }

    var request = CreateOrderRequestModel();

   
    List<LineItemsRequest> lineItems = [];

    // widget.mCartProduct!.forEach((item) {
      var lineItem = LineItemsRequest();
      lineItem.productId = widget.membershipModel!.membershipId;
      lineItem.quantity = 1.toString();
      
      lineItem.variationId =widget.membershipModel!.membershipId;
      lineItems.add(lineItem);
    // });

    request.paymentMethod = "webview";
    request.transactionId = "";
    request.customerId = getIntAsync(USER_ID);
    // request.status = "completed";
    request.setPaid = false;
    // request.
    request.lineItems = lineItems;
    request.shipping = shipping;
    request.billing = billing;
    createOrder(request);
  }
  NumberFormat nf = NumberFormat('##.00');
  void createOrder(CreateOrderRequestModel mCreateOrderRequestModel) async {
    log('payment order: '+ mCreateOrderRequestModel.toJson().toString());
    
    
    appStore.setLoading(true);
    await createOrderApi(mCreateOrderRequestModel.toJson()).then((response) {
      if (!mounted) return;
      processPaymentApi(response['id']);
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString(), print: true);
    });
  }

  processPaymentApi(var mOrderId) async {
    log(mOrderId);
    var request = {"order_id": mOrderId};
    getCheckOutUrl(request).then((res) async {
      if (!mounted) return;

      appStore.setLoading(false);
      bool isPaymentDone = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebViewPaymentScreen(checkoutUrl: res['checkout_url'])),
          ) ??
          false;
      if (isPaymentDone) {
        appStore.setLoading(true);
        if (!await isGuestUser()) {
          clearCartItems().then((response) {
            if (!mounted) return;

            appStore.setLoading(false);
            appStore.setCount(0);
            DashBoardScreen().launch(context, isNewTask: true);
          }).catchError((error) {
            appStore.setLoading(false);
            toast(error.toString());
          });
        } else {
          appStore.setCount(0);
          removeKey(CART_DATA);
          DashBoardScreen().launch(context, isNewTask: true);
        }
      } else {
        deleteOrder(mOrderId).then((value) => {log(value)});
        appStore.setCount(0);
      }
    }).catchError((error) {});
  }
  // final plugin = PaystackPlugin();


  init() async {
       // plugin.initialize(publicKey: payStackPublicKey);

    shipping = Shipping.fromJson(jsonDecode(getStringAsync(SHIPPING)));
    billing = Billing.fromJson(jsonDecode(getStringAsync(BILLING)));

   
    setState(() {});
    await checkMembership({
    "consumer_secret":"wps_mfw_8ed37c5898c9f5ced8e83d396d5d67b376fc145b",
    "user_id":sharedPreferences.getInt(USER_ID)
}).then((value) {
if (value is! Exception) {
  List<MembershipModel> memberships =[];
//   if(res.contains('data')){
//     memberships.addAll( (value['data'] as Iterable).map((e) =>
//    MembershipModel.fromJson(e)));
//  appStore.userPlans =  memberships;
//   }
   
      if(value.containsKey('data')){
    memberships.addAll( (value['data'] as Iterable).map((e) =>
   MembershipModel.fromJson(e)));
 appStore.userPlans =  memberships;
  }
}

});
  }
//  PaymentConfig? paymentConfig;
// initMuyasarApi(){
//   paymentConfig = PaymentConfig(
//     publishableApiKey: 'pk_test_dhxTm6cx5AsYGn2aahK1uE7qixqUW1FecmybkjmZ',
//     amount:  int.parse(widget.membershipModel!.planPrice.toString())
    
//      , // SAR 257.58
//     description: 'order #1324',
//     metadata: {'size': '250g'},
//     creditCard: CreditCardConfig(saveCard: true, manual: false),
//     applePay: ApplePayConfig(merchantId: 'YOUR_MERCHANT_ID', label: 'YOUR_STORE_NAME', manual: false),
//   );
// }
 

  // void onPaymentResult(result) {
  //   if (result is PaymentResponse) {
  //     switch (result.status) {
  //       case PaymentStatus.paid:
  //         // handle success.
  //         break;
  //       case PaymentStatus.failed:
  //         // handle failure.
  //         break;

  //         default:
  //     }
  //   }
  // }




@override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    // initMuyasarApi();
  }
  @override
  Widget build(BuildContext context) {
        var appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
             appBar: mTop(context, appLocalization.translate('membership_summary'), showBack: true) as PreferredSizeWidget?,
 body: BodyCornerWidget(
        child: Stack(
          children: [
 SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
  16.height,

Divider(thickness: 6, color: Theme.of(context).textTheme.headlineMedium!.color),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appLocalization.translate("lbl_price_detail")!, style: boldTextStyle()),
                      8.height,
                      Divider(),
                      8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(appLocalization.translate("lbl_total_mrp")!, style: secondaryTextStyle(size: 16)),
                          PriceWidget(price: nf.format(num.parse(widget.membershipModel!.planPrice!)), color: Theme.of(context).textTheme.titleMedium!.color, size: 16)
                        ],
                      ),
                      4.height,




                ]
                ), 

        //          ApplePay(
        //     config: paymentConfig!,
        //     onPaymentResult: onPaymentResult,
        // ),
        // const Text("or"),
        // CreditCard(
        //   config: paymentConfig!,
        //   onPaymentResult: onPaymentResult,
        // )
      
                
                ])
                
                ).paddingAll(8)







                

          ]

        ))
, 


   bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          boxShadow: <BoxShadow>[
            BoxShadow(color: Theme.of(context).hoverColor.withOpacity(0.8), blurRadius: 15.0, offset: Offset(0.0, 0.75)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PriceWidget(price: widget.membershipModel!.planPrice, size: 16, color: Theme.of(context).textTheme.titleSmall!.color).expand(),
            16.height,
            AppButton(
              text: appLocalization.translate('lbl_continue'),
              textStyle: primaryTextStyle(color: white),
              color: isHalloween ? mChristmasColor : primaryColor,
              onTap: () async {
                if (appStore.isLoading) {
                  return;
                }
                if (await isGuestUser()) {
                  toast(appLocalization.translate('lbl_guest_payment_msg'));
                } else {
                  
                    createWebViewOrder();
                 
                  }
                
              },
            ).expand(),
          ],
        ).paddingAll(16),
      ),
    );
  }
}