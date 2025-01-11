import '../const/data.dart';

class DataUtils {
  static pathToUrl(String path) => 'http://$ip$path';

  static List<String> listPathsToUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList() as List<String>;
  }
}
