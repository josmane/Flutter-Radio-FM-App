import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:appradiotarascamaravatio/common/constants.dart';
import 'package:appradiotarascamaravatio/models/Article.dart';
import 'package:appradiotarascamaravatio/pages/single_article_patro.dart';
import 'package:appradiotarascamaravatio/widgets/articleBox circle.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/line_scale_party_indicator.dart';
import 'package:loading/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

//import 'package:appvivemaravatio/services/admob_service.dart';
//import 'package:admob_flutter/admob_flutter.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  //final ams = AdMobService();

  List<dynamic> articles = [];
  Future<List<dynamic>> _futureArticles;
  ScrollController _controller;
  int page = 1;
  bool _infiniteStop;

  @override
  void initState() {
    super.initState();
    _futureArticles = fetchGaleria(1);
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller.addListener(_scrollListener);
    _infiniteStop = false;
    checkNotificationSetting();
    //Admob.initialize(ams.getAdMobAppId());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<List<dynamic>> fetchGaleria(int page) async {
    try {
      http.Response response = await http.get(
          "$WORDPRESS_URL/wp-json/wp/v2/posts/?categories[]=$PAGE3_CATEGORY_ID&page=$page&per_page=10&_fields=id,date,title,content,custom,link");
      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            articles.addAll(json
                .decode(response.body)
                .map((m) => Article.fromJson(m))
                .toList());
            if (articles.length % 10 != 0) {
              _infiniteStop = true;
            }
          });

          return articles;
        }
        setState(() {
          _infiniteStop = true;
        });
      }
    } on SocketException {
      throw 'No Internet connection';
    }

    return articles;
  }

  _scrollListener() {
    var isEnd = _controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        _futureArticles = fetchGaleria(page);
      });
    }
  }

  checkNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'notification';
    final value = prefs.getInt(key) ?? 0;
    if (value == 0) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  saveNotificationSetting(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'notification';
    final value = val ? 1 : 0;
    prefs.setInt(key, value);
    if (value == 1) {
      setState(() {});
    } else {
      setState(() {});
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      /* Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: 
          (BuildContext context) => MyHomePage())); */
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(12, 12, 12, 1),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 55),
          ),
          Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Image(
                  image: AssetImage('assets/RadTarLogo.png'),
                  height: 185,
                  width: 185,
                ),
              ),
              Text("Patrocinado por:",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  )),
              Container(
                padding: EdgeInsets.only(bottom: 15),
                child: categoryPosts(_futureArticles),
              ),
              Text("Contacto:",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  )),
              FlatButton(
                  padding: EdgeInsets.only(bottom: 20),
                  onPressed: () async {
                    const url = 'mailto:radiotarasca@gmail.com';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'no se pudo abrir: $url';
                    }
                  },
                  child: Text(
                    "radiotarasca@gmail.com",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  )),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink,
                            spreadRadius: 2,
                            blurRadius: 10,
                            // changes position of shadow
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          const url =
                              'https://wa.me/524471264755?text=Hola!%20Gracias por comunicarte!%20manda tu saludo%20o%20pide una canción!';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'no se pudo abrir: $url';
                          }
                        }, // handle your image tap here
                        child: SvgPicture.asset(
                          "assets/whatsapp.svg",
                          fit: BoxFit.cover, // this is the solution for border
                          width: 40.0,
                          height: 40.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(25),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink,
                            spreadRadius: 2,
                            blurRadius: 10,
                            // changes position of shadow
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          const url = 'https://m.me/RadioTarasca';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'no se pudo abrir: $url';
                          }
                        }, // handle your image tap here
                        child: SvgPicture.asset(
                          "assets/blackberry-messenger.svg",
                          fit: BoxFit.cover, // this is the solution for border
                          width: 40.0,
                          height: 40.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(25),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink,
                            spreadRadius: 2,
                            blurRadius: 10,
                            // changes position of shadow
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          const url =
                              'https://www.facebook.com/Radio-Tarasca-A-C-1309247262536017';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'no se pudo abrir: $url';
                          }
                        }, // handle // handle your image tap here
                        child: SvgPicture.asset(
                          "assets/facebook.svg",
                          fit: BoxFit.cover, // this is the solution for border
                          width: 40.0,
                          height: 40.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 25, 0, 10),
                child: Text(
                  "Con ♥ Radio Tarasca 102.7 FM \n X H S C B J",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                "Version 1.0.0",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget categoryPosts(Future<List<dynamic>> futureArticles) {
    return FutureBuilder<List<dynamic>>(
      future: futureArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data.length == 0) return Container();
          return GridView.count(
              physics: ScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1.58,
              crossAxisSpacing: 0,
              shrinkWrap: true,
              children: articleSnapshot.data.map((item) {
                final heroId = item.id.toString() + "-latest";
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleArticlePatro(item, heroId),
                      ),
                    );
                  },
                  child: articleBoxCircle(context, item, heroId),
                );
              }).toList());
          !_infiniteStop
              ? Container(
                  alignment: Alignment.center,
                  height: 30,
                  child: Loading(
                      indicator: LineScalePartyIndicator(),
                      size: 60.0,
                      color: Colors.white))
              : Container();
        } else if (articleSnapshot.hasError) {
          return Center(
            child: Column(
              children: <Widget>[
                SvgPicture.asset(
                  "assets/saad.svg",
                  color: Colors.white,
                  width: 100,
                  height: 100,
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "No hay conexión a internet.",
                  style: TextStyle(
                      height: 1.0,
                      color: Color.fromRGBO(150, 150, 150, 1),
                      fontSize: 13,
                      fontWeight: FontWeight.normal),
                ),
                FlatButton.icon(
                  icon: Icon(
                    Icons.refresh,
                    color: Color.fromRGBO(150, 150, 150, 1),
                  ),
                  label: Text(
                    "Recargar",
                    style: TextStyle(
                        height: 1.0,
                        color: Color.fromRGBO(150, 150, 150, 1),
                        fontSize: 13,
                        fontWeight: FontWeight.normal),
                  ),
                  onPressed: () {
                    _futureArticles = fetchGaleria(1);
                    //_futureFeaturedArticles = fetchFeaturedArticles(1);
                  },
                )
              ],
            ),
          );
        }
        return Container(
            alignment: Alignment.center,
            child: Loading(
                indicator: LineScalePartyIndicator(),
                size: 50.0,
                color: Colors.white));
      },
    );
  }
}
