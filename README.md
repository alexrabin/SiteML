# SiteML
This is a project I worked on during quarantine. SiteML uses SwiftUI, CoreData, and Firebase.

## SwiftUI
Using SwiftUI was fairly easy in my experience. My favorite source is https://fuckingswiftui.com
Here is my ScanEntryItemView

`struct ScanEntryItemView: View {
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
}`
And this is how I was able to use the ScanEntryItemView in a List

`List{

   ForEach(self.entries){ entry in
   
       NavigationLink(destination: ScanEntryDetailView(scanEntry: .constant(entry))){
       
           ScanEntryItemView(image: entry.image!, createdAt: entry.createdAt!, foundText: entry.ocrText != nil, hasImageCategories: entry.imageLabels != nil)
           
       }
       
   }
   
}

`

### Other SwiftUI Sources
https://fuckingswiftui.com
https://medium.com/flawless-app-stories/mvvm-in-swiftui-8a2e9cc2964a
https://medium.com/better-programming/8-amazing-swiftui-libraries-to-use-in-your-next-project-52efaf211143
https://www.appcoda.com/swiftui-buttons/
https://www.youtube.com/watch?v=XxjbecMKP54&feature=youtu.be
https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-dark-mode