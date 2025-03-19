import Flutter
import UIKit
<<<<<<< HEAD
=======
import Firebase

import 'flutter_local_notifications'
>>>>>>> bce10623d5c3192bb11c87b1aa2eca55e8891d1c

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
<<<<<<< HEAD
    GeneratedPluginRegistrant.register(with: self)
=======
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, +) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    FirebaseApp.configure()

    GeneratedPluginRegistrant.register(with: self)

>>>>>>> bce10623d5c3192bb11c87b1aa2eca55e8891d1c
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
