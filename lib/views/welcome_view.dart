import 'package:flutter/material.dart';
import 'package:flutter_hive_todo_app/utils/colors.dart';
import 'package:flutter_hive_todo_app/utils/dimens.dart';
import 'package:flutter_hive_todo_app/views/home_view.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  Future<bool> getSeenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);
    print(seen);
    //seen = false;
    return seen;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme tt = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: getSeenData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            bool seen = snapshot.data ?? false;
            print(seen);
            if (seen) {
              return const HomeView();
            } else {
              return Scaffold(
                backgroundColor: UiColorHelper.welcomeViewBgColor,
                body: SafeArea(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Image.asset('assets/images/welcome.png'),
                    Lottie.asset('assets/images/lottie_welcome.json'),
                    Expanded(
                      child: Padding(
                        padding: UiHelper.allPadding6x,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  Constants.welcomeTitle,
                                  style: tt.headline5!.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: UiHelper.verticalSymmetricPadding3x,
                                  child: Text(
                                    Constants.welcomeSubTitle,
                                    style: tt.subtitle1,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: size.width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences preferences = await SharedPreferences.getInstance();
                                  preferences.setBool('seen', true);

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const HomeView(),
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: UiColorHelper.yellowColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                child: Padding(
                                  padding: UiHelper.verticalSymmetricPadding3x,
                                  child: Text(
                                    Constants.welcomeButtonText,
                                    style: tt.headline6!.copyWith(color: UiColorHelper.grayColor),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
              );
            } // your widget
          } else {
            return const Scaffold();
          }
        });
  }
}
