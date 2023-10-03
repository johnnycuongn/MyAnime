//
//  ContentView.swift
//  MyAnime
//
//  Created by Johnny on 29/9/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    init() {
        let repo = DefaultAnimeFetchRepository()
        repo.fetchTop(page: 2, subtype: .bydefault) {  (result) in
            switch result {
            case .success(let animes):
                print("Success")
                print(animes)
                
            case .failure(let error):
                print("Error \(error)")
            }
            
        }
    }

    var body: some View {
       Text("s")
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
