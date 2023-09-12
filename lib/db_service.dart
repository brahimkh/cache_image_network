import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
//Author: Brahim Man
//Date: 09/09/2021
//From: Phnom Penh, Cambodia
//Phone: 096 76 49 556 (+855)
//Description: This is the database service to store the image in the cache
class DatabaseService {
  // create ibnstance of database
  DatabaseService._();

  final String imageKey = "cache_image_data";
  static final _instance = DatabaseService._();

  factory DatabaseService() => _instance;
  late SharedPreferences _sharedPreferences;

  static Future<void> initialized() async {
    _instance._sharedPreferences = await SharedPreferences.getInstance();
  }

  /// This is the method to set the image in the cache
  static Future<bool> setImage(String key, Uint8List file) async {
    final md5 = _instance._generateMd5(key);
    _instance._generateMd5(key);
    final encodedFile = base64UrlEncode(file);
    return await _instance._sharedPreferences.setString(md5, encodedFile);
  }

  /// This is the method to get the image from the cache
  static Uint8List getImage(String key) {
    final md5 = _instance._generateMd5(key);
    final encodedFile = _instance._sharedPreferences.getString(md5);
    return base64Url.decode(encodedFile!);
  }

  /// This is the method to check if the image is in the cache
  static bool checkFile(String key) {
    final md5 = _instance._generateMd5(key);
    return _instance._sharedPreferences.containsKey(md5);
  }

  /// This is the method to delete the image from the cache
  String _generateMd5(String url) {
    var _gen = md5.convert(utf8.encode(url));
    final keyValue = "$imageKey/${_gen.toString()}";
    return keyValue;
  }

  /// This is the method to delete the image from the cache
  static Future<bool> deleteImage(String key) async {
    final md5 = _instance._generateMd5(key);
    return await _instance._sharedPreferences.remove(md5);
  }

  /// This is the method to delete all the images from the cache
  static Future<void> deleteCacheImage() async {
    final keys = _instance._sharedPreferences.getKeys();
    for (final key in keys) {
      if (key.contains(_instance.imageKey)) {
        await _instance._sharedPreferences.remove(key);
      }
    }
  }

  /// This is the method to get all the images from the cache
  static Future<List<Uint8List>> getAllImage() async {
    final keys = _instance._sharedPreferences.getKeys();
    final List<Uint8List> images = [];
    for (final key in keys) {
      if (key.contains(_instance.imageKey)) {
        final encodedFile = _instance._sharedPreferences.getString(key);
        images.add(base64Url.decode(encodedFile!));
      }
    }
    return images;
  }

  /// this is the method to get the size of the cache
  static int getCacheSize() {
    final keys = _instance._sharedPreferences.getKeys();
    int size = 0;
    for (final key in keys) {
      if (key.contains(_instance.imageKey)) {
        final encodedFile = _instance._sharedPreferences.getString(key);
        size += encodedFile!.length;
      }
    }
    return size;
  }
}
