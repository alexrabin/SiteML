//
//  ScanEntryDetailView.swift
//  SiteML
//
//  Created by Alex Rabin on 5/2/20.
//  Copyright © 2020 Alex Rabin. All rights reserved.
//

import SwiftUI
import TextView

struct ScanEntryDetailView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var scanEntry : ScanEntry?
    
    @State var ocrText : String = ""
    @State var imageLabels : String = ""
    @State var imageData : Data = .init(count: 0)
    @State var imageDimensions : String = ""
    @State var uiimage : UIImage?
    
    private let taskDateFormat: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateStyle = .full
           return formatter
       }()
    
    var body: some View {
        ScrollView{
            VStack {
                Group() {
                    if self.uiimage != nil {
                        Image(uiImage: self.uiimage!)
                       .resizable()
                       .scaledToFit()
                       .onAppear(){
                           let widthInPixels = self.uiimage!.size.width * UIScreen.main.scale
                           let heightInPixels = self.uiimage!.size.height * UIScreen.main.scale
                           self.imageDimensions = "\(Int(widthInPixels))x\(Int(heightInPixels))"
                       }
                    }
                }
               
                HStack {
                    Text("Dimensions:").font(.headline).lineLimit(1)
                    Text(self.imageDimensions).font(.headline).lineLimit(1)
                }
                Text("\(scanEntry!.createdAt!, formatter: self.taskDateFormat)").font(.headline)
                Group(){
                    if scanEntry!.imageLabels != nil {
                        
                        Text(self.scanEntry!.imageLabels!).lineLimit(nil)
                    }
                }
                Group(){
                    if scanEntry!.ocrText != nil {
                        
                        AnyView(
                            
                            NavigationLink(destination:TextView.init(text: .constant(scanEntry!.ocrText!), isEditing: .constant(false), textAlignment: TextView.TextAlignment.natural, textColor: colorScheme == .light ? UIColor.black : UIColor.white, backgroundColor: colorScheme == .light ? .white : .black, contentType: nil, autocorrection: .no, autocapitalization: .none, isSecure: false, isEditable: false, isSelectable: true, isScrollingEnabled: true, isUserInteractionEnabled: true) .navigationBarTitle("Text Results"))
                            {
                                HStack(alignment:.center){
                                           VStack(alignment: .leading){
                                            
                                            Text("Text Results").bold().font(.title).multilineTextAlignment(.leading)
                                                .padding(5)
                                               
                                                VStack{
                                                    Text(scanEntry!.ocrText!).lineLimit(10).padding()
                                                }
                                           
                                            
                                           }
                                           .padding()
                                           Spacer()
                                           Image(systemName: "chevron.right").font(.title).padding()

                                                   
                                               }
                            }
                            .padding(.horizontal, 10)
                            .buttonStyle(PlainButtonStyle())
                          
                        )
                    }
                }
            }
        }
        .onAppear(){
            self.imageData = self.scanEntry!.image!
            self.uiimage = UIImage.init(data: self.imageData)!
        }
        .navigationBarTitle("Details")
    }
}

struct ScanEntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ScanEntryDetailView(scanEntry: .constant(nil))
    }
}
