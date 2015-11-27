//
//  ViewController.swift
//  calculadoraSwift2
//
//  Created by iPicnic Digital on 11/20/15.
//  Copyright © 2015 Dyego Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
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
        
        history.text = calcBrain.getCalcHistory()
    }
    
    @IBAction func attachPoint(sender: UIButton)
    {
        let point = sender.currentTitle!
        
        if display.text!.rangeOfString(point) == nil
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
        
        if var char = display.text?.characters where char.count > 1
        {
            char.removeLast()
            display.text!.removeAll()
            display.text!.appendContentsOf(char)
        }
        else if display.text?.characters.count == 1
        {
            displayValue = nil
            userIsInTheMiddleOfTyping = false
        }
    }
    
    @IBAction func changeSignal()
    {
        if !userIsInTheMiddleOfTyping { return }
        
        if display.text!.rangeOfString("-") != nil
        {
            var chars = display.text!.characters
            chars.removeFirst()
            display.text!.removeAll()
            display.text!.appendContentsOf(chars)
        }
        else
        {
            display.text! = "−" + display.text!
        }
    }
}

