import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:picsum/models/picsum.dart';

class PicsumService {
  // endpoint https://picsum.photos/v2/list?page=1&limit=10

  static Future<List<Picsum>?> getImagePage(
      {int page = 1, int total = 20}) async {
    final url = 'https://picsum.photos/v2/list?page=${page}&limit${total}';
    try {
      final key = '${page}_${total}';

      // check local cache
      final fileInfo = await DefaultCacheManager().getFileFromCache(key);

      if (fileInfo == null) {
        // no cache found load from api
        log('no cache found load from api');
        final file = await DefaultCacheManager().getSingleFile(url, key: key);
        final jsonString = await file.readAsString();
        final picsum = picsumFromJson(jsonString);
        return picsum;
      } else {
        // found cache
        log('found cache load from file');
        final jsonString = await fileInfo.file.readAsString();
        final picsum = picsumFromJson(jsonString);
        return picsum;
      }

      // // get images from picsun
      // final res = await http.get(Uri.parse());
      // if (res.statusCode == 200) {
      //   // return parsed data
      //   final picsum = picsumFromJson(res.body);
      //   //log('${res.body}');
      //   return picsum;
      // } else {
      //   return null;
      // }
    } catch (e) {
      return null;
    }
  }

  static getSmallImage(
      {required String id, required double width, required double height}) {
    // https://picsum.photos/id/237/200/300

    return CachedNetworkImage(
      imageUrl: 'https://picsum.photos/id/$id/${width.ceil()}/${height.ceil()}',
      cacheKey: 'picsum$id',
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.grey,
      ),
      placeholder: (context, url) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  static saveNetworkImage({required String url, required String name}) async {
    Get.snackbar('Info',
        'Downloading… You’ll be notified once the download is complete.');

    final res = await http.get(Uri.parse(url));

    final tempDir = await getTemporaryDirectory();
    final tempName = tempDir.path + name;
    final f = File(tempName);
    f.writeAsBytesSync(res.bodyBytes);

    await ImageGallerySaverPlus.saveImage(
      Uint8List.fromList(res.bodyBytes),
      name: tempName,
    );

    Get.snackbar('Info', 'Your image has been saved to the gallery!');

    // TODO : save image to gallery
    // await GallerySaver.saveImage(f.path).then(
    //   (value) {
    //     log(f.path);
    //     Get.snackbar(
    //       'Saved',
    //       'Save image to gallery',
    //       duration: Duration(
    //         seconds: 1,
    //       ),
    //     );
    //   },
    // );
  }
}
