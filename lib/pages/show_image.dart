
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picsum/models/picsum.dart';
import 'package:picsum/services/picsum.dart';

class ShowImage extends StatefulWidget {
  const ShowImage({super.key});

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  final data = Get.arguments as Picsum;

  @override
  Widget build(BuildContext context) {
    final scWidth = context.width.toInt();
    final scHeight = context.height.toInt();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: PicsumService.getSmallImage(
            id: data.id, width: scHeight, height: scHeight),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.download),
        onPressed: () {
          // save to gallery
          // log(data.downloadUrl);
          PicsumService.saveNetworkImage(
              name: 'picsum_' + data.id + ".png", url: data.downloadUrl);
        },
        label: Text("Save to Gallery"),
      ),
    );
  }
}
