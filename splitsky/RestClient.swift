import Foundation

class RestClient {

    static func getRates(onCompletion: @escaping () -> ()) {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let from = Data.homeCurrency()!.tla()
        var rates: [String: Any] = [:]

        Data.currencies().forEach {
            let to = $0.tla()
            getRate(session: session, from: from, to: to, resultHandler: { (rate) in
                print("Rate from \(from) to \(to) is \(rate)")
                rates[to] = rate
                
                if rates.count == Data.currencies().count {
                    print("ALL CURRENCY RATES RETRIEVED")
        
                    Preferences.setRates(rates)
                    Data.setRates(rates: rates)
                    onCompletion()
                }
            })
        }
    }
    
    static fileprivate func getRate(session: URLSession, from: String, to: String, resultHandler: @escaping (Float) -> ()) {
        let url = URL(string: "https://www.amdoren.com/api/currency.php?api_key=QACQuYvgmRf7iH67sha4bPT9T79XwP&from=\(from)&to=\(to)")!
        
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
                        let rate: Float = (json["amount"] as! NSNumber).floatValue
                        resultHandler(rate)
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()

    }
}
