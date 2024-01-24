





import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tazawad/AppLocalizations.dart';
import 'package:tazawad/main.dart';
import 'package:tazawad/models/membership_model.dart';
import 'package:tazawad/network/rest_apis.dart';
import 'package:tazawad/screen/DashBoardScreen.dart';
import 'package:tazawad/screen/WebViewPaymentScreen.dart';
import 'package:tazawad/screen/membership/membership_item.dart';
import 'package:tazawad/utils/AppBarWidget.dart';
import 'package:tazawad/utils/AppWidget.dart';
import 'package:tazawad/utils/Constants.dart';
import 'package:tazawad/utils/SharedPref.dart';
import 'package:nb_utils/nb_utils.dart';


class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
 bool isLoading= false;
List<MembershipModel> memberships = [];
    @override
  void initState() {
    super.initState();
    init();
  }

@override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }


  

  init(){
afterBuildCreated(() async {
      appStore.setLoading(true);
      isLoading  = true;
      setState(() { });
     getMembershopPlan(
       {
    "consumer_secret":"wps_mfw_8ed37c5898c9f5ced8e83d396d5d67b376fc145b",
      // "user_id" : USER_ID
}
     ).then((value) {
         appStore.setLoading(false);
memberships=[];
setState((){});
try {
  if (value is! Exception) {


  memberships.addAll( (value['data'] as Iterable).map((e) =>
   MembershipModel.fromJson(e)));
  
//   = 
//   (value['data'] as Iterable).map((e) =>
//    MembershipModel.fromJson(e)).toList();
// setState((){});

} else {
  log('///////   ');
}
} catch (e) {
  log(e.toString());
}


     });
      appStore.setLoading(false);
       isLoading  = false;
      // setState(() { });
      setState(() {});
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

  @override
  Widget build(BuildContext context) {  
      var appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
 backgroundColor: context.scaffoldBackgroundColor,
      appBar: mTop(
        context,
        appLocalization.translate('select_a_plan') , 
         showBack: true
        // 'select a plan'
        ,
        
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search_sharp, color: white),
          //   onPressed: () {
          //     SearchScreen().launch(context);
          //   },
          // )
        ],
      ) as PreferredSizeWidget?,
       key: scaffoldKey,
body: SizedBox.expand(
  child:   RefreshIndicator(
        color: primaryColor,
        backgroundColor: context.cardColor,
        onRefresh: ()async {
         await  init();
        },
    child: Observer(
      builder: (context) => BodyCornerWidget(
      child: Stack(
        children: [
            mProgress().center().visible(isLoading),
          Container(
      
            padding: EdgeInsetsDirectional.symmetric(
              vertical: 20 , horizontal: 15
            ),
      
            child: 
           isLoading?
             Center(
               child: mProgress().center().visible(isLoading)
             )
              
            :
            
            
    
            ListView.builder(
              itemCount: memberships.length,
              itemBuilder: (BuildContext context, int index) {
                return 
                
                MembersipItem(
                  themeColor: planThemeColors[index],
                  membershipModel: memberships[index],
                )
                ;
              },
            ),
           
          ),
        ],
      ),
    )),
  ),
),
    );
  }
}










var planThemeColors = [ 
  Colors.orange ,
  Colors.blue ,
  Colors.purple
];