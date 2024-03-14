//
//  UserProfileView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-03-13.
//
import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var fitConnect: FitConnectData
    @State private var isShowingUpdateProfile = false

    var body: some View {
        VStack {
            VStack {
                Text("User Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                
                // Display user information
                VStack(alignment: .leading, spacing: 10) {
                    Text("Name: \(fitConnect.fitConnectData?.fullName ?? "Unknown")")
                        .font(.headline)
                    Text("Email: \(fitConnect.fitConnectData?.email ?? "Unknown")")
                        .font(.headline)
                    Text("Contact Number: \(fitConnect.fitConnectData?.contactNumber ?? "Unknown")")
                        .font(.headline)
                    Text("Height: \(fitConnect.fitConnectData?.height.formattedString() ?? "0") cm")
                        .font(.headline)
                    Text("Weight: \(fitConnect.fitConnectData?.weight.formattedString() ?? "0") kg")
                        .font(.headline)
                    Text("Gender: \(fitConnect.fitConnectData?.gender ?? "Unknown")")
                        .font(.headline)
                    if let dob = fitConnect.fitConnectData?.dob {
                        Text("Date of Birth: \(dob, formatter: dateFormatter)")
                            .font(.headline)
                    } else {
                        Text("Date of Birth: Unknown")
                            .font(.headline)
                    }
                }
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            Spacer()
            Button(action: {
                isShowingUpdateProfile.toggle()
            }) {
                Text("Update Profile")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity) 
        .sheet(isPresented: $isShowingUpdateProfile) {
            UpdateProfileView(isShowingUpdateProfile: $isShowingUpdateProfile)
                .environmentObject(fitConnect)
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environmentObject(FitConnectData())
    }
}
