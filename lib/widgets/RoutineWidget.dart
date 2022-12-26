import 'package:flutter/material.dart';
import 'package:spending_manager/util/dbTool.dart';

class RoutineWidget extends StatefulWidget {
  late Datastore datastore;
  RoutineWidget({Key? key, required this.datastore}) : super(key: key);

  @override
  State createState() => _RoutineState();
}
class _RoutineState extends State<RoutineWidget>{

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