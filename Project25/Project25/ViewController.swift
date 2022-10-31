//
//  ViewController.swift
//  Project25
//
//  Created by 曲奕帆 on 2022/10/31.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController,
                      UINavigationControllerDelegate, // imagePicker所需,
                      UIImagePickerControllerDelegate, // imagePicer所需
                      MCSessionDelegate, // 建立MCSession所需
                      MCBrowserViewControllerDelegate // 建立MCBrowserViewController所需
{
    var images = [UIImage]()
    
    // multipeer房間的相關編號
    // displayName指的是在其他裝置上會顯示我的名稱
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
        collectionView.layer.borderWidth = 2
        collectionView.layer.borderColor = UIColor.red.cgColor
    }
    
    @objc func showConnectionPrompt(){
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func startHosting(action: UIAlertAction){
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    @objc func joinSession(action: UIAlertAction){
        let mcBrowser = MCBrowserViewController(serviceType: "hwsno", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    // numberOfItemsInSection設定Cell的數量
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // 設定Cell的內容
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = images[indexPath.item]
        cell.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            cell.widthAnchor.constraint(equalToConstant: 145),
            cell.heightAnchor.constraint(equalToConstant: 145),
            imageView.widthAnchor.constraint(equalToConstant: 145),
            imageView.heightAnchor.constraint(equalToConstant: 145)
        ])
        
        return cell
    }
    
    @objc func importPicture(){
        // 顯示imagePicker
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    // User選擇完圖片後觸發
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        // 關閉imagePicker
        dismiss(animated: true)
        
        // 從頭加入image
        images.insert(image, at: 0)
        
        /** 開始將圖片推給其他連線中的peer
         */
        guard let mcSession = mcSession else { return }
        // 確認目前有人是與我連線中的
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData(){
                do{
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    // 若傳送發生問題，彈出Alert
                    let ac = UIAlertController(title: "Send Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    /** browserViewControllerDidFinish與browserViewControllerWasCancelled
     * 為MCBrowserViewControllerDelegate所需function。
     */
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // 將接收到的圖片，在main thread推進UI中
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
}

