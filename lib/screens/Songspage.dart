import 'package:flutter/material.dart';
import 'package:music_player/music_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'package:url_audio_stream/url_audio_stream.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class Songspage extends StatefulWidget {
  String song_name, artist_name, song_url, image_url;

  Songspage({this.song_name, this.artist_name, this.song_url, this.image_url});
  @override
  _SongspageState createState() => _SongspageState();
}

class _SongspageState extends State<Songspage> {
  MusicPlayer musicPlayer;
  bool isplaying1 = false;

  String status = 'hidden';

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

  // Initializing the Music Player and adding a single [PlaylistItem]
  Future<void> initPlatformState() async {
    musicPlayer = MusicPlayer();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new SvgPicture.asset(
            "assets/back.svg",
            color: Colors.white,
            width: 20,
            height: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(12, 12, 12, 1),
        //title: Text("Music Player App"),
        elevation: 0,
      ),
      backgroundColor: Color.fromRGBO(12, 12, 12, 1),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Text(
              widget.song_name,
              style: TextStyle(fontSize: 25.0, color: Colors.white),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              widget.artist_name,
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            Container(
              padding: EdgeInsets.all(20),
              width: 300,
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                        decoration: new BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.purple, Colors.blue]),
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                  widget.image_url,
                                )))),
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Color(0xff1C1C25),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  colors: [
                    Color(0xff484750),
                    Color(0xff1E1C24),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.2,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: IconButton(
                  icon:
                      Icon(isplaying1 ? Icons.stop : Icons.play_circle_filled),
                  iconSize: 40.0,
                  color: isplaying1 ? Colors.white : Colors.white,
                  onPressed: () {
                    if (isplaying1) {
                      musicPlayer.pause();

                      setState(() {
                        isplaying1 = false;
                      });
                    } else {
                      setState(() {
                        isplaying1 = true;
                        callAudio("stop");
                        MediaNotification.hideNotification();

                        setState(() => status = 'hidden');
                      });
                      musicPlayer.play(MusicItem(
                        trackName: widget.song_name,
                        albumName: '',
                        artistName: widget.artist_name,
                        url: widget.song_url,
                        coverUrl: widget.image_url,
                        duration: Duration(seconds: 255),
                      ));
                    }
                  }),
            ),
            SizedBox(
              width: 10.0,
            ),
            SizedBox(
              width: 100.0,
            ),
          ],
        )),
      ),
    );
  }
}
