//
//  UnitsTableViewController.swift
//  convector
//
//  Created by Kolya on 11.11.16.
//  Copyright © 2016 Kolya. All rights reserved.
// //        //NSURLSesion, ±±APIManager, singleton, interface layout (rotate), custom cell xib, seque

import UIKit

class UnitsTableViewController: UITableViewController {
    
    var moneyArray : [Quotes] = []
    
    var moneyTask: URLSessionDataTask!
    
    var minTable = Double()
    
    var unitsText = String()
    
    var delegate: SaveUnits?
    
    private let client = WebClient()
    
    @IBAction func btnBack(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMoney()
    }
    
    func loadMoney(completion: @escaping (MCurrency?, ServiceError?) -> ()) -> URLSessionDataTask? {
        
        let params: JSON = [:]
        
        return client.load(path: "", method: .get, params: params) { result, error in
            if let dictionaries = result as? [String: AnyObject] {
                completion(MCurrency(json: dictionaries), error)
            }
            
        }
    }

    private func loadMoney() {
        moneyTask?.cancel()
        moneyTask = loadMoney {[weak self] moneyArray, error in
            
            if let error = error {
                print(error.localizedDescription)
            } else if let moneyArray = moneyArray {
                self?.moneyArray = moneyArray.quotes
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moneyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! TableViewCell
        
        let  tableShow = moneyArray[indexPath.row]
        
        cell.nameCurrency?.text = tableShow.name
        cell.valueCarrency?.text = "\(tableShow.val)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let  tableCell = moneyArray[indexPath.row]
        delegate?.save(name:tableCell.name, value: tableCell.val)
        
        let _ = navigationController?.popViewController(animated: true)
    }
}

