import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spending_manager/util/dbTool.dart';

class WorkoutWidget extends StatefulWidget {
  late Datastore datastore;
  WorkoutWidget({Key? key, required this.datastore}) : super(key: key);

  @override
  State createState() => _WorkoutState();
}

class _WorkoutState extends State<WorkoutWidget> {
  TextEditingController searchTextController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";
  String locale = "";
  List<String> partList = [];

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