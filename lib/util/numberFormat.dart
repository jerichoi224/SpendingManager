import 'package:intl/intl.dart';

moneyFormat(String value, String locale, bool currency){
  double val = double.parse(value);
  switch(locale){
    case "en": {
      if(currency) {
        return NumberFormat("\$###,###,###,###.0#", "en").format(val);
      }
      return NumberFormat("###,###,###,###.##", "en").format(val);
    }
    case "kr": {
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
    case "en":
      return true;
    default:
      return false;
  }
}