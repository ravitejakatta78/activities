
import 'package:flutter/cupertino.dart';

import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';

class NoData extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Column(
     mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.center,
     children: [
       Image(image: AssetImage('assets/images/library.png'),),
       SizedBox(height: 10,),
       Text("Click filter to get more information",style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)
     ],
   );
  }

}