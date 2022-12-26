import 'package:flutter/material.dart';
import 'package:spending_manager/util/dbTool.dart';

class CalendarWidget extends StatefulWidget {
  late Datastore datastore;
  CalendarWidget({Key? key, required this.datastore}) : super(key: key);

  @override
  State createState() => _CalendarState();
}
class _CalendarState extends State<CalendarWidget>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      color: Colors.red,
                    )
                  ]
                ),
              ),
            ],
          ),
        )
    );
  }
}