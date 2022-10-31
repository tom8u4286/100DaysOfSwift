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
        
        
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Connection", style: .plain, target: self, action: #selector(showConnectedDevice)),
            UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        ]
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(sendText)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt)),
        ]
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
    }
    
    // 顯示連線中裝置
    @objc func showConnectedDevice(){
        let array = mcSession.connectedPeers.map({$0.displayName})
        let ac = UIAlertController(title: "連線中裝置", message: "\(array.joined(separator: "\n"))", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    // 送出文字
    @objc func sendText(){
        let ac = UIAlertController(title: "輸入傳送文字", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default){ [weak self] _ in
            guard let text = ac.textFields?[0].text else { return }
            guard let mcSession = self?.mcSession else { return }
            
            let data = Data(text.utf8)
            do{
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                // 若傳送發生問題，彈出Alert
                let ac = UIAlertController(title: "Send Error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
        })
        self.present(ac, animated: true)
        
    }
    
    @objc func showConnectionPrompt(){
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func startHosting(action: UIAlertAction){
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    @objc func joinSession(action: UIAlertAction){
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
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
        let ac = UIAlertController(title: "斷線", message: "\(peerID.displayName)已斷線", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        switch state{
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            DispatchQueue.main.async {[weak self] in
                self?.present(ac, animated: true)
            }
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
            } else{
                let text = String(decoding: data, as: UTF8.self)
                let ac = UIAlertController(title: "接收到訊息", message: "\(text)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
        }
    }
}

