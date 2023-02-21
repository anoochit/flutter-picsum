import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:picsum/services/picsum.dart';

import '../models/picsum.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Picsum>? data = [];
  int currentPage = 1;

  @override
  void initState() {
    super.initState();

    PicsumService.getImagePage(page: currentPage, total: 20).then((value) {
      setState(() {
        data!.addAll(value!);
        currentPage++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final scWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Picsum"),
      ),
      body: (data!.length != 0)
          ? LazyLoadScrollView(
              onEndOfPage: () => loadMore(),
              scrollOffset: (MediaQuery.of(context).size.height * 0.6).toInt(),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      ((context.isTablet) || (context.isLandscape)) ? 4 : 2,
                ),
                itemCount: data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed('/show', arguments: data![index]);
                      },
                      child: GridTile(
                        child: PicsumService.getSmallImage(
                          id: data![index].id,
                          height: scWidth.toInt(),
                          width: scWidth.toInt(),
                        ),
                        footer: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${data![index].author}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Loading..."),
                  ),
                ],
              ),
            ),
    );
  }

  loadMore() async {
    log('current page = ${currentPage}');
    final result =
        await PicsumService.getImagePage(page: currentPage, total: 20);
    setState(() {
      data!.addAll(result!);
      currentPage++;
    });
  }
}
