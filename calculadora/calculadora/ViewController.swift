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
    var displayValue: Double
    {
        get
        {
            return (display.text! as NSString).doubleValue
        }
        set
        {
            display.text = "\(newValue)"
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
    
    @IBAction func attachPoint(sender: UIButton)
    {
        let point = sender.currentTitle!
        let range = display.text!.rangeOfString(point, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil)
        
        if range == nil
        {
            display.text = display.text! + point
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func clearDisplay()
    {
        display.text = "0"
        history.text = "0"
        calcBrain.clearStack()
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func enter()
    {
        userIsInTheMiddleOfTyping = false
        
        if let result = calcBrain.pushOperand(displayValue)
        {
            displayValue = result
        }
        else
        {
            displayValue = 0
        }
    }
}

