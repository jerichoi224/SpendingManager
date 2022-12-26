import 'dart:io';
import 'package:spending_manager/objectbox.g.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

// https://github.com/objectbox/objectbox-dart/blob/main/objectbox/example/flutter/objectbox_demo/lib/objectbox.dart
/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class Datastore {
  /// The Store of this app.
  late Store store;
  late final SharedPreferences prefs;
  Map<String, dynamic> prefMap = {};
//  late Box<ShipmentItem> shipmentBox;
//  List<ShipmentItem> shipmentList = [];

  Datastore._create(this.store, this.prefs) {
    initObjectBox();
  }

  void initObjectBox()
  {
//    shipmentBox = Box<ShipmentItem>(store);
//    shipmentList = shipmentBox.getAll();

    for(String key in prefs.getKeys()) {
      prefMap[key] = prefs.get(key);
    }
  }

  void setPref(String key, dynamic value)
  {
    if(value.runtimeType == String) {
      prefs.setString(key, value);
    }
    else if(value.runtimeType == double) {
      prefs.setDouble(key, value);
    }
    else if(value.runtimeType == bool) {
      prefs.setBool(key, value);
    }
    else if(value.runtimeType == int) {
      prefs.setInt(key, value);
    }
    else if(value.runtimeType == List<String>){
      prefs.setStringList(key, value);
    }
    prefMap[key] = value;
  }

  dynamic getPref(String key)
  {
    return prefMap[key];
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<Datastore> create() async {
//    final dbFilePath = await objectBoxDataFilePath();
    final store = await openStore();
    final prefs = await SharedPreferences.getInstance();
    return Datastore._create(store, prefs);
  }

  static Future<String> objectBoxDataFilePath() async{
    final directory = (await getApplicationDocumentsDirectory()).path;
    return "$directory/objectbox/data.mdb";
  }

  bool closeStore(){
    store.close();
    return true;
  }

  restartDB() async{
    store = await openStore();
    initObjectBox();
  }

}