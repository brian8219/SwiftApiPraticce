import UIKit

struct ApiResult : Codable {
    var result : PlantsDataStore
}

struct PlantsDataStore: Codable {
    var results: [Plant]
}

struct Plant: Codable {
    var name: String
    var location: String
    var feature: String
    var picUrl: String
    enum CodingKeys: String, CodingKey {
        case name = "F_Name_Ch"
        case location = "F_Location"
        case feature = "F_Feature"
        case picUrl = "F_Pic01_URL"
    }
}
