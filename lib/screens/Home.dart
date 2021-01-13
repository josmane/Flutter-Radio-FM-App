import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appradiotarascamaravatio/screens/Songspage.dart';
import 'package:loading/indicator/line_scale_party_indicator.dart';
import 'package:loading/loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future getdata() async {
    QuerySnapshot qn =
        await Firestore.instance.collection('songs').getDocuments();
    return qn.documents;
  }

  @override
  dispose() {
    // you need this
    super.dispose();
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
                    "Top 5 Tarasca",
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
            FutureBuilder(
              future: getdata(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Loading(
                        indicator: LineScalePartyIndicator(),
                        size: 50.0,
                        color: Colors.white),
                  );
                } else {
                  return ListView.builder(
                      padding: EdgeInsets.only(top: 0),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Songspage(
                                        song_name: snapshot
                                            .data[index].data["song_name"],
                                        artist_name: snapshot
                                            .data[index].data["artist_name"],
                                        song_url: snapshot
                                            .data[index].data["song_url"],
                                        image_url: snapshot
                                            .data[index].data["image_url"],
                                      ))),
                          child: Stack(
                            alignment: AlignmentDirectional.topStart,
                            children: <Widget>[
                              Container(
                                height: 130,
                                alignment: Alignment.bottomRight,
                                margin: EdgeInsets.fromLTRB(20, 15, 8, 0),
                                child: Card(
                                  color: Color.fromRGBO(28, 28, 28, 1),
                                  elevation: 6,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(110, 0, 0, 0),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(8, 0, 4, 8),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              40, 40, 40, 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              8, 4, 8, 4),
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 15, 0, 5),
                                                      child: Text(
                                                        snapshot.data[index]
                                                            .data["song_name"],
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              4, 8, 4, 8),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.star,
                                                            color:
                                                                Color.fromRGBO(
                                                                    231,
                                                                    168,
                                                                    14,
                                                                    1),
                                                            size: 15.0,
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            snapshot.data[index]
                                                                    .data[
                                                                "artist_name"],
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: SizedBox(
                                  height: 135,
                                  width: 130,
                                  child: Card(
                                    color: Color.fromRGBO(28, 28, 28, 1),
                                    child: ClipRRect(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                      child: Image.network(
                                        snapshot.data[index].data["image_url"],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 0,
                                    margin: EdgeInsets.all(5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }
              },
            ),
          ]),
        ));
  }
}
