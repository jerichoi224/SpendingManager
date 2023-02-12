import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spending_manager/dbModels/categoryEntry.dart';
import 'package:spending_manager/dbModels/accountEntry.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spending_manager/widgets/components/confirmPopup.dart';

class InstructionWidget extends StatefulWidget {
  final BuildContext parentCtx;
  final Datastore datastore;

  InstructionWidget(
      {Key? key, required this.parentCtx, required this.datastore});

  @override
  State createState() => _InstructionState();
}

class _InstructionState extends State<InstructionWidget> {
  final pageController = PageController(initialPage: 0);
  TextEditingController accountName = TextEditingController();
  Map<String, String> languages = {'English': 'en', '한국어': 'kr'};

  int _currentIndex = 0;
  String locale = "";

  String currency = "KRW";

  @override
  void initState() {
    super.initState();
    String? temp = widget.datastore.getPref("locale");
    locale = temp ?? 'en';
  }

  void setLanguage(String language) {
    Locale newLocale = Locale(language, '');
    widget.datastore.setPref("locale", language);
    MyApp.setLocale(context, newLocale);
    setState(() {});
  }

  void setCurrency(String currency) {
    widget.datastore.setPref("currency", currency);
    setState(() {});
  }

  finishSplash() async {
    nextPage();
    widget.datastore.accountList = widget.datastore.accountBox.getAll();

    widget.datastore.categoryBox
        .put(CategoryEntry(caption: "Transfer", iconId: 1, basic: true));
    widget.datastore.categoryBox
        .put(CategoryEntry(caption: "Other", iconId: 2, basic: true));
    widget.datastore.categoryBox
        .put(CategoryEntry(caption: "Gift", iconId: 3, basic: false));
    widget.datastore.categoryBox
        .put(CategoryEntry(caption: "Food", iconId: 4, basic: false));
    widget.datastore.categoryBox
        .put(CategoryEntry(caption: "Cafe", iconId: 5, basic: false));
    widget.datastore.categoryBox
        .put(CategoryEntry(caption: "Transportation", iconId: 6, basic: false));
    widget.datastore.categoryBox
        .put(CategoryEntry(caption: "Subscription", iconId: 7, basic: false));
    widget.datastore.categoryBox
        .put(CategoryEntry(caption: "Shopping", iconId: 8, basic: false));
    widget.datastore.categoryBox
        .put(CategoryEntry(caption: "Hobby", iconId: 9, basic: false));
    widget.datastore.categoryBox
        .put(CategoryEntry(caption: "Medical", iconId: 10, basic: false));
    widget.datastore.categoryBox
        .put(CategoryEntry(caption: "Fitness", iconId: 11, basic: false));
    widget.datastore.categoryList = widget.datastore.categoryBox.getAll();

    widget.datastore.setPref('show_instruction', false);
    await Future.delayed(const Duration(seconds: 2), () {});
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  nextPage() {
    setState(() {
      _currentIndex += 1;
      pageController.animateToPage(_currentIndex,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  showToast(BuildContext context, String s) {
    Fluttertoast.showToast(msg: s);
  }

  Widget languageScreen(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                  child: Image(
                image: AssetImage('assets/languages.png'),
                width: 150,
              )),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: Center(
                    child: Text(
                  AppLocalizations.of(context)!.instruction_select_language,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ))),
            Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  items: languages.keys
                      .toList()
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: languages.keys
                      .firstWhere((element) => languages[element] == locale),
                  onChanged: (value) {
                    setState(() {
                      String? newLocale = languages[value];
                      locale = newLocale!;
                      setLanguage(locale);
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.grey,
                  iconDisabledColor: Colors.grey,
                  buttonHeight: 50,
                  buttonWidth: 200,
                  buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                  buttonDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                  ),
                  buttonElevation: 1,
                  itemHeight: 50,
                  itemPadding: const EdgeInsets.only(left: 14, right: 14),
                  dropdownMaxHeight: 200,
                  dropdownWidth: 200,
                  dropdownPadding: null,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  dropdownElevation: 8,
                  scrollbarRadius: const Radius.circular(40),
                  scrollbarThickness: 6,
                  scrollbarAlwaysShow: true,
                  offset: const Offset(0, 0),
                ),
              ),
            ),
            SizedBox(
                width: 200,
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 10),
                    color: Colors.blue.shade200,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                              onTap: () {
                                setLanguage(locale);
                                nextPage();
                              },
                              title: Text(
                                AppLocalizations.of(context)!.next,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ))
                        ])))
          ],
        )));
  }

  Widget introScreen(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.instruction_ask_name_msg,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        )
                    )
                ),
                Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Center(
                      child: ListTile(
                          title: Row(
                            children: <Widget>[
                              Flexible(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Account name",
                                    ),
                                    controller: accountName,
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
                    margin: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    color: Colors.blue.shade200,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                              onTap:(){
                                if(accountName.text.isEmpty) {
                                  Fluttertoast.showToast(msg: "You need to add a bank/card to use");
                                  return;
                                }
                                widget.datastore.accountBox.put(AccountEntry(caption: accountName.text));
                                finishSplash();
                              },
                              title: Text(AppLocalizations.of(context)!.start,
                                style: const TextStyle(
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
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                  child: Image(
                image: AssetImage('assets/settings.png'),
                width: 150,
              )),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: Center(
                    child: Text(
                  AppLocalizations.of(context)!.instruction_initial_setting,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ))),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Column(
                  children: <Widget>[
                    ListTile(
                        title: Row(
                      children: <Widget>[
                        const Text("Currency "),
                        const Spacer(),
                        DropdownButton<String>(
                          value: currency,
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (value) {
                            setState(() {
                              currency = value!;
                            });
                          },
                          underline: Container(
                            height: 2,
                          ),
                          selectedItemBuilder: (BuildContext context) {
                            return ["KRW", "USD"].map<Widget>((String value) {
                              return Container(
                                  alignment: Alignment.centerRight,
                                  width: 100, // TODO: Find Proper Width
                                  child: Text(value, textAlign: TextAlign.end));
                            }).toList();
                          },
                          items: ["KRW", "USD"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ],
                    )),
                  ],
                )),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                margin: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                color: Colors.blue.shade200,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                          onTap: () {
                            confirmPopup(
                                    context,
                                    "Confirm Currency",
                                    "You won't be able to change the currency you use after this.",
                                    "Ok",
                                    "Back")
                                .then((value) {
                              if (value) {
                                setCurrency(currency);
                                nextPage();
                              }
                            });
                          },
                          title: Text(
                            AppLocalizations.of(context)!.next,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ))
                    ]))
          ],
        )));
  }

  Widget loadingScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          child: const Center(
              child: Text("Loading",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 16))),
        ),
        SpinKitPouringHourGlassRefined(color: Colors.blue.shade300),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> introPages = <Widget>[
      languageScreen(context),
      metricScreen(context),
      introScreen(context),
      loadingScreen(context)
    ];
    return Scaffold(
      body: Builder(
          builder: (context) => PageView(
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                FocusScope.of(context).unfocus();
                _currentIndex = index;
              },
              controller: pageController,
              children: introPages)),
    );
  }
}
