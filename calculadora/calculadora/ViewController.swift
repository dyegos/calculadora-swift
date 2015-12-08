//
//  ViewController.swift
//  calculadora
//
//  Created by Dyego Silva on 17/11/15.
//  Copyright (c) 2015 curso. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    //UI Properties
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    //Internal Properties
    var userIsInTheMiddleOfTyping = false
    var calcBrain = CalculatorBrain()
    var displayValue: Double?
    {
        get
        {
            return (display.text! as NSString).doubleValue
        }
        set
        {
            display.text = "\(newValue ?? 0)"
            userIsInTheMiddleOfTyping = false
        }
    }
    
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping
        {
            display.text = display.text! + digit
        }
        else
        {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func doOperation(sender: UIButton)
    {
        if userIsInTheMiddleOfTyping
        {
            enter()
        }
        
        if let operation = sender.currentTitle
        {
            if let result = calcBrain.performOperation(operation)
            {
                displayValue = result
            }
            else
            {
                displayValue = 0
            }
        }
    }
    
    @IBAction func saveVariable(sender: UIButton)
    {
        let variable = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping
        {
            calcBrain.variblesValues[variable] = displayValue
        }
        
        if let result = calcBrain.pushOperand(variable)
        {
            displayValue = result
            history.text = calcBrain.getCalcHistory()
        }
    }
    
    @IBAction func attachPoint(sender: UIButton)
    {
        let point = sender.currentTitle!

        if findCharacterInsideString(display.text!, withString: point)
        {
            display.text = display.text! + point
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func clearDisplay()
    {
        displayValue = nil
        history.text = "0"
        calcBrain.clearStack()
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func enter()
    {
        userIsInTheMiddleOfTyping = false
        
        if let result = calcBrain.pushOperand(displayValue!)
        {
            displayValue = result
            history.text = calcBrain.getCalcHistory()
        }
        else
        {
            displayValue = 0
        }
    }
    
    @IBAction func deleteCharacter()
    {
        if !userIsInTheMiddleOfTyping { return }
        
        let char = display.text!
        if countElements(char) > 1
        {
            display.text! = dropLast(char)
        }
        else if countElements(char) == 1
        {
            displayValue = nil
            userIsInTheMiddleOfTyping = false
        }
    }
    
    @IBAction func changeSignal()
    {
        if !userIsInTheMiddleOfTyping { return }
        
        displayValue = displayValue! * -1
        userIsInTheMiddleOfTyping = true
    }
    
    func findCharacterInsideString(string: String, withString wstring: String) -> Bool
    {
        println("encontrou caracter: \(string.rangeOfString(wstring, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil))")
        return string.rangeOfString(wstring, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil) == nil ? true : false
    }
}