import 'package:flutter/material.dart';

class BoulderUtils {
  static Color getDifficultyColor(String grade) {
    if (grade.startsWith('V1') ||
        grade.startsWith('V2') ||
        grade.startsWith('V3')) {
      return Colors.green;
    } else if (grade.startsWith('V4') || grade.startsWith('V5')) {
      return Colors.blue;
    } else if (grade.startsWith('V6') || grade.startsWith('V7')) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
