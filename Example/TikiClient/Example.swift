/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import PhotosUI

import SwiftUI
import TikiClient

import CoreLocation
import AppTrackingTransparency


@main
struct Main: App {
    
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var image: UIImage?
    
    @State public var publishImageId: String?
    
    @StateObject var locationManager = TikiClient.location
    
    @State var responseTrack = "Asking permission in progress"
    
    //Auth Token
    var providerId = ""
    var secret = ""
    var companyName = ""
    var tosUrl = ""
    var privacyUrl = ""
    var userId = ""
       
    var license = License()
    var body: some Scene {
        WindowGroup {
            VStack {
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                }
                Button("Open camera") {
                    TikiClient.capture.scan(onImage: { image in
                        selectedImage = image
                        TikiClient.auth.token(providerId: providerId, secret: secret, scopes: ["publish"], completion: { token, error  in
                            TikiClient.capture.publish(images: [image!], token: token!, completion: { publishId, error2 in
                                if(error == nil){
                                    publishImageId = publishId
                                }
                                
                            })
                            
                        })

                    })
                }.padding(.bottom, 2)
                Button("Create License") {
                    print(TikiClient.createLicense(completion: { message in
                        print(message)
                        
                    }))
                }.padding(.bottom, 2)
                Button("Initialize") {
                    TikiClient.initialize(userId: userId, completion: { message in
                        print(message)
                    })
                }.padding(.bottom, 2)
                Button("configuration") {
                    TikiClient.configuration(config:  Config(providerId: providerId, publicKey: secret, companyName:  companyName, companyJurisdiction: "USA", tosUrl: tosUrl, privacyUrl: privacyUrl))
                }.padding(.bottom, 2)
                Button("Verify Capture Upload Image") {
                    TikiClient.auth.token(providerId: providerId, secret: secret, scopes: ["publish"], completion: { token, error  in
                        TikiClient.capture.receipt(receiptId: publishImageId!, token: token!, completion: { message, error  in
                            print(message)
                            
                        })
                    })
                }.padding(.bottom, 2)
                VStack {
                    switch locationManager.authorizationStatus {
                        case .authorizedWhenInUse:  // Location services are available.
                            Text("Allow location when in use and your current location is:")
                            Text("Latitude: \(locationManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
                            Text("Longitude: \(locationManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")
                        case .authorizedAlways: // Location services are available.
                            Text("Allow location always and your current location is:")
                            Text("Latitude: \(locationManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
                            Text("Longitude: \(locationManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")
                        case .restricted, .denied:  // Location services currently unavailable.
                            // Handle with user reject
                            Text("Current location data was restricted or denied.")
                        case .notDetermined:        // Authorization not determined yet.
                            Text("Finding your location...")
                            ProgressView()
                        default:
                            ProgressView()
                        }
                }
                VStack{
                    if(TikiClient.tracking.isTrackingAccessAvailable()){
                        Text("Granted consent, The Traking Identifier is: \(TikiClient.tracking.getTrackingIdentifier()!.uuidString)")
                    }else{
                        Button("Ask to track"){
                            TikiClient.tracking.askToTrack() {
                                response in
                                switch response {
                                case .notDetermined:
                                    responseTrack = "Not Determined"
                                case .restricted:
                                    responseTrack = "Restricted"
                                case .denied:
                                    responseTrack = "Denied"
                                case .authorized:
                                    responseTrack = "Authorized"
                                }
                                
                            }
                        }
                        Text(responseTrack)
                    }

                }
                
            }
        }
    }
}
