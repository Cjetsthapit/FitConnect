//
//  Data.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-03-06.
//

import Foundation
import SwiftUI

struct Item: Identifiable{
    var id = UUID()
    var title : String
    var text : String
    var image : String
    var gradient: LinearGradient
    var youtubeID: String
}

var items = [Item( title:"Workout for beginner", text: "A Complete guide for newbies", image:"a", gradient: LinearGradient(
    gradient: Gradient(stops: [
        .init(color: Color(Color.blue), location: 0),
        .init(color: Color(Color.green), location: 1)]),
    startPoint: UnitPoint(x: 0.5002249700310126,
                          y: 3.0834283490377423e-7),
    endPoint: UnitPoint(x: -0.0016390833199537713, y: 0.977085239704672)), youtubeID: "qdlQyNe_9tE"),
             Item( title: "Beginner's workout", text: "Guide for starters", image: "a", gradient: LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(Color.red), location: 0),
                    .init(color: Color(Color.yellow), location: 1)]),
                startPoint: UnitPoint(x: 0.5002249700310126,
                                      y: 3.0834283490377423e-7),
                endPoint: UnitPoint(x: -0.0016390833199537713, y: 0.977085239704672)), youtubeID: "cbKkB3POqaY"),
             Item( title: "Easy fitness", text: "Introductory guide", image: "a", gradient: LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(Color.black), location: 0),
                    .init(color: Color(Color.blue), location: 1)]),
                startPoint: UnitPoint(x: 0.5002249700310126,
                                      y: 3.0834283490377423e-7),
                endPoint: UnitPoint(x: -0.0016390833199537713, y: 0.977085239704672)), youtubeID: "CIxNJbit9BA"),
             Item( title: "Starter exercise", text: "Basic guide for beginners", image: "a", gradient: LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(Color.blue), location: 0),
                    .init(color: Color(Color.red), location: 1)]),
                startPoint: UnitPoint(x: 0.5002249700310126,
                                      y: 3.0834283490377423e-7),
                endPoint: UnitPoint(x: -0.0016390833199537713, y: 0.977085239704672)), youtubeID: "2MoGxae-zyo"),
             Item( title: "Simple fitness", text: "Starting your fitness journey", image: "a", gradient: LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(Color.red), location: 0),
                    .init(color: Color(Color.green), location: 1)]),
                startPoint: UnitPoint(x: 0.5002249700310126,
                                      y: 3.0834283490377423e-7),
                endPoint: UnitPoint(x: -0.0016390833199537713, y: 0.977085239704672)), youtubeID: "UItWltVZZmE")]
