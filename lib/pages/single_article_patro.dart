import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:appradiotarascamaravatio/common/constants.dart';
import 'package:appradiotarascamaravatio/models/Article.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class SingleArticlePatro extends StatefulWidget {
  final dynamic article;
  final String heroId;

  SingleArticlePatro(this.article, this.heroId, {Key key}) : super(key: key);

  @override
  _SingleArticlePatroState createState() => _SingleArticlePatroState();
}

class _SingleArticlePatroState extends State<SingleArticlePatro> {
  List<dynamic> relatedArticles = [];

  Future<dynamic> favArticle;

  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>> fetchRelatedArticles() async {
    try {
      int postId = widget.article.id;
      int catId = widget.article.catId;
      var response = await http.get(
          "$WORDPRESS_URL/wp-json/wp/v2/posts?exclude=$postId&categories[]=$catId&per_page=3");

      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            relatedArticles = json
                .decode(response.body)
                .map((m) => Article.fromJson(m))
                .toList();
          });

          return relatedArticles;
        }
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return relatedArticles;
  }

  @override
  void dispose() {
    super.dispose();
    relatedArticles = [];
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final heroId = widget.heroId;
    //final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(12, 12, 12, 1),
      body: Container(
          //decoration: BoxDecoration(color: Colors.white70),
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  color: Color.fromRGBO(12, 12, 12, 1),
                  child: Hero(
                    tag: heroId,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0)),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.overlay),
                        child: Image.network(
                          article.image,
                          fit: BoxFit.cover,
                          //height: height,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            Container(
              color: Color.fromRGBO(12, 12, 12, 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Html(
                    data: "<h1>" + article.title + "</h1>",
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    customTextStyle: (dom.Node node, TextStyle baseStyle) {
                      if (node is dom.Element) {
                        switch (node.localName) {
                          case "h1":
                            return Theme.of(context).textTheme.title.merge(
                                TextStyle(
                                    fontSize: 22,
                                    fontFamily: "Jos",
                                    color: Colors.white));
                        }
                      }
                      return baseStyle;
                    },
                    customTextAlign: (dom.Node node) {
                      if (node is dom.Element) {
                        switch (node.localName) {
                          case "h1":
                            return TextAlign.center;
                        }
                      }
                    },
                  ),
                  Html(
                      data: "<div>" + article.content + "</div>",
                      padding: EdgeInsets.fromLTRB(16, 15, 16, 50),
                      customTextAlign: (dom.Node node) {
                        if (node is dom.Element) {
                          switch (node.localName) {
                            case "p":
                              return TextAlign.justify;
                          }
                        }
                      },
                      customTextStyle: (dom.Node node, TextStyle baseStyle) {
                        if (node is dom.Element) {
                          switch (node.localName) {
                            case "div":
                              return baseStyle.merge(TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Jos",
                                  color: Colors.white));
                          }
                        }
                        return baseStyle;
                      }),
                ],
              ),
            ),
            //relatedPosts(_futureRelatedArticles)
          ],
        ),
      )),
    );
  }

  /*Widget relatedPosts(Future<List<dynamic>> latestArticles) {
    return FutureBuilder<List<dynamic>>(
      future: latestArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data.length == 0) return Container();
        } else if (articleSnapshot.hasError) {
          return Container(
              height: 500,
              alignment: Alignment.center,
              child: Text("${articleSnapshot.error}"));
        }
        return Container();
      },
    );
  }*/
}
