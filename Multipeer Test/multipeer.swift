//
//  multipeer.swift
//  Multipeer Test
//
//  Created by Aaron on 2021-02-25.
//

import Foundation
import MultipeerConnectivity
import OSLog
import SwiftUI

//protocol TransferDelegate {
//
//    func connectedDevicesChanged(manager : TransferService, connectedDevices: [String])
//    func sentData(manager : TransferService, dataString: String)
//
//}

class TransferService : NSObject, ObservableObject {

    let TransferServiceType = "Airborne-Logs"
    public var PeerId = MCPeerID(displayName: UIDevice.current.name)
    public var serviceAdvertiser : MCNearbyServiceAdvertiser?
    public var session: MCSession
    @Published public var sentText: String = "1"

    override init() {
        session = MCSession(peer: PeerId, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        session.delegate = self
        
    }


    func startAdvertising(){
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: PeerId, discoveryInfo: nil, serviceType: TransferServiceType)
        serviceAdvertiser?.delegate = self
        serviceAdvertiser?.startAdvertisingPeer()
    }
    
    func invite(){
        let browser = MCBrowserViewController(serviceType: TransferServiceType, session: session)
        browser.delegate = self
        UIApplication.shared.windows.first?.rootViewController?.present(browser, animated: true)
    }
    
    func stopAdvertising(){
        
    }
    
    func stopBrowsing(){
        
    }
    
    
}

extension TransferService : MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        os_log("%@", "didNotStartAdvertisingPeer: \(error)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        os_log("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
        
    }

}

extension TransferService : MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        os_log("%@", "didNotStartBrowsingForPeers: \(error)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        os_log("%@", "foundPeer: \(peerID)")
        os_log("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
        
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        os_log("%@", "lostPeer: \(peerID)")
    }

}

extension TransferService : MCSessionDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        os_log("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
      
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let datastr = String(data: data, encoding: .utf8){
            sentText = datastr
            os_log("Received: \(datastr)")
            os_log("output: \(self.sentText)")
        }
        
        
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        os_log("%@", "didReceiveStream")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        os_log("%@", "didStartReceivingResourceWithName")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        os_log("%@", "didFinishReceivingResourceWithName")
    }
}
 
extension TransferService: MCBrowserViewControllerDelegate{
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }
    
    
}
