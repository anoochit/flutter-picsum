import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// Class photo
class Photo {
  String id;
  String author;
  int width;
  int height;
  String url;
  String downloadUrl;

  Photo(
      {this.id,
      this.author,
      this.width,
      this.height,
      this.url,
      this.downloadUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String,
      author: json['author'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String,
      downloadUrl: json['download_url'] as String,
    );
  }
}

// Main App
List<Photo> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('https://picsum.photos/v2/list?page=1&limit=10');
  log(response.statusCode.toString());
  log(response.body);
  return compute(parsePhotos, response.body);
}

void main() => runApp(Picsum());

class Picsum extends StatefulWidget {
  Picsum({Key key}) : super(key: key);

  @override
  _PicsumState createState() => _PicsumState();
}

class _PicsumState extends State<Picsum> {
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Picsum"),
          elevation: 0.0,
        ),
        body: Container(
          child: FutureBuilder<List<Photo>>(
            future: fetchPhotos(http.Client()),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? PhotosList(photos: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Stack(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl:
                      "https://picsum.photos/id/" + photos[index].id + "/500",
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      photos[index].author,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowImage(
                      title: photos[index].author, id: photos[index].id)),
            );
          },
        );
        /*
      Image.network(
          photos[index].downloadUrl,
          fit: BoxFit.cover,
        );
        */
      },
    );
  }
}

class ShowImage extends StatefulWidget {
  final String title;
  final String id;
  ShowImage({Key key, this.title, this.id}) : super(key: key);

  @override
  _ShowImageState createState() => _ShowImageState(this.title, this.id);
}

class _ShowImageState extends State<ShowImage> {
  String title;
  String id;
  _ShowImageState(this.title, this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        elevation: 0.0,
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: "https://picsum.photos/id/" + id + "/500",
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ],
      )),
    );
  }
}
