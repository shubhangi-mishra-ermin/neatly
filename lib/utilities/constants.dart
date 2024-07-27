import 'package:flutter/material.dart';

double? wd;
double? hg;
late Map cities;

const double defaultPadding = 8;
const double defultBoderRadius = 6;

extension SizedBoxPadding on num {
  SizedBox get ph => SizedBox(height: defaultPadding * toDouble());
  SizedBox get pw => SizedBox(width: defaultPadding * toDouble());
  double get m8 => defaultPadding * toDouble();
}
