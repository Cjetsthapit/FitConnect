//
//  IndexView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-03-06.
//

import SwiftUI

struct IndexView: View {
    var body: some View {
        NavigationView {
            
            ScrollView {
                    
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing:16) {
                        ForEach(items) { item in
                            NavigationLink(destination: DetailView(item: item)) {
                                CardView(item: item)
                            }
                           
                        }
                        
                    }
                    .padding()
                }.navigationTitle("Hello User")
            }
        }
        
    }
}

#Preview {
    IndexView()
}
