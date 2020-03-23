class DoteParam {
  final String title;
  final String price;
  final String desc;
  final double latitude;
  final double longitude;

  DoteParam(this.title, this.price, this.desc, this.latitude, this.longitude);

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

class Global {
  static List<DoteParam> doteSummary = []; // offload this to hardware memory in future
  static String path;
  static String getPath(int pidx, bool add) {
    if (add) {
      return path+Global.doteSummary.length.toString()+
          "_"+pidx.toString()+".png";
    }
    return path+pidx.toString()+"_0.png";
  }
}