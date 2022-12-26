import 'package:objectbox/objectbox.dart';

@Entity()
class SpendingEntry {
  int id = 0;
  String caption = "";
  int value = 0;
}