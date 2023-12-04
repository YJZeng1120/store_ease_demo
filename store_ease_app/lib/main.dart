import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'functions/image_utility.dart';
import 'models/core/cache_helper.dart';
import 'models/core/fcm_helper.dart';
import 'views/app_widget.dart';
import 'views/common_widgets/loading_overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  LoadingOverlay.init();
  await CacheHelper.init();
  await ImageHelper.init();
  await NotificationHelper.init();

  // 設定畫面方向
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const AppWidget(),
  );
}
