//
//  MacroResponseModel.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-02-14.
//

import Foundation

struct GPTResponse: Decodable {
    let choices: [GPTCompletion]
}

struct GPTCompletion: Decodable{
    let message: GPTResponseMessage
    
    
}

struct GPTResponseMessage: Decodable {
    let functionCall: GPTFunctionCall
    
    enum CodingKeys: String, CodingKey{
        case functionCall = "function_call"
    }
}

struct GPTFunctionCall: Decodable{
    let name: String
    let arguments: String
}

struct MacroResponse: Decodable{
    let food: String
    let fat: Int
    let carb: Int
    let protein: Int
}
