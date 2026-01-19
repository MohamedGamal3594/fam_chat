class Validators {
  static String? emptyValidtor(String? data) {
    if (data != null && data.isEmpty) {
      return 'Field is empty';
    }
    return null;
  }
}
