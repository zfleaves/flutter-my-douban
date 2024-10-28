import 'package:flutter/material.dart';

///渐变圆角矩形
BoxDecoration gradientBackground(Color colorA, Color colorB) {
  return BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      gradient: LinearGradient(colors: [
        colorA,
        colorB,
      ]));
}

Text getText(String text,
    {double textSize = 12.0,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    int maxLine = 1,
    TextAlign textAlign = TextAlign.start}) {
  return Text(
    text,
    maxLines: maxLine,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: textSize,
      color: color,
      fontWeight: fontWeight,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

///圆角边框文字
Container getBoxText(String text) {
  return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(color: Colors.grey, width: 1.0),
          color: Colors.white),
      child: getText(text, color: Colors.grey));
}

 ///分界线
Widget splitLine = const SizedBox(
  height: 1.0,
  width: double.infinity,
  child: DecoratedBox(
    decoration: BoxDecoration(color: Colors.grey),
  ),
);

Center buildMovieImage(String imgUrl,double height){
  double width = height * 0.7;
  return Center(
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      child: Image.network(
        imgUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        frameBuilder:(context,child, frame,wasSynchronouslyLoaded){
          if(wasSynchronouslyLoaded){
            return child;
          }else{
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: frame != null ? child : getPlaceholder(height, width),
            );
          }
        },
        errorBuilder: (context,error, stackTrace,){
          return getPlaceholder(height, width);
        },
      ),
    ),
  );
}

///占位图
Widget getPlaceholder(double height,double width){
   return Container(
     width: width,
     height: height,
     decoration: const BoxDecoration(
         shape: BoxShape.rectangle,
         borderRadius: BorderRadius.all(Radius.circular(10.0)),
         //color: Colors.grey
       image: DecorationImage(image: AssetImage('assets/images/placeholder.png'),fit: BoxFit.fill),
     ),
   );
}