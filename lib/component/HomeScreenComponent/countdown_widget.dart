import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tazawad/AppLocalizations.dart';
import 'package:tazawad/models/ProductResponse2.dart';
import 'package:tazawad/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import '/../models/ProductResponse2.dart' as p2;
import '../../network/rest_apis.dart';

class ProductCountDownWidget extends StatefulWidget {
  final int?  product;
  const ProductCountDownWidget({super.key, this.product});

  @override
  State<ProductCountDownWidget> createState() => _ProductCountDownWidgetState();
}

class _ProductCountDownWidgetState extends State<ProductCountDownWidget> {


DateTime startTime = DateTime(2020,03,04);
  Duration remaining = DateTime.now().difference(DateTime.now());
  Timer? t;
  int days=0,hrs =0, mins=0;

  @override
  void initState(){
    super.initState();
    // startTimer();

    init();
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
List<p2.MetaData> metaData = [];
String date='';
bool isSHown = false;
bool isLoading = false;
ExpireModel? expireModel;

  Future productMetaData() async {
    // appStore.setLoading(true);
    isLoading= true;
    setState(() {
      
    });
    await getProductMetaData(widget.product!).then((res) {
      if (!mounted) return;
      // setState(() {
        Iterable mInfo = res;
     var   mPlainProducts = mInfo.map((model) {
          return ProductResponse2.fromJson(model);
        }).toList();

log('LOG AFTER'+ mPlainProducts.length.toString());


        

        if (mPlainProducts.isNotEmpty) {
          log('No Empty');
          try {
            mPlainProducts.forEach((v) {
              

              log("${v.id}   "+ widget.product!.toString() );
            });
            var mProductData = mPlainProducts
                .firstWhere((element) => 
                element.id == widget.product!);

            metaData = mProductData.metaData!;
            setState(() {
              
            });
            log('Meta Data'+ metaData.length.toString());
          } catch (e) {
            log('METAERROR' + e.toString());
          }

          metaData.forEach((element) {
           if ( element.key=="expiring_date") {
             log("KEY VALUE"+  element.value!);
             date= element.value!;
             if (date.isNotEmpty|| date!="") {
// String date = '20180626170555';
// String dateWithT = date.substring(0, 8) + 'T' + date.substring(8);
DateTime dateTime = DateTime.parse(date);

                   expireModel=     getExpireTime(DateTime.now(), 
                  //  DateTime.parse(date)
                   dateTime
                   
                   );
setState(() {
  if (expireModel!.days!>0 || expireModel!.hours!>0) {
        isSHown= true;
  }
 
});
             }else  {

               setState(() {
                  isSHown= false;
                   isLoading= false;
               });
             }
    
         

           }
            // logger.e('DATA   DATA DATA    ${element.key}   ');
          });
        }else{
          log("No Meta");
        }

        isLoading= false;
    setState(() {
      
    });
      // });
    }).catchError((error) {
      log('error:$error');
      // debugPrint('error:$error');
       isLoading= false;
    setState(() {
      
    });
      log(error.toString());
    });
  }

  startTimer()async{
    t = Timer.periodic(Duration(seconds:1),(timer){
      setState((){
      remaining = DateTime.now().difference(startTime);
        mins = remaining.inMinutes;
        hrs = mins>=60 ? mins~/60:0;
        days = hrs>=24 ? hrs~/24: 0;
        hrs = hrs%24;
        mins = mins%60;
      });

    });
  }

  @override
  Widget build(BuildContext context) {

    var appLocalization = AppLocalizations.of(context)!;


return
     Container(
      // height: 35,
      margin: EdgeInsets.all(5),
      // width: 250,
      decoration: BoxDecoration(
         color: Colors.red[900],
         borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.all(3),

      child: Center( 
        child: 
        
        // expireModel!.days!>0?

        Row(
          
          children: [
            Text("${appLocalization.translate("end_at")}  " ,
            
            
            style: TextStyle(
              color: Colors.white , 
              fontSize: 15
            ),
            ),
            Builder(
              builder: (context) {
                if (expireModel != null) {
                  
          return           expireModel!.days!>0?

        Row( 
          mainAxisSize: MainAxisSize.min,
          children: [
            Text( 
              // '${ expireModel!.days} Days'
              '${ expireModel!.days} ${appLocalization.translate("d")}'
              , style: TextStyle(
          color: Colors.white,
     fontSize: 15
   ),
            ), 
            SizedBox(width: 5,),
             Text( 
              // '${expireModel!.hours} hrs'  
              '${expireModel!.hours} ${appLocalization.translate("h")}'
              
              , style: TextStyle(
          color: Colors.white,
     fontSize: 15
   ),
            )
          ],
        )
        
        
        :
        
         Text( 
              // '${expireModel!.hours} hrs'
               '6 ${appLocalization.translate("h")}' 
                , style: TextStyle(
          color: Colors.white,
     fontSize: 15
   )
        ,
      );
   
   
                
                
             
                }else {
                  return SizedBox.shrink();
                }
              }
            ),
          ],
        )
      )).visible(expireModel!= null);
    return
  isLoading?
    Center(child: SizedBox.shrink(),):
    
    
     Container(
      // height: 35,
      width: 120,
      decoration: BoxDecoration(
         color: Colors.red[900],
         borderRadius: BorderRadius.circular(50)
      ),
      padding: EdgeInsets.all(3),

      child: Center( 
        child: 
        
        expireModel!.days!>0?

        Row( 
          mainAxisSize: MainAxisSize.min,
          children: [
            Text( 
              // '${ expireModel!.days} Days'
              '1 Days'
              , style: TextStyle(
          color: Colors.white,
     fontSize: 10
   ),
            ), 
            SizedBox(width: 5,),
             Text( 
              // '${expireModel!.hours} hrs'  
              '3 Hrs'
              
              , style: TextStyle(
          color: Colors.white,
     fontSize: 10
   ),
            )
          ],
        )
        
        
        :
        
         Text( 
              // '${expireModel!.hours} hrs'
               '6 Hrs' 
                , style: TextStyle(
          color: Colors.white,
     fontSize: 10
   )
        ,
      ),
   
   
   
    ).visible(isSHown));
    return    
  SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisSize: MainAxisSize.min
      ,
      children: [
        Text('Valid Until:' , style: TextStyle(
          color: Colors.red[900],
     fontSize: 10
   ),) ,
   SizedBox(width: 5,),  
   Text('10/10/2023 05:67 pm' , style: TextStyle(
     fontSize: 10 ,    color: Colors.red[900],
   ),) , 
      ],
    ),
  );
     Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
     Padding(
       padding: const EdgeInsets.all(5.0),
       child: Text('Ends in: ',
           style: TextStyle(color: Colors.black, fontSize: 15),
           // textAlign: TextAlign.center
           ),
     ),
    
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [

Row(mainAxisSize: MainAxisSize.min,
  children: [  
     Text('$days',
         style: TextStyle(color: Colors.black, fontSize: 15),
              ),
       Text('Days',
           style: TextStyle(color: Colors.black, fontSize: 16)
                  ),
  ],
)
    
    
    
    
      ],
    ) ,

    
          ],
        );
  }
}