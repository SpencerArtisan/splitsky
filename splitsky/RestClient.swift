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
        let url = URL(string:
            "https://api.exchangerate.host/convert?from=\(from)&to=\(to)")!

        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
//                    let data2 = fake.data(using: .utf8)
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        
                        print("Result of request to url " + url.absoluteString + ":")
                        print(json)
                        
                        if let rate = json["result"] {
                            if let rate: NSNumber = rate as? NSNumber {
                                resultHandler(rate.floatValue)
                            } else {
                                print("Failed to find a rate from \(from) to \(to)")
                                resultHandler(1.0)
                            }
                        } else {
                            print("Could not find rates element in json response")
                            resultHandler(1.0)
                        }
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
}
