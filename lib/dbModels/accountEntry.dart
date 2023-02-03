import 'package:objectbox/objectbox.dart';

@Entity()
class AccountEntry {
  int id = 0;
  String caption = "";
  bool show = true;

  AccountEntry({
    required this.caption,
  });
}