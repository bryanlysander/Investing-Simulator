//
//  PurchaseOrderViewController.swift
//  Investing Simulator
//
//  Created by Bryan Lysander on 10/17/22.
//

import UIKit


class PurchaseOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var isStockDateVisible = false

    @IBOutlet weak var stockDateDropDown: UITableView!
    @IBOutlet weak var stockDateDropDownHC: NSLayoutConstraint!
    @IBOutlet weak var buttonStockDate: UIButton!
    @IBOutlet weak var investmentAmount: UITextField!
    
    var stockSelectedInput = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        investmentAmount.delegate = self
        stockDateDropDown.delegate = self
        stockDateDropDown.dataSource = self
        stockDateDropDownHC.constant = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int{
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "dateOption")
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "dateOption")
        }
        cell?.textLabel?.text = "\(indexPath.row + 1) years ago"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        buttonStockDate.setTitle("\(indexPath.row + 1) years ago",
        for: .normal)
        UIView.animate(withDuration: 0.49){
            self.stockDateDropDownHC.constant = 0
            self.isStockDateVisible = false
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func selectDate(_ sender: AnyObject){
        UIView.animate(withDuration: 0.49){
            if self.isStockDateVisible != false{
                self.stockDateDropDownHC.constant = 0
                self.isStockDateVisible = false
            }else{
                self.isStockDateVisible = true
                self.stockDateDropDownHC.constant = 43.9 * 2.9
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputForInvesting = segue.destination as! InvestingResultViewController
        let inputsValue: [Int: String] = [0 : stockSelectedInput,
                           1 : investmentAmount.text ?? "0",
                           2 : buttonStockDate.currentTitle ?? "1 years ago"]
        inputForInvesting.inputsStock = inputsValue
    }
    
}
