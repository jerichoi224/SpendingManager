import 'package:intl/intl.dart';

moneyFormat(String value, String locale, bool currency){
  double val = double.parse(value);
  switch(locale){
    case "en_US": {
      if(currency) {
        return NumberFormat("\$###,###,###,###.0#", "en_US").format(val);
      }
      return NumberFormat("###,###,###,###.##", "en_US").format(val);
    }
    case "ko_KR": {
      if(currency) {
        return NumberFormat('###,###,###,###,###원').format(val);
      }
      return NumberFormat('###,###,###,###,###').format(val);
    }
    default:{
      return value;
    }
  }
}

bool usesDecimal(String locale){
  switch(locale) {
    case "en_US":
      return true;
    default:
      return false;
  }
}