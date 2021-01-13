import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:appradiotarascamaravatio/pages/Program.dart';
import 'package:appradiotarascamaravatio/pages/Galeria.dart';
import 'package:appradiotarascamaravatio/pages/RadTarasca.dart';
import 'package:appradiotarascamaravatio/pages/about.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:appradiotarascamaravatio/screens/Home.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color.fromRGBO(250, 250, 250, 1),
        accentColor: Colors.red,
        textTheme: TextTheme(
            title: TextStyle(
              fontSize: 17,
              color: Colors.black,
              height: 1.2,
              fontWeight: FontWeight.w500,
              fontFamily: "Jos",
            ),
            caption: TextStyle(color: Colors.black45, fontSize: 10),
            body1: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            )),
        fontFamily: "Jos",
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      home: MyHomePage(
        analytics: analytics,
        observer: observer,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.analytics, this.observer})
      : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Firebase Cloud Messeging setup
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    RadTarasca(),
    Home(),
    Programa(),
    Galeria(),
    About(),
  ];

  @override
  void initState() {
    super.initState();
  }

  startFirebase() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'notification';
    final value = prefs.getInt(key) ?? 0;
    if (value == 1) {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  message["notification"]["title"],
                  style: TextStyle(fontFamily: "Jos", fontSize: 18),
                ),
                content: Text(message["notification"]["body"]),
                actions: <Widget>[
                  FlatButton(
                    child: new Text("Dismiss"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        onLaunch: (Map<String, dynamic> message) async {
          // print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          // print("onResume: $message");
        },
      );
      _firebaseMessaging.getToken().then((token) {
        // print("Firebase Token:" + token);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        elevation: 5,
        selectedItemColor: Color.fromRGBO(220, 10, 18, 1),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        unselectedItemColor: Color.fromRGBO(250, 250, 250, 1),
        selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w700, fontFamily: "Jos", fontSize: 11),
        onTap: _onItemTapped,
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        type: BottomNavigationBarType.fixed,
        //unselectedLabelStyle: TextStyle(fontFamily: "Jos", fontSize:9),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: new SvgPicture.asset(
                'assets/menu/radio.svg',
                height: 25,
                color: _selectedIndex == 0
                    ? Color.fromRGBO(220, 10, 18, 1)
                    : Color.fromRGBO(250, 250, 250, 1),
              ),
              title: Text("Radio")),
          BottomNavigationBarItem(
              icon: new SvgPicture.asset(
                'assets/menu/popular.svg',
                height: 25,
                color: _selectedIndex == 1
                    ? Color.fromRGBO(220, 10, 18, 1)
                    : Color.fromRGBO(250, 250, 250, 1),
              ),
              title: Text("Top")),
          BottomNavigationBarItem(
              icon: new SvgPicture.asset(
                'assets/menu/music-and-multimedia.svg',
                height: 25,
                color: _selectedIndex == 2
                    ? Color.fromRGBO(220, 10, 18, 1)
                    : Color.fromRGBO(250, 250, 250, 1),
              ),
              title: Text("Programación")),
          BottomNavigationBarItem(
              icon: new SvgPicture.asset(
                'assets/menu/photo.svg',
                height: 25,
                color: _selectedIndex == 3
                    ? Color.fromRGBO(220, 10, 18, 1)
                    : Color.fromRGBO(250, 250, 250, 1),
              ),
              title: Text("Galería")),
          BottomNavigationBarItem(
              icon: new SvgPicture.asset(
                'assets/menu/friendship.svg',
                height: 25,
                color: _selectedIndex == 4
                    ? Color.fromRGBO(220, 10, 18, 1)
                    : Color.fromRGBO(250, 250, 250, 1),
              ),
              title: Text("Acerca De")),
          /*BottomNavigationBarItem(
              icon: new SvgPicture.asset(
                'assets/menu/negative-vote.svg',
                height: 25,
                color: _selectedIndex == 3
                    ?   Color.fromRGBO(250, 250, 250, 1)    
                    :   Color.fromRGBO(250, 250, 250, 1)    ,
              ),
              title: Text("Denuncia")),
          */
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
