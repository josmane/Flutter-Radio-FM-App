import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:appradiotarascamaravatio/common/constants.dart';
import 'package:appradiotarascamaravatio/models/Article.dart';
import 'package:appradiotarascamaravatio/pages/single_Article.dart';
import 'package:appradiotarascamaravatio/widgets/articleBox.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/line_scale_party_indicator.dart';
import 'package:loading/loading.dart';

class Galeria extends StatefulWidget {
  @override
  _GaleriaState createState() => _GaleriaState();
}

class _GaleriaState extends State<Galeria> {
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
        new ScrollController(initialScrollOffset: 5.0, keepScrollOffset: true);
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
          "$WORDPRESS_URL/wp-json/wp/v2/posts/?categories[]=$PAGE2_CATEGORY_ID&page=$page&per_page=10&_fields=id,date,title,content,custom,link");
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
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Container(
                height: 110.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(0.0)),
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
                      "Galería",
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
              categoryPosts(_futureArticles),
            ])));
  }

  Widget categoryPosts(Future<List<dynamic>> futureArticles) {
    return FutureBuilder<List<dynamic>>(
      future: futureArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data.length == 0) return Container();
          return Column(
            children: <Widget>[
              GridView.count(
                  padding: EdgeInsets.only(top: 0),
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  childAspectRatio: .75,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  shrinkWrap: true,
                  controller: _controller,
                  children: articleSnapshot.data.map((item) {
                    final heroId = item.id.toString() + "-latest";
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleArticle(item, heroId),
                          ),
                        );
                      },
                      child: articleBox(context, item, heroId),
                    );
                  }).toList()),
              !_infiniteStop
                  ? Container(
                      alignment: Alignment.center,
                      height: 30,
                      child: Center(
                          child: Loading(
                              indicator: LineScalePartyIndicator(),
                              size: 50.0,
                              color: Theme.of(context).accentColor)),
                    )
                  : Container(),
            ],
          );
        } else if (articleSnapshot.hasError) {
          return Center(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(15)),
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
