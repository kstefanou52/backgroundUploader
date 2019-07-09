//
//  BackgroundSessionManager.swift
//  BackgroundDownloader
//
//  Created by  Kostis Stefanou on 23/04/2019.
//

import Foundation

public class BackgroundSessionManager: NSObject {
    
    public static let shared = BackgroundSessionManager()
    
    static let identifier = "background_session_manager_id"
    private var session: URLSession!
    
    private override init() {
        super.init()
        session = URLSession(configuration: .background(withIdentifier: BackgroundSessionManager.identifier), delegate: self, delegateQueue: nil)
    }
    
    private func createFileURL(for data: Data) -> URL? {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentDirectory.appendingPathComponent(NSUUID().uuidString).appendingPathExtension("temp")
        
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print(error)
            return nil
        }
    }
    
    private func deleteFileURL(_ fileURL: URL) {
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error)
        }
    }
    
    public func start(_ request: URLRequest, data: Data) {
        guard let fileURL = createFileURL(for: data) else { return }
        session.uploadTask(with: request, fromFile: fileURL).resume()
        
        deleteFileURL(fileURL)
    }
}

// MARK: URL Session Delegates
extension BackgroundSessionManager: URLSessionDelegate {
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print(" - session with id: '\(session.configuration.identifier ?? "")' finished : [successfully]")
    }
}

extension BackgroundSessionManager: URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error { print(" - request completed with error : \(error.localizedDescription)") }
    }
}

extension BackgroundSessionManager: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(" - request send : [successfully]")
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) { }
}
