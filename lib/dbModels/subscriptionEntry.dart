import 'package:objectbox/objectbox.dart';

@Entity()
class SubscriptionEntry {
  int id = 0;
  int accId = -1;
  double amount = -1;
  int tagId = -1;
  String caption = "";
  bool show = true;
  bool enabled = true;
  int repeatType = 0; // 0 = monthly, 1 = yearly, 2 = weekly
  List<int> renewDay = []; // SUN - SAT = 1 - 7 -> Weekly
  List<int> renewDate = []; // 1 ~ 31 -> Monthly
  int renewMonth = -1; // Month + Date -> Yearly
  int repeatNum = -1;
  int endDate = -1;
  int startDate = -1;
  List<int> added = []; // save YYYY/MM/01 as int to see if already added.

  SubscriptionEntry({
    required this.caption,
  });
}