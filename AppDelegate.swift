import UIKit
import ParseCore


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let configuration = ParseClientConfiguration { (ParseMutableClientConfiguration) in
            ParseMutableClientConfiguration.applicationId = "C7cFCJwilyX9JbBM6jlLGBy6UQAUzXIl88LDWmJZ"
            ParseMutableClientConfiguration.clientKey = "kH1CtrsNuxX9D97eCa2Mhu2nNpDyxcYRJW8mvYSS"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
        }
        Parse.initialize(with: configuration)
        return true
    }

   

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
       let a = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        a.delegateClass = SceneDelegate.self
        return a
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         
    }


}

