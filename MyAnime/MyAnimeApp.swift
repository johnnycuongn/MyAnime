//
//  MyAnimeApp.swift
//  MyAnime
//
//  Created by Johnny on 29/9/2023.
//

import SwiftUI

@main
struct MyAnimeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
