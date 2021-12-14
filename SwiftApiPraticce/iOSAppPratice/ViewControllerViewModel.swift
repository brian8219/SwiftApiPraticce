import Foundation

class ViewControllerViewModel {
    var dataAmount = 0
    var listCellViewModels : [CustomTableViewCellViewModel] = []
    var plants : [Plant] = []
    var onRequestEnd: (() -> Void)?
    
    func getApiData(lastIndex: Int) {
        if lastIndex + 1 >= dataAmount {
            dataAmount += 20
            let address = "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14&limit=20&offset=\(lastIndex + 1)"
            if let url = URL(string: address) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    } else if let response = response as? HTTPURLResponse,let data = data {
                        print("Status code: \(response.statusCode)")
                        let decoder = JSONDecoder()
                        if let apiResponse = try? decoder.decode(ApiResult.self, from: data) {
                            self.plants.append(contentsOf: apiResponse.result.results)
                            self.convertApiDataToViewModel(plants: self.plants)
                        }
                    }
                }.resume()
            } else {
                print("Invalid URL.")
            }
        }
    }
    
    private func convertApiDataToViewModel(plants: [Plant]) {
        for plant in plants {
            let listCellViewModel = CustomTableViewCellViewModel.init(name: plant.name, location: plant.location, feature: plant.feature, picUrl: plant.picUrl)
            listCellViewModels.append(listCellViewModel)
        }
        self.plants = []
        onRequestEnd?()
    }
    
}

