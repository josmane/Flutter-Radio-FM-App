import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:appradiotarascamaravatio/common/constants.dart';
import 'package:appradiotarascamaravatio/models/Article.dart';
import 'package:appradiotarascamaravatio/pages/single_Article.dart';
import 'package:appradiotarascamaravatio/widgets/articleBox.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_scale_multiple_indicator.dart';
import 'package:loading/loading.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocalArticles extends StatefulWidget {
  @override
  _LocalArticlesState createState() => _LocalArticlesState();
}

class _LocalArticlesState extends State<LocalArticles> {
  List<dynamic> articles = [];
  Future<List<dynamic>> _futureArticles;

  ScrollController _controller;
  int page = 1;
  bool _infiniteStop;

  @override
  void initState() {
    super.initState();
    _futureArticles = fetchLocalArticles(1);
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller.addListener(_scrollListener);
    _infiniteStop = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<List<dynamic>> fetchLocalArticles(int page) async {
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
        _futureArticles = fetchLocalArticles(page);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          PAGE2_CATEGORY_NAME,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Poppins'),
        ),
        elevation: 5,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _controller,
            child: Column(
              children: <Widget>[
                categoryPosts(_futureArticles),
              ],
            )),
      ),
    );
  }

  Widget categoryPosts(Future<List<dynamic>> futureArticles) {
    return FutureBuilder<List<dynamic>>(
      future: futureArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data.length == 0) return Container();
          return Column(
            children: <Widget>[
              Column(
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
                      child: Loading(
                          indicator: BallScaleMultipleIndicator(),
                          size: 60.0,
                          color: Theme.of(context).accentColor))
                  : Container()
            ],
          );
        } else if (articleSnapshot.hasError) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                    _futureArticles = fetchLocalArticles(1);
                    //_futureFeaturedArticles = fetchFeaturedArticles(1);
                  },
                )
              ],
            ),
          );
        }
        return Container(
            alignment: Alignment.center,
            height: 400,
            width: MediaQuery.of(context).size.width - 30,
            child: Loading(
                indicator: BallScaleMultipleIndicator(),
                size: 60.0,
                color: Theme.of(context).accentColor));
      },
    );
  }
}
