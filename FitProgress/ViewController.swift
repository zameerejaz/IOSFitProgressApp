//
//  ViewController.swift
//  FitProgress
//
//  Created by Zameer Ejaz on 08/07/2019.
//  Copyright © 2019 Zameer Ejaz. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
  
    var foundInputs : [Weights]?
    
    @IBOutlet weak var weightEntered: UITextField!
    @IBOutlet weak var displayWeightLabel: UILabel!
    
    @IBAction func savingWeight(_ sender: UIButton) {
        let currentDate = removeTime(addTimeToRemove: Date())
        let itemExistForDate = Weights.fetchSpecificObjectByWeekDate(week2: currentWeek(), date: currentDate)
       print("the amount of data found \(itemExistForDate)")
        if (itemExistForDate > 0){
            showAlert(date: currentDate)
        }else{
            print("new item")
            Weights.saveObject(weightInput: Double (weightEntered.text!)!, dateStamp: currentDate, weekNum: currentWeek())
            
        }
      
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightEntered.delegate = self
        weightEntered.keyboardType = .decimalPad
       // Weights.clearData()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let inputs = Weights.fetchObject(week: currentWeek()){
            foundInputs = inputs
            for input in foundInputs! {
                print("the items found for this week \(input.weightInput ) and date was \(input.dateStamp)")
            }
        }else{
            print("No data found")
        }
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            let invalidCharacter = CharacterSet(charactersIn: "0123456789.").inverted
            return string.rangeOfCharacter(from: invalidCharacter) == nil
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func currentWeek() -> Int{
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date())
        return weekOfYear
    }
    
    private func removeTime(addTimeToRemove removeDate : Date) -> String{
        let now = removeDate
        let dateformatter = DateFormatter()
        dateformatter.timeStyle = DateFormatter.Style.none
        dateformatter.dateStyle = DateFormatter.Style.medium
        
        let stringDate = dateformatter.string(from: now)
        
        //print("converted date " dateformatter.date(from: stringDate)!)
        return stringDate
    }
    
    private func showAlert(date : String){
        let alert = UIAlertController(title: "Weight Exists for \(date)", message: "Would you like to override it ", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert1) in
            print("overriting the data \(alert1.title)")
            Weights.updateUsers(dateStamp: date, weight: Double (self.weightEntered.text!)!, weekNum: self.currentWeek())
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (_) in
             self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true)
    }
    
    

}
