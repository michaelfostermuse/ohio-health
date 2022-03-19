//
//  PlaybackView.swift
//  ohio-health
//
//  Created by Michael Muse on 3/19/22.
//

import Foundation
import AVFoundation
import SwiftUI


struct SecondView: View {
    
    @State private var userName: String = ""
    @State private var cityName: String = ""
    @State private var yearOfJoining: String = ""
    @State private var isPlaying = false
    
    var body: some View {
        VStack {
            Text("First Page")
                .padding()
            HStack {
                Text("First")
                    .padding()
                TextField(text: $userName, prompt: Text("Hey Mike .... you SUCK !!!")) {
                        Text("Username")
                    }
                Button("Translate") {
                   // highlighted = .first
                    processPlaybackTap(inputValue: &userName)
                }.padding().buttonStyle(ProgressButtonStyle(isLoading: isPlaying))
            }
            HStack {
                Text("City Name")
                    .padding()
                TextField(text: $cityName, prompt: Text("Required")) {
                        Text("Username")
                    }
                Button("Translate") {
                    //highlighted = .second
                    processPlaybackTap(inputValue: &cityName)
                }.padding().buttonStyle(ProgressButtonStyle(isLoading: isPlaying))
            }
            HStack {
                Text("Year of Joining")
                    .padding()
                TextField(text: $yearOfJoining, prompt: Text("Required")) {
                        Text("Username")
                    }
                Button("Translate") {
                   // highlighted = .third
                    processPlaybackTap(inputValue: &yearOfJoining)
                }.padding().buttonStyle(ProgressButtonStyle(isLoading: isPlaying))
            }
            
//            NavigationLink(destination: SecondView()) {
//                                Text("Next")
//                            }
//                            .navigationTitle("User Details")
        }.onAppear {
            print("ContentView appeared!")
            //askUserPermission()
        }.onDisappear {
            print("ContentView disappeared!")
        }
    }
    
    fileprivate func processPlaybackTap(inputValue: inout String) {
        
        let utterance = AVSpeechUtterance(string: userName)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.1

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
        
    }
    
    
}
