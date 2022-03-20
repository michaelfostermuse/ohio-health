//
//  ContentView.swift
//  ohio-health
//
//  Created by Michael Muse on 3/19/22.
//

import SwiftUI
import AVFoundation
import Speech


struct ContentView: View {
    
    private let audioEngine = AVAudioEngine()
    private let speech = SFSpeechRecognizer()
    
    @State private var userName: String = ""
    @State private var cityName: String = ""
    @State private var yearOfJoining: String = ""
    @StateObject var speechEngine = SpeechEngine()
    @State private var isRecording = false
    
    enum HighlightTag {
            case none, first, second, third
        }

    private var highlighted = HighlightTag.none
    
    fileprivate func processVoiceTap(inputValue: inout String) {
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        if isRecording == false {
            speechEngine.reset()
            inputValue = ""
            speechEngine.transcribe()
            isRecording = true
        } else {
            speechEngine.stopTranscribing()
            isRecording = false
            inputValue = speechEngine.transcript
            speechEngine.reset()
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    Label("First Page", systemImage: "person.crop.circle")
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
                        Button("Voice") {
                            processVoiceTap(inputValue: &userName)
                        }.padding()
                    }
                    Spacer().padding()
                    HStack {
                        Text("City Name")
                            .frame(width: 80)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 5)
                        TextField(text: $cityName, prompt: Text("Required")) {
                                Text("Username")
                            }
                        Button("Voice") {
                            processVoiceTap(inputValue: &cityName)
                        }.padding()
                    }
                    Spacer().padding()
                    HStack {
                        Text("Year of Joining")
                            .frame(width: 80)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 5)
                        TextField(text: $yearOfJoining, prompt: Text("Required")) {
                                Text("Username")
                            }
                        Button("Voice") {
                            processVoiceTap(inputValue: &yearOfJoining)
                        }.padding()
                    }
                    Spacer().padding()
                    NavigationLink(destination: PlaybackView()) {
                                        Text("Next")
                                    }
                                    .navigationTitle("User Details")
                }.onAppear {
                    print("ContentView appeared!")
                    setupApp()
                    askUserPermission()
                }.onDisappear {
                    storeUser()
                    print("ContentView disappeared!")
                }
            }
        }.navigationTitle("Ohio Health")
    }
    
    private func setupApp() {
        
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
    
    private func storeUser() {
        var users = [User]()

        let newUser = User(firstName: self.userName, city: self.cityName, year: self.yearOfJoining)
        users.append(newUser)

        Storage.store(users, to: .documents, as: "users.json")
    }
    
    private func askUserPermission() {
        print("Asking user permission")
        // Make the authorization request
        SFSpeechRecognizer.requestAuthorization { authStatus in

           // If the authorization status results in changes to the
           // app’s interface, so process the results on the app’s
           // main queue.
              OperationQueue.main.addOperation {
                  
                 switch authStatus {
                    case .authorized:
                       print("authorized")

                    case .denied:
                     print("denied")

                    case .restricted:
                     print("restricted")

                    case .notDetermined:
                     print("notDetermined")
                 @unknown default:
                     print("unknown")
                 }
              }
           }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ProgressButtonStyle: ButtonStyle {
    let isLoading: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(isLoading ? 0 : 1)
            .overlay {
                if isLoading {
                    ProgressView()
                }
            }
    }
}
