import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryEntry {
  int id = 0;
  String caption = "";
  int iconId = -1;

  CategoryEntry({
    required this.caption,
    required this.iconId
  });
}