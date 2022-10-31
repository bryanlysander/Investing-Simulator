//
//  InvestingResultViewController.swift
//  Investing Simulator
//
//  Created by Bryan Lysander on 10/17/22.
//

import UIKit

class InvestingResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    
    var inputsStock: [Int: String] = [:]
    var leftData = ["Your initial investment:", "Your investment is worth:", "Annualized return:", "All time increase:", "Total profit:", "" ,"Company Overview:", "", "Country:", "Dividend:", "EPS:", "PE ratio:", "52 week high:", "52 week low:"]
    var rightData : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStockPrice(stockName: inputsStock[0]!) {stockPrice in
            let ourKey : String = self.inputsStock[0]! + self.inputsStock[2]!
            self.calculation(price: stockPrice, ourKey: ourKey)
        }
        
        getCompanyOverview(stockName: inputsStock[0]!) { companyOverview in
            self.rightData.append(companyOverview.country)
            self.rightData.append(companyOverview.dividend)
            self.rightData.append(companyOverview.eps)
            self.rightData.append(companyOverview.peRatio)
            self.rightData.append("$" + companyOverview.yearlyHigh)
            self.rightData.append("$" + companyOverview.yearlyLow)
        }
        
        let nib = UINib(nibName: "DoubleLabelViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DoubleLabelViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleLabelViewCell", for: indexPath) as! DoubleLabelViewCell
        cell.leftLabel.text = leftData[indexPath.row]
        while (leftData.count != rightData.count){
            var seconds: Double = 0.1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            }
            seconds = seconds + 0.1
        }
        cell.rightLabel.text = self.rightData[indexPath.row]
        
        return cell
    }
     
    func calculation(price: String, ourKey: String) -> Void{
        print(price)
        var currentPrice: Double = Double(price) ?? 0.0
        let oldPrice: Int = priceFromYearsAgo(key: ourKey)
        print(oldPrice)
        let totalInvestment: Double = Double(self.inputsStock[1] ?? "0") ?? 0.0
        print(totalInvestment)
        var annualizedReturn: Double = 0.0
        let currentWorth: Double =  round((totalInvestment / Double(oldPrice)) * currentPrice)
        
        switch self.inputsStock[2]{
        case "2 years ago":
            annualizedReturn = round(((currentWorth - totalInvestment) / totalInvestment) * 50)
        case "3 years ago":
            annualizedReturn = round(((currentWorth - totalInvestment) / totalInvestment) * 100/3)
        case "4 years ago":
            annualizedReturn = round(((currentWorth - totalInvestment) / totalInvestment) * 25)
        case "5 years ago":
            annualizedReturn = round(((currentWorth - totalInvestment) / totalInvestment) * 20)
        default:
            annualizedReturn = round(((currentWorth - totalInvestment) / totalInvestment) * 100)
        }
        
        print((currentWorth - totalInvestment) / totalInvestment)
        let allTimeIncrease: Double = round((currentWorth - totalInvestment) / totalInvestment * 100)
        let totalProfit: Double = currentWorth - totalInvestment
        
        self.rightData.insert((self.inputsStock[1] ?? "0"), at: 0)
        self.rightData.insert(String(Int(currentWorth)), at: 1)
        self.rightData.insert(String(Int(annualizedReturn)) + "%", at: 2)
        self.rightData.insert(String(Int(allTimeIncrease)) + "%", at: 3)
        self.rightData.insert(String(Int(totalProfit)), at: 4)
        self.rightData.insert("", at: 5)
        self.rightData.insert("", at: 6)
        self.rightData.insert("", at: 7)
    }
    
    func getStockPrice(stockName: String, completionHandler: @escaping (String) -> Void) {
        let url = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(stockName)&apikey=P9U5CXHXEUNO61PM")!

        let session = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with getting stock price: \(error)")
            return
          }

          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            print("Error with the response, status: \(response)")
            return
          }

          if let data = data,
            let stockPrice = try? JSONDecoder().decode(stockResult.self, from: data) {
              completionHandler(stockPrice.result.price)
          }
        })
        session.resume()
      }
    
    func getCompanyOverview(stockName: String, completionHandler: @escaping (companyOverview) -> Void) {
        let url = URL(string: "https://www.alphavantage.co/query?function=OVERVIEW&symbol=\(stockName)&apikey=P9U5CXHXEUNO61PM")!

        let session = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with getting company overview: \(error)")
            return
          }

          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            print("Error with the response, status: \(response)")
            return
          }

          if let data = data,
            let companyResult = try? JSONDecoder().decode(companyOverview.self, from: data) {
              completionHandler(companyResult)
          }
        })
        session.resume()
      }
    
    func priceFromYearsAgo(key: String) -> Int{
        let listOfPrices : [String: Int] = [
            "AAPL1 years ago" : 181, "AAPL2 years ago" : 132, "AAPL3 years ago" : 72, "AAPL4 years ago" : 37, "AAPL5 years ago" : 41,
            "AMC1 years ago" : 17, "AMC2 years ago" : 1, "AMC3 years ago" : 4, "AMC4 years ago" : 7, "AMC5 years ago" : 9,
            "AMZN1 years ago" : 167, "AMZN2 years ago" : 163, "AMZN3 years ago" : 94, "AMZN4 years ago" : 73, "AMZN5 years ago" : 58,
            "BABA1 years ago" : 119, "BABA2 years ago" : 226, "BABA3 years ago" : 216, "BABA4 years ago" : 134, "BABA5 years ago" : 185,
            "BAC1 years ago" : 44, "BAC2 years ago" : 29, "BAC3 years ago" : 33, "BAC4 years ago" : 22, "BAC5 years ago" : 26,
            "DIS1 years ago" : 155, "DIS2 years ago" : 171, "DIS3 years ago" : 146, "DIS4 years ago" : 109, "DIS5 years ago" : 111,
            "GOOG1 years ago" : 144, "GOOG2 years ago" : 88, "GOOG3 years ago" : 67, "GOOG4 years ago" : 52, "GOOG5 years ago" : 53,
            "JD1 years ago" : 67, "JD2 years ago" : 85, "JD3 years ago" : 35, "JD4 years ago" : 20, "JD5 years ago" : 41,
            "MSFT1 years ago" : 333, "MSFT2 years ago" : 220, "MSFT3 years ago" : 156, "MSFT4 years ago" : 97, "MSFT5 years ago" : 81,
            "NKE1 years ago" : 157, "NKE2 years ago" : 146, "NKE3 years ago" : 101, "NKE4 years ago" : 76, "NKE5 years ago" : 67,
            "QQQ1 years ago" : 380, "QQQ2 years ago" : 319, "QQQ3 years ago" : 214, "QQQ4 years ago" : 156, "QQQ5 years ago" : 162,
            "SPY1 years ago" : 466, "SPY2 years ago" : 381, "SPY3 years ago" : 322, "SPY4 years ago" : 252, "SPY5 years ago" : 273,
            "TSLA1 years ago" : 342, "TSLA2 years ago" : 293, "TSLA3 years ago" : 29, "TSLA4 years ago" : 21, "TSLA5 years ago" : 21,
            "VNQ1 years ago" : 111, "VNQ2 years ago" : 83, "VNQ3 years ago" : 92, "VNQ4 years ago" : 74, "VNQ5 years ago" : 81,
            "VOO1 years ago" : 429, "VOO2 years ago" : 350, "VOO3 years ago" : 296, "VOO4 years ago" : 231, "VOO5 years ago" : 251,
            "VTI1 years ago" : 236, "VTI2 years ago" : 199, "VTI3 years ago" : 163, "VTI4 years ago" : 128, "VTI5 years ago" : 140
            ]
        return listOfPrices[key]!
    }
    
    struct globalQuote: Codable{
        let price: String
        enum CodingKeys: String, CodingKey{
            case price = "05. price"
        }
    }

    struct stockResult: Codable{
        let result: globalQuote
        enum CodingKeys: String, CodingKey{
            case result = "Global Quote"
        }
    }
    
    struct companyOverview: Codable{
        let country: String
        let dividend: String
        let exchange: String
        let peRatio: String
        let eps: String
        let yearlyHigh: String
        let yearlyLow: String
        enum CodingKeys: String, CodingKey{
            case country = "Country"
            case dividend = "DividendPerShare"
            case exchange = "Exchange"
            case peRatio = "PERatio"
            case eps = "EPS"
            case yearlyHigh = "52WeekHigh"
            case yearlyLow = "52WeekLow"
        }
    }
}


