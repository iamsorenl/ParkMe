import UIKit
import Flutter
import GoogleMaps
import Foundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // TODO: Find way to not hard code it
    GMSServices.provideAPIKey("AIzaSyBIqeq-fErtxiWLSKdhscC6fIPzADTg2NU")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
