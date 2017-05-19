import Foundation

class RestClient {

    static func getRates() {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "http://api.fixer.io/latest?base=GBP")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        //Implement your logic
                        print(json)
                        let rates: [String: Any] = json["rates"] as! [String : Any]
                        Data.setRates(rates: rates)

                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
}
