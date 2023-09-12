import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'db_service.dart';

class ImageCacheNetwork extends StatefulWidget {
  final String imageUrl;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const ImageCacheNetwork(
      {Key? key, required this.imageUrl, this.errorWidget, this.loadingWidget})
      : super(key: key);

  @override
  State<ImageCacheNetwork> createState() => _ImageCacheNetworkState();
}

class _ImageCacheNetworkState extends State<ImageCacheNetwork> {
  late Widget body;

  @override
  void initState() {
    super.initState();
    body = imageRender();
  }

  @override
  Widget build(BuildContext context) {
    return body;
  }

  Widget imageRender() {
    return FutureBuilder<Uint8List>(
      future: initialized(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
          );
        } else if (snapshot.hasError) {
          return widget.errorWidget?? const Center(
            child: Text("Error"),
          );
        } else {
          return widget.loadingWidget?? const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<Uint8List> initialized() async {
    try {
      final isExit = DatabaseService.checkFile(widget.imageUrl);
      if (isExit) {
        return DatabaseService.getImage(widget.imageUrl);
      } else {
        return await loadImage();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Uint8List> loadImage() async {
    try {
      final response = await Dio().get(widget.imageUrl,
          options: Options(
            responseType: ResponseType.bytes,
          ));
      final bytes = response.data;
      final Uint8List uint8list = Uint8List.fromList(bytes);
      final compressedData = await compressUint8List(uint8list);
      await DatabaseService.setImage(widget.imageUrl, compressedData);
      return compressedData;
    } on DioException catch (e) {
      final message = e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Uint8List> compressUint8List(Uint8List data) async {
    try {
      final compressedData =
          await FlutterImageCompress.compressWithList(data, quality: 50);
      return compressedData;
    } catch (e) {
      throw Exception(e);
    }
  }
}
