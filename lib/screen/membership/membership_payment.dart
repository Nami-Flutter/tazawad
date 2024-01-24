
import 'package:flutter/material.dart';
import 'package:tazawad/AppLocalizations.dart';
import 'package:tazawad/models/membership_model.dart';

// import 'package:myfatoorah_flutter/embeddedapplepay/MFApplePayButton.dart'; 

// import 'package:myfatoorah_flutter/utils/MFCountry.dart';
// import 'package:myfatoorah_flutter/utils/MFEnvironment.dart';

class PaymentPageScreen extends StatefulWidget {
  final MembershipModel? membershipModel;

  const PaymentPageScreen({Key? key, this.membershipModel}) : super(key: key);

  @override
  State<PaymentPageScreen> createState() => _PaymentPageScreenState();
}

class _PaymentPageScreenState extends State<PaymentPageScreen> {
  String amount = "";

  String invoiceId = '';
  String cardNumber = "4508750015741019";
  String expiryMonth = "12";
  String expiryYear = "25";
  String securityCode = "300";
  String cardHolderName = "Mahmoud Ibrahim";
  bool visibilityObs = false;
  // MFPaymentCardView? mfPaymentCardView;

  String mAPIKey =
      "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";
  String _response = '';
  String _loading = "Loading...";
  var sessionIdValue = ""; 

  @override
  void initState() {
    super.initState();
    amount = widget.membershipModel!.planPrice.toString();
    if (mAPIKey.isEmpty) {
      setState(() {
        _response =
            "Missing API Token Key.. You can get it from here: https://myfatoorah.readme.io/docs/test-token";
      });
      return;
    }

    // TODO, don't forget to init the MyFatoorah Plugin with the following line
   // MFSDK.init(mAPIKey, MFCountry.KUWAIT, MFEnvironment.TEST);
    // initiateSession();
    // (Optional) un comment the following lines if you want to set up properties of AppBar.

//    MFSDK.setUpAppBar(
//      title: "MyFatoorah Payment",
//      titleColor: Colors.white,  // Color(0xFFFFFFFF)
//      backgroundColor: Colors.lightBlue, // Color(0xFF000000)
//      isShowAppBar: true); // For Android platform only

    // (Optional) un comment this line, if you want to hide the AppBar.
    // Note, if the platform is iOS, this line will not affected
    initiatePayment();
    // initiateSession();
   // MFSDK.setUpActionBar(isShowToolBar: false);
  }
/*
  void initiateSession() {
*//*
     * If you want to use saved card option with embedded payment, send the parameter
     * "customerIdentifier" with a unique value for each customer. This value cannot be used
     * for more than one Customer.


    // var request = MFInitiateSessionRequest("12332212");

*
     * If not, then send null like this.

*//*
    MFSDK.initiateSession(
        null,
        (MFResult<MFInitiateSessionResponse> result) => {
              if (result.isSuccess())
                {
                  // This for embedded payment view
                  mfPaymentCardView!.load(result.response!,
                      onCardBinChanged: (String bin) => {print("Bin: " + bin)}),

                  /// This used for Apple Pay in iOS only.

                  if (Platform.isIOS) loadApplePay(result.response!)
                }
              else
                {
                  setState(() {
                    // print("Response: " + result.error!.toJson().toString());
                    _response = result.error!.message!;
                  })
                }
            });


  }*/
/*

  void payWithEmbeddedPayment() {
    var request = MFExecutePaymentRequest.constructor(0.100);
    mfPaymentCardView!.pay(
        request,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFPaymentStatusResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print("invoiceId: " + invoiceId);
                    print("Response: " + result.response!.toJson().toString());
                    _response = result.response!.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print("invoiceId: " + invoiceId);
                    print("Error: " + result.error!.toJson().toString());
                    _response = result.error!.message!;
                    toast(_response);
                  })
                }
            });
  }
*/

  /// This used for Apple Pay in iOS only.
/*
  void loadApplePay(MFInitiateSessionResponse mfInitiateSessionResponse) {
    var request = MFExecutePaymentRequest.constructorForApplyPay(
        0.100, MFCurrencyISO.KUWAIT_KWD);
    mfApplePayButton.loadWithStartLoading(
        mfInitiateSessionResponse, request, MFAPILanguage.EN, () {
      setState(() {
        _response = "Loading...";
      });
    },
        (String invoiceId, MFResult<MFPaymentStatusResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print("invoiceId: " + invoiceId);
                    print("Response: " + result.response!.toJson().toString());
                    _response = result.response!.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print("invoiceId: " + invoiceId);
                    print("Error: " + result.error!.toJson().toString());
                    _response = result.error!.message!;
                  })
                }
            });
  }
*/

  // Send Payment
/*

  void sendPayment() {
    var request = MFSendPaymentRequest(
        invoiceValue: 0.100,
        customerName: "Customer name",
        notificationOption: MFNotificationOption.LINK);

    MFSDK.sendPayment(
        context,
        MFAPILanguage.EN,
        request,
        (MFResult<MFSendPaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print("Response: " + result.response!.toJson().toString());
                    _response = result.response!.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print("Response: " + result.error!.toJson().toString());
                    _response = result.error!.message!;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }
*/

  // Initiate Payment

  void initiatePayment() {
    

    setState(() {
      _response = _loading;
    });
  }

  // Execute Regular Payment

  void executeRegularPayment(int paymentMethodId) {
    // The value 1 is the paymentMethodId of KNET payment method.
    // You should call the "initiatePayment" API to can get this id and the ids of all other payment methods
    int paymentMethod = 1;

    

    setState(() {
      _response = _loading;
    });
  }

  // Execute Direct Payment
/*

  void executeDirectPayment(int paymentMethodId) {
    // The value 9 is the paymentMethodId of Visa/Master payment method.
    // You should call the "initiatePayment" API to can get this id and the
    // ids of all other payment methods
    int paymentMethod = 9;

    var request = new MFExecutePaymentRequest(paymentMethod, 0.100);

//    var mfCardInfo = new MFCardInfo(cardToken: "Put your API token key here");

    var mfCardInfo = new MFCardInfo(
        cardNumber: "5453010000095489",
        expiryMonth: "05",
        expiryYear: "21",
        securityCode: "100",
        cardHolderName: "Set Name",
        bypass3DS: false,
        saveToken: false);

    MFSDK.executeDirectPayment(
        context,
        request,
        mfCardInfo,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFDirectPaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print("invoiceId: " + invoiceId);
                    print("Response: " + result.response!.toJson().toString());
                    _response = result.response!.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print("invoiceId: " + invoiceId);
                    print("Response: " + result.error!.toJson().toString());
                    _response = result.error!.message!;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }
*/

  // Execute Direct Payment with Recurring
/*

  void executeDirectPaymentWithRecurring() {
    // The value 20 is the paymentMethodId of Visa/Master payment method.
    // You should call the "initiatePayment" API to can get this id and the ids
    // of all other payment methods
    int paymentMethod = 20;

    var request = new MFExecutePaymentRequest(paymentMethod, 100.0);

    var mfCardInfo = new MFCardInfo(
        cardNumber: "5453010000095539",
        expiryMonth: "05",
        expiryYear: "21",
        securityCode: "100",
        cardHolderName: "Set Name",
        bypass3DS: true,
        saveToken: true);

    mfCardInfo.iteration = 12;

    MFSDK.executeRecurringDirectPayment(
        context,
        request,
        mfCardInfo,
        MFRecurringType.monthly,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFDirectPaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print("Response: " + invoiceId);
                    print("Response: " + result.response!.toJson().toString());
                    _response = result.response!.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print("Response: " + invoiceId);
                    print("Response: " + result.error!.toJson().toString());
                    _response = result.error!.message!;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }
*/

  // Payment Enquiry
/*

  void getPaymentStatus() {
    var request = MFPaymentStatusRequest(
        invoiceId: "1849178"); // 647116 for success 1849178 for fail

    MFSDK.getPaymentStatus(
        MFAPILanguage.EN,
        request,
        (MFResult<MFPaymentStatusResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print("Response: " + result.response!.toJson().toString());
                    _response = result.response!.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print("Response: " + result.error!.toJson().toString());
                    _response = result.error!.message!;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }
*/

  // Cancel Token
/*

  void cancelToken() {
    MFSDK.cancelToken(
        "Put your token here",
        MFAPILanguage.EN,
        (MFResult<bool> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print("Response: " + result.response.toString());
                    _response = result.response.toString();
                  })
                }
              else
                {
                  setState(() {
                    print("Response: " + result.error!.toJson().toString());
                    _response = result.error!.message!;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }
*/

  // Cancel Recurring Payment
/*

  void cancelRecurringPayment() {
    MFSDK.cancelRecurringPayment(
        "Put RecurringId here",
        MFAPILanguage.EN,
        (MFResult<bool> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print("Response: " + result.response.toString());
                    _response = result.response.toString();
                  })
                }
              else
                {
                  setState(() {
                    print("Response: " + result.error!.toJson().toString());
                    _response = result.error!.message!;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }
*/

  // List<PaymentMethods> paymentMethods = [];
  List<bool> isSelected = [];

  int selectedPaymentMethodIndex = -1;
/*

  void setPaymentMethodSelected(int index, bool value) {
    for (int i = 0; i < isSelected.length; i++) {
      if (i == index) {
        isSelected[i] = value;
        if (value) {
          selectedPaymentMethodIndex = index;
          log(selectedPaymentMethodIndex.toString());
          visibilityObs = paymentMethods[index].isDirectPayment!;
        } else {
          selectedPaymentMethodIndex = -1;
          visibilityObs = false;
        }
      } else
        isSelected[i] = false;
    }
  }
*/
/*

  void pay() {
    if (selectedPaymentMethodIndex == -1) {
      // Toast.show("Please select payment method first", context,
      //     duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);

      //       Fluttertoast.showToast(
      //     msg: "Please select payment method first",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
    } else {
      if (amount.isEmpty) {
        // Toast.show("Set the amount", context,
        //     duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);

        //     Fluttertoast.showToast(
        //     msg: "Set the amount",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0
        // );
      } else if (paymentMethods[selectedPaymentMethodIndex].isDirectPayment!) {
        if (cardNumber.isEmpty ||
            expiryMonth.isEmpty ||
            expiryYear.isEmpty ||
            securityCode.isEmpty) {
// Toast.show("Fill all the card fields", context,
//               duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);

// Fluttertoast.showToast(
//         msg: "Fill all the card fields",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0
//     );
        }
        // Toast.("Fill all the card fields", context,
        //     duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        else {
          executeDirectPayment(
              paymentMethods[selectedPaymentMethodIndex].paymentMethodId!);
        }
      } else {
        executeRegularPayment(
            paymentMethods[selectedPaymentMethodIndex].paymentMethodId!);
      }
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    enabled: false,
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: amount),
                    decoration: InputDecoration(labelText: "Payment Amount"),
                    onChanged: (value) {
                      amount = value;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Text(appLocalization!
                      .translate('lb_select_payment')!
                      .toString()),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
         /*         SizedBox(
                    height: 200,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 0.0,
                            mainAxisSpacing: 0.0),
                        itemCount: paymentMethods.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Column(
                            children: <Widget>[
                              Image.network(paymentMethods[index].imageUrl!,
                                  width: 40.0, height: 40.0),
                              Checkbox(
                                  value: isSelected[index],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      setPaymentMethodSelected(index, value!);
                                    });
                                  })
                            ],
                          );
                        }),
                  ),*/
                  visibilityObs
                      ? Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(5.0),
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: appLocalization
                                      .translate('lb_card_number')!
                                      .toString()),
                              controller:
                                  TextEditingController(text: cardNumber),
                              onChanged: (value) {
                                cardNumber = value;
                              },
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(labelText: "Expiry Month"),
                              controller:
                                  TextEditingController(text: expiryMonth),
                              onChanged: (value) {
                                expiryMonth = value;
                              },
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(labelText: "Expiry Year"),
                              controller:
                                  TextEditingController(text: expiryYear),
                              onChanged: (value) {
                                expiryYear = value;
                              },
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: appLocalization
                                      .translate('lb_sec_code')!
                                      .toString()),
                              controller:
                                  TextEditingController(text: securityCode),
                              onChanged: (value) {
                                securityCode = value;
                              },
                            ),
                            TextField(
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  labelText: appLocalization
                                      .translate('lb_card_holder_name')!
                                      .toString()),
                              controller:
                                  TextEditingController(text: cardHolderName),
                              onChanged: (value) {
                                cardHolderName = value;
                              },
                            ),
                          ],
                        )
                      : Column(),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  TextButton(
                    // color: Colors.lightBlue,
                    // textColor: Colors.white,
                    onPressed: () {  },
                    child:
                        Text(appLocalization.translate('lb_pay')!.toString()),
                    // onPressed: pay,
                  ),
                  TextButton(
                    // color: Colors.lightBlue,
                    // textColor: Colors.white,
                    onPressed: () {  },
                    child: Text(appLocalization
                        .translate('lb_send_payement')!
                        .toString()),
                    // onPressed: sendPayment,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  // createPaymentCardView(),
                  TextButton(
                    // color: Colors.lightBlue,
                    // textColor: Colors.white,
                    onPressed: () {  },
                    child: Text('Pay (Embedded Payment)'),
                    // onPressed: payWithEmbeddedPayment,
                  ),
                  Text(_response),
                ]),
          ),
        ),
      ),
    );
  }
/*

  createPaymentCardView() {
    mfPaymentCardView = MFPaymentCardView(
        // language: MFAPILanguage.EN,
        // inputColor: Colors.red,
        // labelColor: Colors.yellow,
        // errorColor: Colors.blue,
        // borderColor: Colors.green,
        // fontSize: 14,
        // borderWidth: 1,
        // borderRadius: 10,
        // cardHeight: 220,
        // cardHolderNameHint: "card holder name hint",
        // cardNumberHint: "card number hint",
        // expiryDateHint: "expiry date hint",
        // cvvHint: "cvv hint",
        // showLabels: true,
        // cardHolderNameLabel: "card holder name label",
        // cardNumberLabel: "card number label",
        // expiryDateLabel: "expiry date label",
        // cvvLabel: "cvv label",
        );

    return mfPaymentCardView;
  }
*/

  /// This for Apple pay button
 /* createApplePayView() {
    mfApplePayButton =
        MFApplePayButton(height: 50, radius: 15, buttonText: "Buy with");
    return mfApplePayButton;
  }*/
}
