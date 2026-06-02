// translation_helper.dart
//
// Utility functions for Lao translation across the FitLog application.

/// Translates English workout type strings to Lao display names.
String translateWorkoutType(String type) {
  switch (type) {
    case 'Running':
      return 'ແລ່ນ';
    case 'Weight Training':
      return 'ຍົກນ້ຳໜັກ';
    case 'Swimming':
      return 'ລອຍນ້ຳ';
    case 'Cycling':
      return 'ຖີບລົດ';
    case 'Yoga':
      return 'ໂຍຄະ';
    case 'HIIT':
      return 'ຄາດິໂອ (HIIT)';
    case 'Other':
      return 'ອື່ນໆ';
    default:
      return type;
  }
}
