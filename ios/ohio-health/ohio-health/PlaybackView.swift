//
//  PlaybackView.swift
//  ohio-health
//
//  Created by Michael Muse on 3/19/22.
//

import Foundation
import AVFoundation
import SwiftUI


enum HighlightTag {
        case none, first, second, third
    }

struct PlaybackView: View {
    
    @State private var userName: String = ""
    @State private var cityName: String = ""
    @State private var yearOfJoining: String = ""
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Label("Second Page", systemImage: "hifispeaker")
                    .font(.title)
                Spacer().padding()
                HStack {
                    Text("First Name")
                        .frame(width: 80)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)
                    TextField(text: $userName, prompt: Text("Required")) {
                            Text("Username")
                        }
                    Button("Translate") {
                        processPlaybackTap(inputValue: userName)
                    }.frame(width: 100)
                        .padding()
                }
                Spacer().padding()
                HStack {
                    Text("City Name")
                        .frame(width: 80)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)
                    TextField(text: $cityName, prompt: Text("Required")) {
                            Text("City Name")
                        }
                    Button("Translate") {
                        processPlaybackTap(inputValue: cityName)
                    }.frame(width: 100)
                        .padding()
                }
                Spacer().padding()
                HStack {
                    Text("Year of Joining")
                        .frame(width: 80)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)
                    TextField(text: $yearOfJoining, prompt: Text("Required")) {
                            Text("Year of Joining")
                        }
                    Button("Translate") {
                        processPlaybackTap(inputValue: yearOfJoining)
                    }.frame(width: 100)
                        .padding()
                }
                Spacer().padding()
                Button("Retrieve Data") {
                    getUserData()
                }
            }.onAppear {
                print("ContentView appeared!")
            }.onDisappear {
                print("ContentView disappeared!")
            }
        }
    }
    
    private func getUserData() {
        if Storage.fileExists("users.json", in: .documents) {
            let usersFromDisk = Storage.retrieve("users.json", from: .documents, as: [User].self)
            if usersFromDisk.count > 0 {
                Storage.currentUser = usersFromDisk[0]
                guard let userName = Storage.currentUser?.firstName,
                      let city = Storage.currentUser?.city,
                      let year = Storage.currentUser?.year else {
                          return
                      }
                self.userName = userName
                self.cityName = city
                self.yearOfJoining = year
                
            }
        }
    }
    
    func processPlaybackTap(inputValue: String ) {
        do {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        let utterance = AVSpeechUtterance(string: inputValue)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)

        do {
            disableAVSession()
        }
    }

    private func disableAVSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            
        } catch {
            print("audioSession properties weren't disable.")
        }
    }
}
