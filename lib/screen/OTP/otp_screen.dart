import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tazawad/AppLocalizations.dart';
import 'package:tazawad/screen/OTP/verifity_button.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
enum ErrorAnimationType {
  FAILED ,TIMEOUT , shake
}
class SampleStrategy extends OTPStrategy {
  @override
  Future<String> listenForCode() {
    return Future.delayed(
      const Duration(seconds: 4),
      () => 'Your code is 54321',
    );
  }
}

class OtpScreen extends StatefulWidget {
  final String? phoneNumber;
  OtpScreen({Key? key, this.phoneNumber}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
   TextEditingController textEditingController = TextEditingController();
OtpFieldController otpFieldController = OtpFieldController();
  StreamController<ErrorAnimationType>? errorController;
  final formKey = GlobalKey<FormState>();
late OTPTextEditController controller;
final scaffoldKey = GlobalKey();
  late OTPInteractor _otpInteractor;
  String currentText = "";
  bool hasError = false;
  late Timer _timer;
  int _start = 60;
  bool isLoading = false;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isLoading = false;
            hasError=false ;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();

    startTimer();



 _initInteractor();
   _otpInteractor.getAppSignature()
      .then((value) => print('signature - $value'));
  controller = OTPTextEditController(
    codeLength: 5,
    onCodeReceive: (code) => print('Your Application receive code - $code'),
  )..startListenUserConsent(
      (code) {
        
        final exp = RegExp(r'(\d{5})');
        otpFieldController.set((exp.stringMatch(code ?? '') ?? '').split(""));

        return exp.stringMatch(code ?? '') ?? '';
      },
      strategies: [
        SampleStrategy(),
      ],
    );
  }
Future<void> _initInteractor() async {
    _otpInteractor = OTPInteractor();

    // You can receive your app signature by using this method.
    final appSignature = await _otpInteractor.getAppSignature();

    if (kDebugMode) {
      print('Your app signature: $appSignature');
    }
  }
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    errorController!.close();
  }


   /// verify otp by send it to the server
   /// if match go to the next route
   /// else show an [Exception]
    verify(){

    }


/// resend code after expire
/// [phoneNumber]
    resend(){

    }
  @override
  Widget build(BuildContext context) {
           var appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            children: [
              Column(children: [
                     SizedBox(height: 20,),
                Image.asset(
                  'images/mightystore/pin.png' ,
                  width: 80,
                  height: 80,
                ),
                     SizedBox(height: 20,),
              // Image.network("Add Image Link"),
              Text(
                "${appLocalization.translate('enter_verification_code')}",
                style: TextStyle(
                  fontSize: 20 , fontWeight: FontWeight.w500
                ),
              ),
              Text(
                "${appLocalization.translate('code_sent_to')} ${widget.phoneNumber}",
                style: TextStyle(
                  fontSize: 15 , fontWeight: FontWeight.w500
                ),
              ),
                          SizedBox(height: 20,),

              Form(
                   key: formKey,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: OTPTextField(controller:otpFieldController ,
                hasError: hasError,
                      length: 4,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 50,
                      style: TextStyle(fontSize: 17),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      onCompleted: (pin) {
                        print("Completed: " + pin);
                      },
                       fieldStyle: FieldStyle.box,
                      otpFieldStyle: OtpFieldStyle(
                        borderColor: Colors.black,
                      )),
                ),
              ),
                SizedBox(height: 15,),


                _start != 0
                      ? Row(
                          children: [
                            Text(
                              "${appLocalization.translate('you_can_request_in')}",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "00:${_start.toString()}",
                              style: TextStyle(
                                  color:Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${appLocalization.translate('dont_receive_code')}",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _start = 5;
                                  isLoading = true;
                                  startTimer();
                                });
                              },
                              child: Text(
                                "${appLocalization.translate('request_again')}",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            )
                          ],
                        ),
                
              ]),
            
            Spacer() ,
              const SizedBox(height: 10),
               isLoading
                      ? const CircularProgressIndicator()
                      : VerifyButton(
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          maxWidth: MediaQuery.of(context).size.width * 0.9,
                          minHeight: 60,
                          onPressed: () {
                            formKey.currentState!.validate();

                            if (currentText.length != 6) {
                              errorController!.add(ErrorAnimationType
                                  .shake); // Triggering error shake animation
                              setState(() => hasError = true);
                            } else {
                              setState(
                                () {},
                              );
                            }
                          },
                          color: Colors.blue,
                          title: "${appLocalization.translate('verify')}") ,
                      const SizedBox(height: 10),

            ],
          ),
        ),
      ),
    )
;
  }
}