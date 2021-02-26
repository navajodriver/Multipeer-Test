//
//  Multipeer_TestApp.swift
//  Multipeer Test
//
//  Created by Aaron on 2021-02-25.
//

import SwiftUI

@main
struct Multipeer_TestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
