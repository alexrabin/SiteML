//
//  SiteController.swift
//  SiteML
//
//  Created by Alex Rabin on 4/30/20.
//  Copyright © 2020 Alex Rabin. All rights reserved.
//

import Foundation
import Firebase


class SiteController {
    private var image : UIImage!
    private lazy var vision = Vision.vision()
    
    public init(image: UIImage){
        self.image = image.fixOrientation()
    }
    
    
    public func scanImage(completion: @escaping (ScanResult)-> Void){
        
        var scanResult = ScanResult()


        DispatchQueue.background(delay: 0.5, background: {
            let group = DispatchGroup()

              group.enter()
            
            self.scanForText { (result) in
             if let res = result{

                 scanResult.addTextOCR(text: res)

             }

              group.leave()

            }

              group.enter()
        

              self.getImageLabel { (label) in
                  if let imageLabel = label {
                      scanResult.setImageLabels(labels: imageLabel)
                  }

                   group.leave()
              }
              group.wait()
        }) {
            completion(scanResult)
        }

    }
    // MARK: - Private

    
    /// - Returns: Firebase Vision Image
    private func visionImage() -> VisionImage{
        let image = VisionImage(image: self.image)
        let metadata = VisionImageMetadata()
        let visionOrientation = UIUtilities.visionImageOrientation(from: self.image.imageOrientation)
        metadata.orientation = visionOrientation
        image.metadata = metadata
        return image
    }
    
    /// Call before scanning
    public var getScanProgress : ((ScanProgress) -> Void)?
    
    /// Scans the classes' vision image for any text in the image
    /// - Parameter completion: Returns a string containing the text in the image
    private func scanForText(completion: @escaping (String?) -> Void){
            print("Scanning for Text")
            let textRecognizer = vision.onDeviceTextRecognizer()

            let image = self.visionImage()

            textRecognizer.process(image) { result, error in
                guard error == nil, let text = result else {
                  let errorString = error?.localizedDescription ?? "No Results"
                  print("Text recognizer failed with error: \(errorString)")
                    completion(nil)
                  return
                }

                let resultText = text.text
                completion(resultText)

            }

        }
    
    private func getImageLabel(completion: @escaping ([VisionImageLabel]?) -> Void){
        print("Getting image label")
        let labeler = Vision.vision().onDeviceImageLabeler()
        let image = VisionImage(image: self.image)
        labeler.process(image) { labels, error in

            guard error == nil, let labels = labels  else {
                let errorString = error?.localizedDescription ?? "No Image Labels Found"
               print("Image Labeler failed with error: \(errorString)")
               completion(nil)
               return
            }


            // Task succeeded.
            print("Labels Found: \(labels.count)")
            for label in labels {
                let labelText = label.text
                let entityId = label.entityID
                let confidence = label.confidence
                print("Label: \(labelText) ID: \(String(describing: entityId)) Confidence: \(String(describing: confidence))\n")
            }
            completion(labels)
        }
    }
    
}


public class ScanProgress: ObservableObject {
    @Published var textProgress : ScanProgressType!
    @Published var imageCategoriesProgress : ScanProgressType!
    func setTextProgress(progress: ScanProgressType){
        DispatchQueue.main.async{
            self.textProgress = progress

        }
    }
    func setImageCategoriesProgress(progress: ScanProgressType){
        DispatchQueue.main.async{
            self.imageCategoriesProgress = progress

        }
    }
   
}
public enum ScanProgressType{
    case waiting, searching, success, notFound
}
