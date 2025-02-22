import 'dart:convert';

import '../const/data.dart';

class DataUtils {
  static DateTime stringToDateTime(String date) =>
      DateTime.parse(date).toLocal();

  static String dateTimeToString(DateTime date) =>
      date.toUtc().toIso8601String();

  static pathToUrl(String path) => 'http://$ip$path';

  static List<dynamic> listPathsToUrls(List<dynamic> paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String text) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(text);
  }
}
