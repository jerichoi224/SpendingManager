import 'package:objectbox/objectbox.dart';

@Entity()
class SpendingEntry {
  int id = 0;
  int dateTime = -1;
  double value = 0;
  int accId = -1;
  int recAccId = -1;
  int tagId = -1;
  String caption = "";
  int itemType = -1;
}