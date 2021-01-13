import 'package:flutter/material.dart';
import 'package:appradiotarascamaravatio/models/Article.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';

Widget programaBox(BuildContext context, Article article, String heroId) {
  return Container(
    child: Container(
      padding: EdgeInsets.all(10),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Stack(
            children: <Widget>[
              Container(
                  height: 500,
                  decoration: new BoxDecoration(
                      //border: Border.all(color: Colors.white),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.purple, Colors.blue]),
                      //shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: new NetworkImage(
                            article.image,
                          )))),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Html(
                        data: article.title.length > 100
                            ? "<h1>" +
                                article.title.substring(0, 100) +
                                "...</h1>"
                            : "<h1>" + article.title + "</h1>",
                        customTextAlign: (dom.Node node) {
                          if (node is dom.Element) {
                            switch (node.localName) {
                              case "h1":
                                return TextAlign.center;
                            }
                          }
                        },
                        customTextStyle: (
                          dom.Node node,
                          TextStyle baseStyle,
                        ) {
                          if (node is dom.Element) {
                            switch (node.localName) {
                              case "h1":
                                return baseStyle.merge(Theme.of(context)
                                    .textTheme
                                    .title
                                    .merge(TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    )));
                            }
                          }
                          return baseStyle;
                        }),
                  ),
                ),
              ),
            ],
          )),
    ),
    /*
    Container(
        // padding: EdgeInsets.all(20),
        /*decoration: BoxDecoration(
          color: Color.fromRGBO(245, 245, 245, 1),
          borderRadius: BorderRadius.circular(10),
          //border: Border.all(color: Color.fromRGBO(240, 240, 240, 1)),
        ),*/
        child: InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 244,
            width: double.infinity,
            //fit: BoxFit.fitWidth,
            //color: Colors.grey[200],
            child: Image.network(
              article.image,
              fit: BoxFit.fill,
            ),
          ),
          /*Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Html(
                    data: article.title.length > 70
                        ? "<h1>" + article.title.substring(0, 70) + "...</h1>"
                        : "<h1>" + article.title + "</h1>",
                    customTextAlign: (dom.Node node) {
                      if (node is dom.Element) {
                        switch (node.localName) {
                          case "h1":
                            return TextAlign.center;
                        }
                      }
                    },
                    customTextStyle: (
                      dom.Node node,
                      TextStyle baseStyle,
                    ) {
                      if (node is dom.Element) {
                        switch (node.localName) {
                          case "h1":
                            return baseStyle.merge(Theme.of(context)
                                .textTheme
                                .title
                                .merge(TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Futura",
                                )));
                        }
                      }
                      return baseStyle;
                    }),
              ),*/
          /*Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      article.category + " | " + article.date,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w400),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: new SvgPicture.asset('assets/share.svg',
                          height: 8, color: Colors.black),
                      onPressed: () {
                        Share.share('Comparte: ' + article.link);
                      },
                    ),
                  ],
                ),
              ),*/
        ],
      ),
    )
    ),*/
  );
}
