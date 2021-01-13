import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:url_audio_stream/url_audio_stream.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:music_player/music_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RadTarasca extends StatefulWidget {
  @override
  _RadTarascaState createState() => _RadTarascaState();
}

class _RadTarascaState extends State<RadTarasca> {
  MusicPlayer musicPlayer;

  AnimationController animationController;
  String status = 'hidden';
  bool isplaying1 = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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
                  style: TextStyle(fontFamily: "Futura", fontSize: 18),
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

  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');
  @override
  void initState() {
    super.initState();
    initPlatformState();
    MediaNotification.setListener('pause', () {
      callAudio("stop");
      setState(() => status = 'pause');
    });

    MediaNotification.setListener('play', () {
      callAudio("start");
      setState(() => status = '');
    });
  }

  static AudioStream stream = new AudioStream(
      "https://node-02.zeno.fm/zrn2vr7fhzzuv.aac?rj-ttl=5&rj-tok=AAABdGtOuiUAhqCQFk1mVB3xBg");
  Future<void> callAudio(String action) async {
    if (action == "start") {
      stream.start();
    } else if (action == "stop") {
      stream.stop();
    } else if (action == "pause") {
      stream.pause();
    } else {
      stream.resume();
    }
  }

// Initializing the Music Player and adding a single [PlaylistItem]
  Future<void> initPlatformState() async {
    musicPlayer = MusicPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5),
                child: new Image(
                  image: AssetImage('assets/RadTarLogo.png'),
                  height: 200,
                  width: 200,
                ),
              ),
              Center(
                  child: Column(
                children: <Widget>[
                  /*new RaisedButton(
                    child: new Text("Start",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      callAudio("start");
                      MediaNotification.showNotification(
                          title: 'Radio Tarasca 107.5 FM',
                          author: 'Tarascos de Corazón');
                      setState(() => status = 'play');
                    },
                  ),
                  new RaisedButton(
                      child: new Text("Stop",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        callAudio("stop");
                        MediaNotification.hideNotification();
                        setState(() => status = 'hidden');
                      }),
                  new RaisedButton(
                    child: new Text("Pause",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      callAudio("pause");
                    },
                  ),
                  new RaisedButton(
                    child: new Text("Resume",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      callAudio(
                        "resume",
                      );
                    },
                  ),
                  new RaisedButton(
                    child: new Text("Resume",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      callAudio("resume");
                    },
                  ),*/
                  Padding(
                    padding: EdgeInsets.only(top: 50),
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
                              fit: BoxFit
                                  .cover, // this is the solution for border
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
                              fit: BoxFit
                                  .cover, // this is the solution for border
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
                              fit: BoxFit
                                  .cover, // this is the solution for border
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
                    padding: EdgeInsets.only(top: 80),
                    alignment: Alignment.center,
                    child: Text(
                      "Maravatío, Michoacán \nTarascos de Corazón \n X H S C B J",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 50)),
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink,
                          spreadRadius: 2,
                          blurRadius: 10,
                          // changes position of shadow
                        ),
                      ],
                    ),
                    child: IconButton(
                        icon: Icon(isplaying1
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled),
                        iconSize: 50.0,
                        color: isplaying1 ? Colors.white : Colors.white,
                        onPressed: () {
                          if (isplaying1) {
                            callAudio("stop");
                            MediaNotification.hideNotification();

                            setState(() => status = 'hidden');
                            setState(() {
                              isplaying1 = false;
                            });
                          } else {
                            setState(() {
                              callAudio("stop");
                              isplaying1 = true;
                            });
                            callAudio("start");
                            MediaNotification.showNotification(
                                title: 'Radio Tarasca 102.7 FM',
                                author: 'Tarascos de Corazón');
                            musicPlayer.stop();
                          }
                        }
                        //progress: playAnimation,
                        ),
                  ),
                ],
              )),
            ],
          ),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage("assets/Fondoo.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
