import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';

// Http request and parse to list
Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client.get('https://picsum.photos/v2/list?limit=999');
  return compute(parsePhotos, response.body);
}

List<Photo> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

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
        downloadUrl: json['download_url'] as String);
  }
}

// Main App

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'picsum',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'picsum'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
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
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        //return Image.network("https://picsum.photos/id/" + photos[index].id + "/180");
        return FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: "https://picsum.photos/id/" + photos[index].id + "/500");
      },
    );
  }
}
