//
//  CalculatorBrain.swift
//  calculadora
//
//  Created by Dyego Silva on 19/11/15.
//  Copyright (c) 2015 curso. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum OP: Printable
    {
        case Operand(Double)
        case UnaryOperand(String, Double -> Double)
        case BinaryOperand(String, (Double, Double) -> Double)
        case UnarySymbolValue(String, Double)
        
        var description: String
        {
            get
            {
                switch self
                {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperand(let symbol, _):
                    return symbol
                case .BinaryOperand(let symbol, _):
                    return symbol
                case .UnarySymbolValue(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [OP]()
    private var knownOPs = [String : OP]()
    
    init()
    {
        func learnOperation(op: OP)
        {
            knownOPs[op.description] = op
        }
        
        learnOperation(OP.BinaryOperand("÷") { $1 / $0 })
        learnOperation(OP.BinaryOperand("×", *))
        learnOperation(OP.BinaryOperand("+", +))
        learnOperation(OP.BinaryOperand("−") { $1 - $0 })
        learnOperation(OP.UnaryOperand("√", sqrt))
        learnOperation(OP.UnaryOperand("cos", cos))
        learnOperation(OP.UnaryOperand("sin", sin))
        learnOperation(OP.UnarySymbolValue("π", M_PI))
    }
    
    private func evaluate(ops: [OP]) -> (result: Double?, remainingOPs: [OP])
    {
        if !ops.isEmpty
        {
            var remainingOPs = ops
            let op = remainingOPs.removeLast()
            
            switch op
            {
            case .Operand(let operand): return (operand, remainingOPs)
            case .UnaryOperand(_, let operation):
                let operandEvaluate = evaluate(remainingOPs)
                if let operand = operandEvaluate.result
                {
                    return (operation(operand), operandEvaluate.remainingOPs)
                }
            case .BinaryOperand(_, let operation):
                let op1Evaluation = evaluate(remainingOPs)
                if let operand1 = op1Evaluation.result
                {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOPs)
                    if let operand2 = op2Evaluation.result
                    {
                        return (operation(operand1, operand2), op2Evaluation.remainingOPs)
                    }
                }
            case .UnarySymbolValue(_, let value):
                return (value, remainingOPs)
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double?
    {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        
        return result
    }
    
    func pushOperand(operand: Double) -> Double?
    {
        opStack.append(OP.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?
    {
        if let operation = knownOPs[symbol]
        {
            opStack.append(operation)
        }
        
        return evaluate()
    }
    
    func clearStack()
    {
        opStack.removeAll(keepCapacity: false)
    }
}