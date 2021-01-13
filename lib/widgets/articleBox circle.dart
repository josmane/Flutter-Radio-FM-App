import 'package:flutter/material.dart';
import 'package:appradiotarascamaravatio/models/Article.dart';

Widget articleBoxCircle(BuildContext context, Article article, String heroId) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(3),
    child: Container(
        child: InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
              height: 75,
              width: 75,
              decoration: new BoxDecoration(
                  border: Border.all(color: Colors.white),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.purple, Colors.blue]),
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: new NetworkImage(
                        article.image,
                      )))),
          //fit: BoxFit.fitWidth,
          //color: Colors.grey[200],
        ],
      ),
    )),
  );
}
