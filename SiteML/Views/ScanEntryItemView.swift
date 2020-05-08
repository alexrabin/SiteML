//
//  ScanEntryItemView.swift
//  SiteML
//
//  Created by Alex Rabin on 5/2/20.
//  Copyright © 2020 Alex Rabin. All rights reserved.
//

import SwiftUI

struct ScanEntryItemView: View {
    var image : Data = .init(count: 0)
    var createdAt : Date = Date()
    var foundText : Bool = false
    var hasImageCategories : Bool = false
    private let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var body: some View {
        HStack() {
            Image(uiImage: UIImage.init(data: self.image)!)
                .resizable()
                .frame(width: 100, height: 100)
                .scaledToFill()
                
            Spacer()
            VStack(alignment: .leading){
                Text("Found Text: \(self.foundText ? "True" : "False")").font(.headline)
                Text("Found Categories: \(self.hasImageCategories ? "True" : "False")").font(.headline)

                Text("\(createdAt, formatter: self.taskDateFormat)").font(.caption)
                
            }
            
        }.padding()
    }
}

struct ScanEntryItemView_Previews: PreviewProvider {
    static var previews: some View {
        ScanEntryItemView()
    }
}
