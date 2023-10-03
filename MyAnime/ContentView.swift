//
//  ContentView.swift
//  MyAnime
//
//  Created by Johnny on 29/9/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
       Text("s")
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
