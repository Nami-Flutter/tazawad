 import 'package:flutter/material.dart';


class MyAppBar extends 

SliverPersistentHeaderDelegate 

{
  final double? height;
final Widget?
 containerChild;
  const MyAppBar(this.containerChild, {this.height});
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
      Color red800 = Colors.red[800]!;

    return SizedBox(
      height:  MediaQuery.of(context).size.height * 0.30,
      child: Stack(
        children: <Widget>[


          Container(  
            padding: EdgeInsets.only(
              top: 20
            ),   // Background
         alignment: Alignment.topCenter,
            child:           Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text( 
                
                  'TAZAWAD' , style: TextStyle(
                    color: Colors.white , 
                    fontSize: 25,
                    // height: 30 
                    
                    // ,
                    
                    fontWeight: FontWeight.bold
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
Container(
  height:  40 ,
  width: 150,
  decoration: BoxDecoration(
      color: Colors.white,
            borderRadius: BorderRadius.circular(
             10
    
            )
  ),
  child: TextField(),
) ,
SizedBox(width: 8,),

Container(
  height:  40 ,
  width: 40,
decoration: BoxDecoration(
      color: Colors.white,
       borderRadius: BorderRadius.circular(
             10
    
            )
)
)
                  ],
                )
              ],
            ),
         
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
    
            decoration: BoxDecoration(
                 color: red800,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20) , 
                bottomRight:  Radius.circular(20)
    
              )
            ),
          ),
    
          Container(),   // Required some widget in between to float AppBar
    
          Positioned(    // To take AppBar Size only
           
           
           
            top: 
            
            MediaQuery.of(context).size.height * 0.10
            // 100.0
            
            
            ,
    
    
            left: 20.0,
            right: 20.0,
    
    
    
            child: 
            Container(
              height:
          MediaQuery.of(context).size.height * 0.18,
            

              decoration: BoxDecoration(
  color: Colors.white,
                borderRadius: BorderRadius.circular(20) ,

                boxShadow: [
                BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 5,
                      color: Color.fromRGBO(0, 0, 0, 0.16),
                )
               ]
              ),

              child: containerChild,
            )
            
            // AppBar(
            //   backgroundColor: Colors.white,
            //   leading: Icon(Icons.menu, color: red800,),
            //   primary: false,
            //   title: TextField(
            //       decoration: InputDecoration(
            //           hintText: "Search",
            //           border: InputBorder.none,
            //           hintStyle: TextStyle(color: Colors.grey))),
            //   actions: <Widget>[
            //     IconButton(
            //       icon: Icon(Icons.search, color: red800), onPressed: () {},),
            //     IconButton(icon: Icon(Icons.notifications, color: red800),
            //       onPressed: () {},)
            //   ],
            // ),
         
         
         
         
          )
    
        ],
      ),
    );
 
 
  }
  
  @override
  // TODO: implement maxExtent
  double get maxExtent => height!;
  
  @override
  // TODO: implement minExtent
  double get minExtent => height!;
  
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
   return false;
  }




}










Widget myAppBar(BuildContext context ,
Widget?
 containerChild

) {
    Color red800 = Colors.red[800]!;

    return SizedBox(
      height:  MediaQuery.of(context).size.height * 0.30,
      child: Stack(
        children: <Widget>[


          Container(  
            padding: EdgeInsets.only(
              top: 20
            ),   // Background
         alignment: Alignment.topCenter,
            child:           Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text( 
                
                  'TAZAWAD' , style: TextStyle(
                    color: Colors.white , 
                    fontSize: 25,
                    // height: 30 
                    
                    // ,
                    
                    fontWeight: FontWeight.bold
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
Container(
  height:  40 ,
  width: 150,
  decoration: BoxDecoration(
      color: Colors.white,
            borderRadius: BorderRadius.circular(
             10
    
            )
  ),
  child: TextField(),
) ,
SizedBox(width: 8,),

Container(
  height:  40 ,
  width: 40,
decoration: BoxDecoration(
      color: Colors.white,
       borderRadius: BorderRadius.circular(
             10
    
            )
)
)
                  ],
                )
              ],
            ),
         
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
    
            decoration: BoxDecoration(
                 color: red800,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20) , 
                bottomRight:  Radius.circular(20)
    
              )
            ),
          ),
    
          Container(),   // Required some widget in between to float AppBar
    
          Positioned(    // To take AppBar Size only
           
           
           
            top: 
            
            MediaQuery.of(context).size.height * 0.10
            // 100.0
            
            
            ,
    
    
            left: 20.0,
            right: 20.0,
    
    
    
            child: 
            Container(
              height:
          MediaQuery.of(context).size.height * 0.18,
            

              decoration: BoxDecoration(
  color: Colors.white,
                borderRadius: BorderRadius.circular(20) ,

                boxShadow: [
                BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 5,
                      color: Color.fromRGBO(0, 0, 0, 0.16),
                )
               ]
              ),

              child: containerChild,
            )
            
            // AppBar(
            //   backgroundColor: Colors.white,
            //   leading: Icon(Icons.menu, color: red800,),
            //   primary: false,
            //   title: TextField(
            //       decoration: InputDecoration(
            //           hintText: "Search",
            //           border: InputBorder.none,
            //           hintStyle: TextStyle(color: Colors.grey))),
            //   actions: <Widget>[
            //     IconButton(
            //       icon: Icon(Icons.search, color: red800), onPressed: () {},),
            //     IconButton(icon: Icon(Icons.notifications, color: red800),
            //       onPressed: () {},)
            //   ],
            // ),
         
         
         
         
          )
    
        ],
      ),
    );
 
 
 
  }



class CustomAppBar extends SliverPersistentHeaderDelegate {
  final double? height;

  const CustomAppBar({this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
        color: Colors.transparent,
        child: Stack(fit: StackFit.loose, children: <Widget>[
            Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: height,
                child: CustomPaint(
                  painter: CustomToolbarShape(lineColor: Colors.deepOrange),
                )
        )])
                
                );
  }

  @override
  double get maxExtent => height!;

  @override
  double get minExtent => height!;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class CustomToolbarShape extends CustomPainter {
  final Color? lineColor;

  const CustomToolbarShape({this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
Paint paint = Paint();

//First oval
Path path = Path();
Rect pathGradientRect = new Rect.fromCircle(
  center: new Offset(size.width / 4, 0),
  radius: size.width/1.4,
);

Gradient gradient = new LinearGradient(
  colors: <Color>[
    Color.fromRGBO(225, 89, 89, 1).withOpacity(1),
    Color.fromRGBO(255, 128, 16, 1).withOpacity(1),
  ],
  stops: [
    0.3,
    1.0,
  ],
);

path.lineTo(-size.width / 1.4, 0);
path.quadraticBezierTo(
    size.width / 2, size.height * 2, size.width + size.width / 1.4, 0);

paint.color = Colors.deepOrange;
paint.shader = gradient.createShader(pathGradientRect);
paint.strokeWidth = 40;
path.close();

canvas.drawPath(path, paint);

//Second oval
Rect secondOvalRect = new Rect.fromPoints(
  Offset(-size.width / 2.5, -size.height),
  Offset(size.width * 1.4, size.height / 1.5),
);

gradient = new LinearGradient(
  colors: <Color>[
    Color.fromRGBO(225, 255, 255, 1).withOpacity(0.1),
    Color.fromRGBO(255, 206, 31, 1).withOpacity(0.2),
  ],
  stops: [
    0.0,
    1.0,
  ],
);
Paint secondOvalPaint = Paint()
  ..color = Colors.deepOrange
  ..shader = gradient.createShader(secondOvalRect);

canvas.drawOval(secondOvalRect, secondOvalPaint);

//Third oval
Rect thirdOvalRect = new Rect.fromPoints(
  Offset(-size.width / 2.5, -size.height),
  Offset(size.width * 1.4, size.height / 2.7),
);

gradient = new LinearGradient(
  colors: <Color>[
    Color.fromRGBO(225, 255, 255, 1).withOpacity(0.05),
    Color.fromRGBO(255, 196, 21, 1).withOpacity(0.2),
  ],
  stops: [
    0.0,
    1.0,
  ],
);
Paint thirdOvalPaint = Paint()
  ..color = Colors.deepOrange
  ..shader = gradient.createShader(thirdOvalRect);

canvas.drawOval(thirdOvalRect, thirdOvalPaint);

//Fourth oval
Rect fourthOvalRect = new Rect.fromPoints(
  Offset(-size.width / 2.4, -size.width/1.875),
  Offset(size.width / 1.34, size.height / 1.14),
);

gradient = new LinearGradient(
  colors: <Color>[
    Colors.red.withOpacity(0.9),
    Color.fromRGBO(255, 128, 16, 1).withOpacity(0.3),
  ],
  stops: [
    0.3,
    1.0,
  ],
);
Paint fourthOvalPaint = Paint()
  ..color = Colors.deepOrange
  ..shader = gradient.createShader(fourthOvalRect);

  canvas.drawOval(fourthOvalRect, fourthOvalPaint);  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}