//
//  MacroOpenAIService.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-02-14.
//

import Foundation

enum HTTPMethod: String{
    case post = "POST"
    case get = "GET"
}

class OpenAiService{
    
    static let shared = OpenAiService()
    
    private init ( ) {  }
    
    private func generateURLRequest(httpMethod: HTTPMethod, message: String)  throws -> URLRequest{
        guard let url = URL(string:"https://api.openai.com/v1/chat/completions")
        else{
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        
            //Method
        urlRequest.httpMethod = httpMethod.rawValue
        
            //Header
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(Secrets.apiKey)", forHTTPHeaderField:"Authorization" )
        
            //Body
        let systemMessage = GPTMessage(role: "system", content: "You are a macronutrient expert.")
        let userMessage = GPTMessage(role: "user", content: message)
        
        let food = GPTFunctionProperty(type: "string", description: "The food item e.g. hamburger")
        let fat = GPTFunctionProperty(type: "integer", description: "The amount of fats in grams of the given food item")
        let carb = GPTFunctionProperty(type: "integer", description: "The amount of carbohydrates in grams of the given food item")
        let protein = GPTFunctionProperty(type: "integer", description: "The amount of protein in grams of given food item")
        
        let params: [String: GPTFunctionProperty] = [
            "food": food,
            "fat": fat,
            "carb":carb,
            "protein": protein
        ]
        
        let functionParams = GPTFunctionParam(type: "object", properties: params, required: ["food", "fat", "carb","protein"])
        
        let function = GPTFunction(name: "get_macronutrients",
                                   description: "Get the macronutrients for a given food.",
                                   parameters: functionParams)
        
        let payload = GPTChatPayload(model: "gpt-3.5-turbo-0613", messages: [systemMessage, userMessage], functions: [function])
        
        let jsonData = try JSONEncoder().encode(payload)
        
        
        urlRequest.httpBody = jsonData
        return urlRequest
    }
    
    func sendPromptToChatGPT(message: String) async throws -> MacroResponse{
        let urlRequest = try generateURLRequest(httpMethod: .post, message: message)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let result = try JSONDecoder().decode(GPTResponse.self, from: data)
        
        let args = result.choices[0].message.functionCall.arguments
        guard let argData = args.data(using: .utf8) else{
            throw URLError(.badURL)
        }
        let macro = try JSONDecoder().decode(MacroResponse.self, from: argData)
        
        print(result.choices[0])
        print(macro)
        return macro
//                    print(String(data: data, encoding:.utf8)!)
    }
    
    
}
