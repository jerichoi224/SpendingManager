import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryEntry {
  int id = 0;
  String caption = "";
  int iconId = -1;
  bool show = true;
  bool basic = false;

  CategoryEntry({
    required this.caption,
    required this.iconId,
    required this.basic
  });
}