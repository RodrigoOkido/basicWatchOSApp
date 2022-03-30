//
//  basicWatchOSAppApp.swift
//  basicWatchOSApp WatchKit Extension
//
//  Created by Rodrigo Yukio Okido on 30/03/22.
//

import SwiftUI

@main
struct basicWatchOSAppApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
