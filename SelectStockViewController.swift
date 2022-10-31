//
//  SelectStockViewController.swift
//  Investing Simulator
//
//  Created by Bryan Lysander on 10/15/22.
//

import UIKit

class SelectStockViewController: UITableViewController{
    @IBOutlet weak var stockPicker: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stockPicker.delegate = self
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int{
        return 16
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "StockItem",
        for: indexPath)

      // Add the following code
      let label = cell.viewWithTag(1000) as! UILabel
              
      for i in 0...15{
          if indexPath.row == i{
              label.text = listStocks()[i]
          }
        }

      return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let stockSelected = segue.destination as! PurchaseOrderViewController
        let selectedRow = tableView.indexPathForSelectedRow!.row
        stockSelected.stockSelectedInput = listStocks()[selectedRow]
    }
    
}

func listStocks()-> Array<String>{
    let listStocksItem: [String] = [
    "AAPL",
    "AMC",
    "AMZN",
    "BABA",
    "BAC",
    "DIS",
    "GOOG",
    "JD",
    "MSFT",
    "NKE",
    "QQQ",
    "SPY",
    "TSLA",
    "VNQ",
    "VOO",
    "VTI"]
    
    return listStocksItem
}
