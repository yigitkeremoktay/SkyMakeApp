//
//  ContentView.swift
//  SkyMake App
//
//  Created by Yigit Kerem Oktay on 17.01.2021.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    
    @State private var username: String?
    @State private var password: String?
    @State private var userRole: String?
    
    @State var apiEndpoint: String = "http://192.168.0.138:6810"
    @State var appURL: String = "http://192.168.0.138:6713"
    @State var meetServer: String = "https://meet.jit.si"
    
    @State private var currentPage: String = "Login"
    @State private var currentExam: String = ""
    @State private var currentDoc: String = ""
    @State private var currentMeeting: String = ""
    
    
    let hc_ws = WebEmbed()
    
    var body: some View {
        
        VStack(spacing:0){
            
            HStack{
                
                Image(uiImage: UIImage(named: "SkyMakeLogo")!)
                    .resizable()
                    .frame(width: 45, height: 25, alignment: .center)
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    
                    HStack(alignment: .center,spacing: 30){
                        if userRole != "unverified" && username != nil {
                            Button(action: {
                                self.currentPage = "Home"
                            }) {
                                Text("Home")
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: {
                                self.currentPage = "AR"
                            }) {
                                Text("AR")
                                    .foregroundColor(.white)
                            }
                            Button(action: {
                                self.currentPage = "Help"
                            }) {
                                Text("Help")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                }
                .frame(height: 50)
                
                if username != nil {
                    Button(action: {
                        username = nil
                        password = nil
                        userRole = nil
                        currentPage = "Login"
                    }){
                        Text("Log out")
                            .foregroundColor(.white)
                    }
                } else {
                    Text("You are logged out, please login")
                        .foregroundColor(.white)
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .background(Color.init(UIColor(red: 0.22, green: 0.21, blue: 0.21, alpha: 1.00)))
            switch self.currentPage{
            
            case "Home":
                if userRole == "unverified" {
                    Spacer()
                    HStack{
                        Text("Your account is not yet approved.")
                            .font(.title)
                            .foregroundColor(Color.black)
                    }
                    Spacer()
                } else {
                    HomeView(username: self.$username, password: self.$password, apiEndpoint: self.$apiEndpoint, meetServer: self.$meetServer, currentPage: self.$currentPage, currentExam: self.$currentExam, currentDoc: self.$currentDoc, currentMeeting: self.$currentMeeting, appURL: self.$appURL)
                }
            
            case "OES":
                OESView(appURL: self.$appURL, username: self.$username, password: self.$password, currentExam: self.$currentExam)
                
            case "Document":
                AttachmentView(appURL: self.$appURL, currentDoc: self.$currentDoc)
                
            case "AR":
                SelfServedARView()
                
            case "Liveclass":
                MeetView(meetServer: self.$meetServer, meetCode: self.$currentMeeting)
            
            case "Help":
                hc_ws
                    .onAppear(){
                        hc_ws.load(url: URL(string:"https://help.skymake.theskyfallen.com")!)
                    }
                
            case "Login":
                LoginView(username: self.$username, password: self.$password, currentPage: self.$currentPage, userRole: self.$userRole, apiEndpoint: self.$apiEndpoint)
                
            default:
                Spacer()
                HStack{
                    Text("404. Not found, but in SwiftUI :)")
                        .foregroundColor(Color.black)
                }
                Spacer()
                
            }
            }
            .background(Color.white)
        }
        
}
