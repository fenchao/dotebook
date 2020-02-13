import 'dart:math';

class DoteParam {
  final String title;
  final String price;
  final String desc;

  DoteParam(this.title, this.price, this.desc);

  bool isValid() {
    bool isNumeric = true;
    try {
      isNumeric = double.parse(price) > 0;
    } catch (e) {
      isNumeric = false;
    }
    return title.isNotEmpty && price.isNotEmpty && isNumeric;
  }
}