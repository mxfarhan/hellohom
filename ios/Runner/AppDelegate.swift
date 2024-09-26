import UIKit
import Flutter
import awesome_notifications
import FirebaseCore


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)

      // This function registers the desired plugins to be used within a notification background action
      SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in          
          SwiftAwesomeNotificationsPlugin.register(
            with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)          
            }

      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // remove counter badge when opened the app
    override func applicationDidBecomeActive(_ application: UIApplication) {
      application.applicationIconBadgeNumber = 0;
    }
}
