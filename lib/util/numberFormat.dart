import 'package:intl/intl.dart';

String moneyFormat(String value, String currency, bool currencyText){
  double val = double.parse(value);
  switch(currency){
    case "USD": {
      if(currencyText) {
        return NumberFormat("\$###,###,###,###.0#", "en").format(val);
      }
      return NumberFormat("###,###,###,###.##", "en").format(val);
    }
    case "KRW": {
      if(currencyText) {
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
    case "USD":
      return true;
    default:
      return false;
  }
}