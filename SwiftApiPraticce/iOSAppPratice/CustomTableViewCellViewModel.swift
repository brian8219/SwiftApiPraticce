import UIKit
class CustomTableViewCellViewModel {
    var name: String = ""
    var location: String = ""
    var feature: String = ""
    var pic = UIImage()
    init(name:String,location: String,feature: String,picUrl: String ) {
        self.name = name
        self.location = location
        self.feature = feature
        let newUrl = picUrl.replacingOccurrences(of: "http", with: "https")
        if let url = URL(string: newUrl) {
            if let data = try? Data(contentsOf: url) {
                self.pic =  UIImage(data: data) ?? UIImage()
            }
        }
    }
}
