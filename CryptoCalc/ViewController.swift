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

class ViewController: UIViewController {

    var ticker : String = ""
    
    
    
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tickerPicker: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getTickerPressed(_ sender: Any) {
        ticker = tickerPicker.text!.uppercased()
        let URL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/\(ticker)USD"
        print(URL)
        getBitcoinData(url: URL)
    }
    
    func getBitcoinData(url: String) {

        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {

                print("Sucess! Got the bitcoin data")
                let bitcoinJSON : JSON = JSON(response.result.value!)

                self.updateBitcoinData(json: bitcoinJSON)

            } else {
                print("Error: \(String(describing: response.result.error))")
                self.priceLabel.text = "Connection Issues"
            }
        }

    }

    func updateBitcoinData(json : JSON) {

        if var priceResult = json["last"].double {
            priceResult = round(priceResult*100) / 100
            priceLabel.text = "$" + String(priceResult)
        } else {
            priceLabel.text = "Connection Issues"
        }


    }

}

