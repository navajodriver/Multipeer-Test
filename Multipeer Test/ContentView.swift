//
//  ContentView.swift
//  Multipeer Test
//
//  Created by Aaron on 2021-02-25.
//

import SwiftUI
import CoreData
import MultipeerConnectivity
import OSLog

struct ContentView: View {
    @ObservedObject public var transferservice = TransferService()
    @State var input = ""
    
    
    
    var body: some View {
        VStack{
            Text("\(transferservice.sentText)")
            TextField("Enter your text", text:$input)
        
            Button("Send Text"){
                if  let textData = input.data(using: .utf8) {
                    try? transferservice.session.send(textData, toPeers: transferservice.session.connectedPeers, with: .reliable)
                os_log("Sending the data:\(textData)")
                }}
        
        Button("Invite"){
            transferservice.invite()
        }
        Button("Advertise"){
            transferservice.startAdvertising()
        }
        }
    }
}
 



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
