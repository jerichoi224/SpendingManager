import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spending_manager/dbModels/categoryEntry.dart';
import 'package:spending_manager/dbModels/accountEntry.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/main.dart';

class InstructionWidget extends StatefulWidget {
  final BuildContext parentCtx;
  final Datastore datastore;
  InstructionWidget({Key? key, required this.parentCtx, required this.datastore});

  @override
  State createState() => _InstructionState();
}

class _InstructionState extends State<InstructionWidget>{
  final pageController = PageController(initialPage: 0);
  TextEditingController userName = new TextEditingController();
  Map<String, String> languages = {'English': 'en', '한국어': 'kr'};

  int _currentIndex = 0;
  String locale = "";

  @override
  void initState(){
    super.initState();
    String? temp = widget.datastore.getPref("locale");
    locale = temp != null ? temp : 'en';
  }

  void setLanguage(String language)
  {
    Locale newLocale = Locale(language, '');
    widget.datastore.setPref("locale", language);
    MyApp.setLocale(context, newLocale);
    setState(() {});
  }

  finishSplash() async {
      nextPage();

      widget.datastore.accountBox.put(AccountEntry(caption: "KB Checking"));
      widget.datastore.accountBox.put(AccountEntry(caption: "Toss Checking"));
      widget.datastore.accountList = widget.datastore.accountBox.getAll();

      widget.datastore.categoryBox.put(CategoryEntry(caption: "Transfer", iconId: 1, basic: true));
      widget.datastore.categoryBox.put(CategoryEntry(caption: "Other", iconId: 2, basic: true));
      widget.datastore.categoryBox.put(CategoryEntry(caption: "Gift", iconId: 3, basic: true));
      widget.datastore.categoryBox.put(CategoryEntry(caption: "Food", iconId: 4, basic: true));
      widget.datastore.categoryBox.put(CategoryEntry(caption: "Cafe", iconId: 5, basic: true));
      widget.datastore.categoryBox.put(CategoryEntry(caption: "Transportation", iconId: 6, basic: true));
      widget.datastore.categoryBox.put(CategoryEntry(caption: "Subscription", iconId: 7, basic: true));
      widget.datastore.categoryBox.put(CategoryEntry(caption: "Shopping", iconId: 8, basic: true));
      widget.datastore.categoryBox.put(CategoryEntry(caption: "Hobby", iconId: 9, basic: true));
      widget.datastore.categoryBox.put(CategoryEntry(caption: "Medical", iconId: 10, basic: true));
      widget.datastore.categoryBox.put(CategoryEntry(caption: "Fitness", iconId: 11, basic: true));
      widget.datastore.categoryList = widget.datastore.categoryBox.getAll();

      widget.datastore.setPref('show_instruction', false);
      await Future.delayed(const Duration(seconds: 2), (){});
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }


  nextPage() {
    setState(() {
      _currentIndex += 1;
      pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  showSnackBar(BuildContext context, String s){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s),
      duration: Duration(seconds: 3),
    ));
  }

  Widget languageScreen(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: new Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/languages.png'),
                      width: 150,
                    )
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Center(
                        child: Text(
                          "",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                    )
                ),
                Center(
                ),
                Container(
                    width: 200,
                    child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.fromLTRB(0, 25, 0, 10),
                    color: Colors.amber,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                              onTap:(){
                                nextPage();
                              },
                              title: Text("",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              )
                          )
                        ]
                    )
                  )
                )
              ],
            )
        )
    );
  }
  Widget introScreen(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          },
        child: new Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                      child: Container()
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Center(
                        child: Text("",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                    )
                ),
                Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Center(
                      child: ListTile(
                          title: new Row(
                            children: <Widget>[
                              Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "",
                                    ),
                                    controller: userName,
                                    textAlign: TextAlign.center,
                                  )
                              )
                            ],
                          )
                      ),
                    )
                ),
                Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    color: Colors.amber,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                              onTap:(){
                                if(userName.text.isEmpty) {
                                  final snackBar = SnackBar(
                                    content: Text(""));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  return;
                                }
                                nextPage();
                                },
                              title: Text("",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              )
                          )
                        ]
                    )
                )
              ],
            )
        )
    );
  }
  Widget metricScreen(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: new Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                      child: Image(
                        image: AssetImage('assets/settings.png'),
                        width: 150,
                      )
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Center(
                        child: Text(
                          "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                    )
                ),
                Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.grey,
                          ),
                          Text(" ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12
                            ),
                          )
                        ],
                      )
                  ),
                Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    color: Colors.amber,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                              onTap:(){
                                if(userName.text.isEmpty) {
                                  final snackBar = SnackBar(
                                    content: Text(""),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  return;
                                }
                                finishSplash();
                              },
                              title: Text("",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              )
                          )
                        ]
                    )
                )
              ],
            )
        )
    );
  }


  Widget loadingScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Center(
              child: Text("Loading",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16
                  )
              )
          ),
        ),
        SpinKitPouringHourGlassRefined(color: Colors.amberAccent),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> introPages = <Widget>[
      languageScreen(context),
      introScreen(context),
      metricScreen(context),
      loadingScreen(context)
    ];
    return Scaffold(
      body:
      Builder(
          builder: (context) => PageView(
              physics:new NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                FocusScope.of(context).unfocus();
                _currentIndex = index;
              },
              controller: pageController,
              children: introPages
          )
      ),
    );
  }
}