import 'package:flutter/material.dart';

double scale_width(value, context){
  double width_of_device = MediaQuery.of(context).size.width.floorToDouble();
  double safe_area_horizontal = MediaQuery.of(context).padding.left.floorToDouble() + MediaQuery.of(context).padding.right.floorToDouble();
  double actual_width_based_on_screensize = (value/100) * (width_of_device - safe_area_horizontal);
  return actual_width_based_on_screensize;
}

double scale_height(value, context){
  double height_of_device = MediaQuery.of(context).size.height;
  double safe_area_vertical =  MediaQuery.of(context).padding.top.floorToDouble() + MediaQuery.of(context).padding.bottom.floorToDouble() + AppBar().preferredSize.height.floorToDouble();
  double actual_height_based_on_screensize = (value/100) * (height_of_device - safe_area_vertical);
  return actual_height_based_on_screensize;
}