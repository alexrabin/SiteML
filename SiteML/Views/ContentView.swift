//
//  ContentView.swift
//  SiteML
//
//  Created by Alex Rabin on 4/30/20.
//  Copyright © 2020 Alex Rabin. All rights reserved.
//

import SwiftUI
import CoreData
struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest : ScanEntry.getAllEntries()) var entries:FetchedResults<ScanEntry>
    
    @State var image: UIImage? = nil
    @State var showImagePicker : Bool = false
    @State var showImageDetailView = false
    @State var newEntry : ScanEntry = ScanEntry()
    var body: some View {
        NavigationView{
            ZStack{
                Group(){
                    if self.entries.count == 0 {
                        VStack {
                            Image(systemName: "doc.text.viewfinder")
                            .resizable()
                            .scaledToFit()
                            .imageScale(.large)
                            .frame(width: 100, height: 100)
                            Text("No Scans Yet").font(.title)
                            Text("Press the '+' button to scan a photo")
                        }
                    }
                    else {
                        List{
                           ForEach(self.entries){ entry in
                               NavigationLink(destination: ScanEntryDetailView(scanEntry: .constant(entry))){
                                   ScanEntryItemView(image: entry.image!, createdAt: entry.createdAt!, foundText: entry.ocrText != nil, hasImageCategories: entry.imageLabels != nil)
                               }
                           }.onDelete{ indexSet in
                               let deleteItem = self.entries[indexSet.first!]
                               self.managedObjectContext.delete(deleteItem)

                               self.saveEntries()
                           }
                       }
                    }
                }
               
                
                VStack {
                    NavigationLink(destination: ImageDetailView( scanEntry: .constant(newEntry), image: .constant(self.image)), isActive: $showImageDetailView){
                        EmptyView()
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            //Open Photo Library
                            self.showImagePicker.toggle()
                        }, label: {
                            Image(systemName: "plus")
                            .imageScale(.large)
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.white)
                        })
                        .background(Color.blue)
                        .clipShape(
                            Circle()
                        )
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 3,
                                x: 3,
                                y: 3)
                            .sheet(isPresented: $showImagePicker, onDismiss: {
                                    if (self.image != nil){
                                        self.newEntry = ScanEntry(context: self.managedObjectContext)
                                        self.newEntry.image = self.image!.pngData()
                                        self.newEntry.createdAt = Date()
                                        self.saveEntries()
                                        self.showImageDetailView.toggle()
                                    }
                                }){
                                    ImagePicker(image: self.$image)
                            }
                        
                    }
                    .padding()
                }

            }
            
        .navigationBarTitle("SiteML")
        .navigationBarItems(trailing: EditButton())
        }
    }
    
    fileprivate func saveEntries() {
        do {
            try self.managedObjectContext.save()
        }
        catch{
            print(error)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
