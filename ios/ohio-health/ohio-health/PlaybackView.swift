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
        ScrollView(.vertical) {
            VStack {
                Label("Second Page", systemImage: "hifispeaker")
                    .font(.title)
                Spacer().padding()
                HStack {
                    Text("First Name")
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)
                        //.padding()
                    TextField(text: $userName, prompt: Text("Required")) {
                            Text("Username")
                        }
                    Button("Translate") {
                       // highlighted = .first
                        isPlaying = true
                        processPlaybackTap(inputValue: &userName)
                    }.padding().buttonStyle(PlaybackButtonStyle(isPlaying: isPlaying))
                }
                Spacer().padding()
                HStack {
                    Text("City Name")
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)
                    TextField(text: $cityName, prompt: Text("Required")) {
                            Text("City Name")
                        }
                    Button("Translate") {
                        //highlighted = .second
                        isPlaying = true
                        processPlaybackTap(inputValue: &cityName)
                    }.padding().buttonStyle(PlaybackButtonStyle(isPlaying: isPlaying))
                }
                Spacer().padding()
                HStack {
                    Text("Year of Joining")
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)
                    TextField(text: $yearOfJoining, prompt: Text("Required")) {
                            Text("Year of Joining")
                        }
                    Button("Translate") {
                       // highlighted = .third
                        isPlaying = true
                        processPlaybackTap(inputValue: &yearOfJoining)
                    }.padding().buttonStyle(PlaybackButtonStyle(isPlaying: isPlaying))
                }
                Spacer().padding()
                Button("Retrieve Data") {
                    print (" retrieving")
                }
            }.onAppear {
                print("ContentView appeared!")
            }.onDisappear {
                print("ContentView disappeared!")
            }
        }
    }
    
    fileprivate func processPlaybackTap(inputValue: inout String) {
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        let utterance = AVSpeechUtterance(string: inputValue)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.1

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        isPlaying = false
    }
    
    
}

struct PlaybackButtonStyle: ButtonStyle {
    let isPlaying: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(isPlaying ? 0 : 1)
            .overlay {
                if isPlaying {
                    ProgressView()
                }
            }
    }
}
