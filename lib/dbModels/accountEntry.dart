import 'package:objectbox/objectbox.dart';

@Entity()
class AccountEntry {
  int id = 0;
  String caption = "";

  AccountEntry({
    required this.caption,
  });
}