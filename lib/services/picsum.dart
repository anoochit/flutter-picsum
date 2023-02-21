import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:picsum/models/picsum.dart';

class PicsumService {
  // endpoint https://picsum.photos/v2/list?page=1&limit=10

  static Future<List<Picsum>?> getImagePage(
      {int page = 1, int total = 20}) async {
    try {
      // get images from picsun
      final res = await http.get(Uri.parse(
          'https://picsum.photos/v2/list?page=${page}&limit${total}'));
      if (res.statusCode == 200) {
        // return parsed data
        final picsum = picsumFromJson(res.body);
        //log('${res.body}');
        return picsum;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static getSmallImage(
      {required String id, required int width, required int height}) {
    // https://picsum.photos/id/237/200/300

    return CachedNetworkImage(
      imageUrl: 'https://picsum.photos/id/$id/$width/$height',
      placeholder: (context, url) {
        return Container(
          width: width.toDouble(),
          height: height.toDouble(),
          color: Colors.grey,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  static saveNetworkImage({required String url, required String name}) async {
    final res = await http.get(Uri.parse(url));

    final tempDir = await getTemporaryDirectory();
    final tempName = tempDir.path + name;
    final f = File(tempName);
    f.writeAsBytesSync(res.bodyBytes);

    await GallerySaver.saveImage(f.path).then(
      (value) {
        log(f.path);
        Get.snackbar(
          'Saved',
          'Save image to gallery',
          duration: Duration(
            seconds: 1,
          ),
        );
      },
    );
  }
}
