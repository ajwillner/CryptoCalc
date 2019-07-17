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
import SVProgressHUD

class ViewController: UIViewController {

    var ticker : String = ""
    var stdDict = [String:Double]()
    var riskDict = [String:String]()
//    var currencyObjects = [String:Currency]()
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tickerPicker: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getTickerPressed(_ sender: Any) {
        SVProgressHUD.show()
        ticker = tickerPicker.text!.uppercased()
        let URL = "https://min-api.cryptocompare.com/data/histoday?fsym=\(ticker)&tsym=USD&allData=true"
        getBitcoinData(url: URL)
        view.endEditing(true)
    }
    
    func getBitcoinData(url: String) {

        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                var closeArray = [Double]()
                print("Sucess! Got the bitcoin data")
                let bitcoinJSON : JSON = JSON(response.result.value!)
                let data = bitcoinJSON["Data"]
                var count = data.count - 1
                while count >= 0 {
                    let closeValue = data[count]["close"].double!
                    closeArray.append(closeValue)
                    count -= 1
                }
               var returns = [Double]()
                for i in 0...(closeArray.count-2) {
                    let placeholder = log(closeArray[i+1]/closeArray[i])
                    returns.append(placeholder)
                }
                
                var mn = 0.0
                var sddev = 0.0
                vDSP_normalizeD(returns, 1, nil, 1, &mn, &sddev, vDSP_Length(returns.count))
                sddev *= sqrt(Double(returns.count)/Double(returns.count - 1))
                
                let std = round(sddev*1000)/1000
                
                print(mn, std)
                SVProgressHUD.dismiss()
                self.priceLabel.text = String(round(sddev*1000)/1000)
                
                self.stdDict[self.ticker] = std
                
//                print(self.stdDict)
                let dictValInc = self.stdDict.sorted(by: { $0.value < $1.value })
//                print(dictValInc)
                
//                let currencyObj = Currency()
//
                if std < 0.1 {
                    self.riskDict[self.ticker] = "Fair Risk"
                } else if std < 0.2 {
                    self.riskDict[self.ticker] = "High Risk"
                } else {
                    self.riskDict[self.ticker] = "Avoid"
                }
                print(self.riskDict)
                
//                currencyObj.symbol = self.ticker
//                currencyObj.std = std
//                currencyObj.age = data.count
//
//                self.currencyObjects[self.ticker] = currencyObj
//
//                print(self.currencyObjects[self.ticker]?.risk)
                
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.priceLabel.text = "Connection Issues"
            }
        }

    }

}

