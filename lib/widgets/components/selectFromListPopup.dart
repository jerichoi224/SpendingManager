import 'package:flutter/material.dart';

Widget _buildList(int index, List<String> list) {
  list.sort();
  String item = list[index];
  return StatefulBuilder(
      builder: (context, setState)
      {
        return ListTile(
          title: Text(
              item
          ),
          onTap: (){
            Navigator.of(context).pop(item);
          },
        );
      }
  );
}


Future<dynamic> selectFavoriteDialog(BuildContext context, List<String> list) async{
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                  scrollable: true,
                  content: SizedBox(
                    // Increate size everytime a new warning is added
                    height: 600,
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topRight,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Center(
                          child: Text( "Select Carriers",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 450,
                          child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    itemCount: list.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return _buildList(index, list);
                                    },
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                  ),
                                ],
                              )
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  )
              );
            }
        );
      }
  );
}