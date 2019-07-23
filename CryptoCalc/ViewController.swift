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
import SigmaSwiftStatistics

class ViewController: UIViewController {

    var currencyObjects = [Currency]()
    var counter = 0
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tickerPicker: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadCurrencies()
    }

    @IBAction func getTickerPressed(_ sender: Any) {

        priceLabel.text = currencyObjects[19].risk
        view.endEditing(true)
    }
    
    func getBitcoinData(ticker: String, placeholder: Int) {
        let url = "https://min-api.cryptocompare.com/data/histoday?fsym=\(ticker)&tsym=USD&allData=true"
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                var closeArray = [Double]()
                let bitcoinJSON : JSON = JSON(response.result.value!)
                let data = bitcoinJSON["Data"]
                self.currencyObjects[placeholder].age = data.count
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
//                let standard = Sigma.standardDeviationSample(returns)
                self.currencyObjects[placeholder].std = std
//                print(std)
//                SVProgressHUD.dismiss()
//                self.priceLabel.text = String(round(sddev*1000)/1000)
//
                if std < 0.1 {
                    self.currencyObjects[placeholder].risk = "Fair Risk"
                } else if std < 0.2 {
                    self.currencyObjects[placeholder].risk = "High Risk"
                } else {
                    self.currencyObjects[placeholder].risk = "Avoid"
                }
                
//                print(self.currencyObjects[placeholder].symbol)
//                print(self.currencyObjects[placeholder].std)
//                print(self.currencyObjects[placeholder].risk)
                
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.priceLabel.text = "Connection Issues"
            }
        }

    }
    
    func loadCurrencies() {
        
        let BTC = Currency()
        currencyObjects.append(BTC)
        BTC.symbol = "BTC"
        getBitcoinData(ticker: BTC.symbol, placeholder: counter)
        counter+=1
        
        let ETH = Currency()
        currencyObjects.append(ETH)
        ETH.symbol = "ETH"
        getBitcoinData(ticker: ETH.symbol, placeholder: counter)
        counter+=1
        
        
        let EOS = Currency()
        currencyObjects.append(EOS)
        EOS.symbol = "EOS"
        getBitcoinData(ticker: EOS.symbol, placeholder: counter)
        counter+=1
        
        
        let LTC = Currency()
        currencyObjects.append(LTC)
        LTC.symbol = "LTC"
        getBitcoinData(ticker: LTC.symbol, placeholder: counter)
        counter+=1
        
        let XRP = Currency()
        currencyObjects.append(XRP)
        XRP.symbol = "XRP"
        getBitcoinData(ticker: XRP.symbol, placeholder: counter)
        counter+=1
        
        let BCH = Currency()
        currencyObjects.append(BCH)
        BCH.symbol = "BCH"
        getBitcoinData(ticker: BCH.symbol, placeholder: counter)
        counter+=1
        
        let BGG = Currency()
        currencyObjects.append(BGG)
        BGG.symbol = "BGG"
        getBitcoinData(ticker: BGG.symbol, placeholder: counter)
        counter+=1
        
        let BNB = Currency()
        currencyObjects.append(BNB)
        BNB.symbol = "BNB"
        getBitcoinData(ticker: BNB.symbol, placeholder: counter)
        counter+=1
        
        let TRX = Currency()
        currencyObjects.append(TRX)
        TRX.symbol = "TRX"
        getBitcoinData(ticker: TRX.symbol, placeholder: counter)
        counter+=1
        
        let ETC = Currency()
        currencyObjects.append(ETC)
        ETC.symbol = "ETC"
        getBitcoinData(ticker: ETC.symbol, placeholder: counter)
        counter+=1
        
        let ZEC = Currency()
        currencyObjects.append(ZEC)
        ZEC.symbol = "ZEC"
        getBitcoinData(ticker: ZEC.symbol, placeholder: counter)
        counter+=1
        
        let BSV = Currency()
        currencyObjects.append(BSV)
        BSV.symbol = "BSV"
        getBitcoinData(ticker: BSV.symbol, placeholder: counter)
        counter+=1
        
        let NEO = Currency()
        currencyObjects.append(NEO)
        NEO.symbol = "NEO"
        getBitcoinData(ticker: NEO.symbol, placeholder: counter)
        counter+=1
        
        let QTUM = Currency()
        currencyObjects.append(QTUM)
        QTUM.symbol = "QTUM"
        getBitcoinData(ticker: QTUM.symbol, placeholder: counter)
        counter+=1
        
        let USDT = Currency()
        currencyObjects.append(USDT)
        USDT.symbol = "USDT"
        getBitcoinData(ticker: USDT.symbol, placeholder: counter)
        counter+=1
        
        let ZB = Currency()
        currencyObjects.append(ZB)
        ZB.symbol = "ZB"
        getBitcoinData(ticker: ZB.symbol, placeholder: counter)
        counter+=1
        
        let ONT = Currency()
        currencyObjects.append(ONT)
        ONT.symbol = "ONT"
        getBitcoinData(ticker: ONT.symbol, placeholder: counter)
        counter+=1
        
        let DASH = Currency()
        currencyObjects.append(DASH)
        DASH.symbol = "DASH"
        getBitcoinData(ticker: DASH.symbol, placeholder: counter)
        counter+=1
        
        let HT = Currency()
        currencyObjects.append(HT)
        HT.symbol = "HT"
        getBitcoinData(ticker: HT.symbol, placeholder: counter)
        counter+=1
        
        let XLM = Currency()
        currencyObjects.append(XLM)
        XLM.symbol = "XLM"
        getBitcoinData(ticker: XLM.symbol, placeholder: counter)
        counter+=1
    }

}

