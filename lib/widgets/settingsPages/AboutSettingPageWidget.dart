import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutSettingPageWidget extends StatefulWidget {
  AboutSettingPageWidget({Key? key}) : super(key: key);

  @override
  State createState() => _AboutSettingPageState();
}

class _AboutSettingPageState extends State<AboutSettingPageWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget paddedText(String text, {EdgeInsets? padding, TextStyle? style}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(5),
        child: Text(
          text,
          style: style ?? const TextStyle(color: Colors.black),
        ));
  }

  Widget linkedUrl(String caption, String url) {
    return Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: GestureDetector(
          child: Text(caption,
              style: const TextStyle(fontSize: 14, color: Colors.blue)),
          onTap: () async {
            if (await canLaunchUrl(Uri.parse((url)))) launchUrl(Uri.parse(url));
          },
        ));
  }

  TextStyle menuCategory = GoogleFonts.lato(
      textStyle: TextStyle(
          color: Colors.blueAccent.shade200,
          fontWeight: FontWeight.bold,
          fontSize: 22));

  TextStyle titleText = GoogleFonts.lato(
      textStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15));

  TextStyle menuText = GoogleFonts.lato(
      textStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15));

  Widget div = const Divider(
    height: 1,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: SizedBox(
                    width: mediaQueryData.size.width,
                    height: mediaQueryData.size.height - 64,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: mediaQueryData.viewPadding.top,
                          ),
                          paddedText(
                            "About",
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            style: menuCategory,
                          ),
                          Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .settings_developer_info,
                                  style: titleText)),
                          Container(
                            padding: const EdgeInsets.fromLTRB(30, 10, 20, 10),
                            child: Row(children: <Widget>[
                              Text(AppLocalizations.of(context)!.name,
                                  style: menuText),
                              const Spacer(),
                              Text("Daniel Choi", style: menuText),
                            ]),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(30, 10, 20, 20),
                            child: Row(children: <Widget>[
                              Text(AppLocalizations.of(context)!.contact,
                                  style: menuText),
                              const Spacer(),
                              Text("jerichoi224@gmail.com", style: menuText),
                            ]),
                          ),
                          div,
                          Container(
                              padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                              child: Text(AppLocalizations.of(context)!.credits,
                                  style: titleText)),
                          Container(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 10, 20, 10),
                              child: Text(AppLocalizations.of(context)!.image,
                                  style: menuText)),
                          Container(
                            padding: const EdgeInsets.fromLTRB(40, 5, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                linkedUrl(
                                    "Wallet icons created by Freepik - Flaticon",
                                    'https://www.flaticon.com/free-icons/wallet')
                              ],
                            ),
                          ),
                        ])))));
  }
}
