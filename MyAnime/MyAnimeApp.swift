//
//  MyAnimeApp.swift
//  MyAnime
//
//  Created by Johnny on 29/9/2023.
//

import SwiftUI

@main
struct MyAnimeApp: App {
    let persistenceController = CoreDataStorage.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct Previews_MyAnimeApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
