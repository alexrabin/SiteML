//
//  ImageDetailView.swift
//  SiteML
//
//  Created by Alex Rabin on 5/1/20.
//  Copyright © 2020 Alex Rabin. All rights reserved.
//

import SwiftUI
import ActivityIndicatorView
import TextView

struct ImageDetailView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @Binding var scanEntry : ScanEntry?
    @Binding var image : UIImage?
    @State var imageDimensions : String = ""
    @State var showDataLoadingView : Bool = true
    @State var scanResult : ScanResult = ScanResult()
    
    var body: some View {
        ScrollView{
            VStack{
                Group(){
                    if self.image != nil {
                       Image(uiImage: self.image!)
                       .resizable()
                       .scaledToFit()
                       .onAppear(){
                           let widthInPixels = self.image!.size.width * UIScreen.main.scale
                           let heightInPixels = self.image!.size.height * UIScreen.main.scale
                           self.imageDimensions = "\(Int(widthInPixels))x\(Int(heightInPixels))"
                       }
                   }
                }
                
                HStack {
                    Text("Dimensions:").font(.headline).lineLimit(1)
                    Text(self.imageDimensions).font(.headline).lineLimit(1)
                }
                
                ActivityIndicatorView(isVisible: $showDataLoadingView, type: .equalizer)
                .frame(width: 50.0, height: 50.0)
                
                if self.scanResult.hasLabels{
                    Divider()
                    HStack{
                        VStack(alignment: .leading){
                            Text("Image Categories").bold().padding().font(.title)
                            
                            ForEach(0 ..< self.scanResult.allImageLabels.count){ index in
                                self.buildImageLabels(index:index).padding(.horizontal, 10)
                            }
                            
                            
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    Divider()
                }
                buildTextOCRView()
            }.onAppear(){
                self.image = UIImage.init(data: self.scanEntry!.image!)!
                self.scan(image: self.image!.fixOrientation()!)
            }
        }
        .navigationBarTitle("Image Details")
    }
    
    fileprivate func saveEntries() {
        do {
            try self.managedObjectContext.save()
        }
        catch{
            print(error)
        }
    }
    
    private func buildTextOCRView() -> AnyView {
        if let text = scanResult.textOCR{
            return AnyView(
                
                NavigationLink(destination:TextView.init(text: .constant(text), isEditing: .constant(false), textAlignment: TextView.TextAlignment.natural, textColor: UIColor.black, backgroundColor: .white, contentType: nil, autocorrection: .no, autocapitalization: .none, isSecure: false, isEditable: false, isSelectable: true, isScrollingEnabled: true, isUserInteractionEnabled: true) .navigationBarTitle("Text Results"))
                {
                    HStack(alignment:.center){
                               VStack(alignment: .leading){
                                
                                Text("Text Results").bold().font(.title).multilineTextAlignment(.leading)
                                    .padding(5)
                                   
                                    VStack{
                                        Text(text).lineLimit(10).padding()
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
        return AnyView(EmptyView())
    }
    private func buildImageLabels(index: Int) -> AnyView {
        let label = self.scanResult.allImageLabels[index]
        var confidence = ""
        if let conf = label.confidence, Float(truncating: conf) > 0.8{
            confidence = "Confidience: \(Int(Float(truncating: conf) * 100))%"
        }
        return AnyView(
            HStack(alignment:.center){
                
                Text(label.text).bold()
                Spacer()
                Text(confidence).font(.caption)
                
            }.padding(.horizontal, 10)
        )
    }
    
    private func scan(image: UIImage){
        DispatchQueue.background(delay: 0.0, background: {
            print("Scan started")
            let controller = SiteController.init(image: image)
            controller.scanImage { (result) in
                print(result.toString())
                self.scanResult = result
                if result.hasLabels {
                    var imageLabels = ""
                    for label in result.allImageLabels {
                        if let conf = label.confidence, Float(truncating: conf) > 0.8{
                            imageLabels += "\(label.text): \(Int(Float(truncating: conf) * 100))%\n"

                        }
                    }
                    self.scanEntry!.imageLabels = imageLabels
                    self.scanEntry!.ocrText = result.textOCR
                    self.saveEntries()
                }
                self.showDataLoadingView.toggle()
            }
        }, completion: nil)
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(scanEntry: .constant(nil), image: .constant(nil))
    }
}
