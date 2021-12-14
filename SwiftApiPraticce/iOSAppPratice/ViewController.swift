import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let address = "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14&limit=20&offset=1"
        if let url = URL(string: address) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse,let data = data {
                    print("Status code: \(response.statusCode)")
                    let decoder = JSONDecoder()
                    if let apiResponse = try? decoder.decode(ApiResult.self, from: data) {
                        DispatchQueue.main.async {
                            self.name.text = apiResponse.result.results[0].name
                        }
                        let image =  self.comvertToPic(picUrl: apiResponse.result.results[0].picUrl)
                        DispatchQueue.main.async {
                            self.pic.image = image
                        }
                    }
                }
            }.resume()
        } else {
            print("Invalid URL.")
        }
    }
    
    func comvertToPic(picUrl : String) -> UIImage {
        let newUrl = picUrl.replacingOccurrences(of: "http", with: "https")
        if let url = URL(string: newUrl) {
            if let data = try? Data(contentsOf: url) {
                return UIImage(data: data) ?? UIImage()
            }
        }
        return UIImage()
    }
}

struct ApiResult : Codable {
    var result : PlantsDataStore
}

struct PlantsDataStore: Codable {
    var results: [Plant]
}

struct Plant: Codable {
    var name: String
    var picUrl: String
    enum CodingKeys: String, CodingKey {
        case name = "F_Name_Ch"
        case picUrl = "F_Pic01_URL"
    }
}
