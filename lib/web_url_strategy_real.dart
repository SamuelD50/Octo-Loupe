import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void configureWebUrlStrategy() {
  setUrlStrategy(PathUrlStrategy());
}

// Configuration on web platform only