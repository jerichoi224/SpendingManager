import 'package:objectbox/objectbox.dart';

@Entity()
class AccountEntry {
  int id = 0;
  String caption = "";
  bool show = true;
  bool enabled = true;
  List<int> renewDay = []; // SUN - SAT = 1 - 7 -> Weekly
  int renewDate = -1; // 1 ~ 31 -> Monthly
  int renewMonth = -1; // Month + Date -> Yearly
  int repeatNum = -1;
  int endDate = -1;
  int startDate = -1;

  AccountEntry({
    required this.caption,
  });
}