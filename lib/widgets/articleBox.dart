import 'package:flutter/material.dart';
import 'package:appradiotarascamaravatio/models/Article.dart';

Widget articleBox(BuildContext context, Article article, String heroId) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(3),
    child: Container(
        child: InkWell(
      child: Container(
          height: 244,
          width: double.infinity,
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
      //fit: BoxFit.fitWidth,
      //color: Colors.grey[200],
    )),
  );
}
