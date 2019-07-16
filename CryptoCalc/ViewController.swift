//
//  ViewController.swift
//  CryptoCalc
//
//  Created by Asher Willner on 7/14/19.
//  Copyright © 2019 Asher Willner. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Accelerate

class ViewController: UIViewController {

    var ticker : String = ""
    var closeArray = [Double]()
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tickerPicker: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getTickerPressed(_ sender: Any) {
        ticker = tickerPicker.text!.uppercased()
        let URL = "https://min-api.cryptocompare.com/data/histoday?fsym=\(ticker)&tsym=USD&allData=true"
        getBitcoinData(url: URL)
    }
    
    func getBitcoinData(url: String) {

        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {

                print("Sucess! Got the bitcoin data")
                let bitcoinJSON : JSON = JSON(response.result.value!)
                let data = bitcoinJSON["Data"]
                var count = data.count - 1
                while count >= 0 {
                    let closeValue = data[count]["close"].double!
                    self.closeArray.append(closeValue)
                    count -= 1
                }
               var returns = [Double]()
                for i in 0...(self.closeArray.count-2) {
                    let placeholder = log(self.closeArray[i+1]/self.closeArray[i])
                    returns.append(placeholder)
                }
                
//                print(returns)
                
                var mn = 0.0
                var sddev = 0.0
                vDSP_normalizeD(returns, 1, nil, 1, &mn, &sddev, vDSP_Length(returns.count))
                sddev *= sqrt(Double(returns.count)/Double(returns.count - 1))
                
                print(mn, round(sddev*1000)/1000)
                
                self.updateBitcoinData(json: bitcoinJSON)

            } else {
                print("Error: \(String(describing: response.result.error))")
                self.priceLabel.text = "Connection Issues"
            }
        }

    }

    func updateBitcoinData(json : JSON) {

        if var priceResult = json["Data"][0]["close"].double {
            priceResult = round(priceResult*100) / 100
           
            priceLabel.text = "$" + String(priceResult)
        } else {
            priceLabel.text = "Connection Issues"
        }


    }

}

