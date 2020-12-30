import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

        func endBackgroundTask() {
            print("Background task ended.")
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = UIBackgroundTaskInvalid
        }

    override func applicationWillEnterForeground(_ application: UIApplication) {
        endBackgroundTask()
    }
        override func applicationDidEnterBackground(_ application: UIApplication) {
            print("did enter background")
            backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
                self?.endBackgroundTask()
    print("started.")
                print("Background time remaining = " +
                    "\(UIApplication.shared.backgroundTimeRemaining) seconds")
            }
            assert(backgroundTask != UIBackgroundTaskInvalid)
        }

    override func applicationWillTerminate(_ application: UIApplication) {
        print("will terminate")
    }
}

