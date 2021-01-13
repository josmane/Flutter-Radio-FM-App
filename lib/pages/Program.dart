import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:appradiotarascamaravatio/common/constants.dart';
import 'package:appradiotarascamaravatio/models/Article.dart';
import 'package:appradiotarascamaravatio/pages/single_article_programa.dart';
import 'package:appradiotarascamaravatio/widgets/ProgramaBox.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/line_scale_party_indicator.dart';
import 'package:loading/loading.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Programa extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<Programa> {
  int _current = 0;

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
        ScrollController(initialScrollOffset: 5.0, keepScrollOffset: true);
    _controller.addListener(_scrollListener);
    _infiniteStop = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<List<dynamic>> fetchGaleria(int page) async {
    try {
      http.Response response = await http.get(
          "$WORDPRESS_URL/wp-json/wp/v2/posts/?categories[]=$PAGE4_CATEGORY_ID&page=$page&per_page=10&_fields=id,date,title,content,custom,link");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(12, 12, 12, 1),
      /* appBar: AppBar(
          backgroundColor:   Color.fromRGBO(12, 12, 12, 1)    ,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Programación Test :3',
            style: TextStyle(fontSize: 18, color: Colors.white),
          )),*/
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child: Column(children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 110.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0)),
                      gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(81, 24, 69, 1),
                            Color.fromRGBO(195, 20, 50, 1)
                          ],
                          begin: FractionalOffset(0.3, 0.0),
                          end: FractionalOffset(2.0, 0.6),
                          stops: [0.0, 0.6],
                          tileMode: TileMode.clamp)),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Programación",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 27.0,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  alignment: Alignment(-0.9, -0.6),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                ),
                programPosts(_futureArticles),
              ],
            ),
          ]))),
    );
  }

  Widget programPosts(Future<List<dynamic>> futureArticles) {
    return FutureBuilder<List<dynamic>>(
      future: futureArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data.length == 0) return Container();
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CarouselSlider(
                  items: articleSnapshot.data.map((item) {
                    final heroId = item.id.toString() + "-latest";
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SingleArticlePrograma(item, heroId),
                          ),
                        );
                      },
                      child: programaBox(context, item, heroId),
                    );
                  }).toList(),
                  options: CarouselOptions(
                      height: 500.0,
                      autoPlayAnimationDuration: Duration(seconds: 2),
                      autoPlayInterval: Duration(seconds: 6),
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: articleSnapshot.data.map((url) {
                    int index = articleSnapshot.data.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index ? Colors.pink : Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ]);
          !_infiniteStop
              ? Container(
                  alignment: Alignment.center,
                  height: 30,
                  child: Loading(
                      indicator: LineScalePartyIndicator(),
                      size: 50.0,
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
                size: 60.0,
                color: Colors.white));
      },
    );
  }
}
