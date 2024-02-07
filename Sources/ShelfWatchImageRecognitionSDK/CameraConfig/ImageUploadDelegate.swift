//
//  ImageUploadDelegate.swift
//
//
//  Created by Mitesh on 01/11/23.
//

import Foundation

// MARK: ShelfWatch Protocol

public protocol ShelfWatchDelegate: AnyObject {
    
    func didReceiveBatch(result: BatchResult)
    
//    func didReceiveBatch(result: BatchUploadResult)
//    
//    func didReceiveAllBatches(results: [UploadBatch])
    
    func didCameraSDKClosed()
    
    func didImageUploadButtonPressed(uploadEventMeta: UploadEventMeta)
}

// MARK: - Protocol Result

public enum BatchResult {
    case didReceiveBatches(batches: [UploadBatch])
    case didReceiveBatch(batch: UploadBatch)
    case didReceiveImageUploadStatus(imageStatus: ImageUploadStatusMeta)
    case didFinishedUpload(finished: Bool)
}

//public enum BatchUploadResult {
//
//    case batch(batch: UploadBatch)
//
//    case imageUploadStatus(meta: ImageUploadStatusMeta)
//
//    case success(success: Bool)
//}

// MARK: - Result Meta
public struct UploadBatch {
    
    public let sessionId: String
    public let images: [UploadBatchMeta]
    
    public func toJSON() -> [String: Any] {
        
        let batchMetaArray = self.images.map({ $0.toJSON() })
        
        return [
            ImageMetaKey.sessionId: self.sessionId,
            ImageMetaKey.images: batchMetaArray
        ]
    }
}

public struct UploadBatchMeta {
    
    public let uri: String
    public let uploadStatus: Bool
    public let error: Error?
    
    public init(
        uri: String,
        uploadStatus: Bool = false,
        error: Error? = nil
    ) {
        self.uri = uri
        self.uploadStatus = uploadStatus
        self.error = error
    }
    
    public func toJSON() -> [String: Any] {
        return [
            ImageMetaKey.uri: self.uri,
            ImageMetaKey.uploadStatus: self.uploadStatus,
            ImageMetaKey.error: self.error?.localizedDescription as Any
        ]
    }
}

public struct ImageUploadStatusMeta {
    
    public let uri: String
    public let status: Bool
    public let imageMetaData: [String: String]
    public let error: Error?
    
    public init(
        uri: String,
        status: Bool,
        imageMetaData: [String: String],
        error: Error?
    ) {
        self.uri = uri
        self.status = status
        self.imageMetaData = imageMetaData
        self.error = error
    }
    
    public func toJSON() -> [String: Any] {
        return [
            ImageMetaKey.uri: self.uri,
            ImageMetaKey.status: self.status,
            ImageMetaKey.imageMetaData: self.imageMetaData,
            ImageMetaKey.error: self.error?.localizedDescription as Any
        ]
    }
    
    public func toJSONString() -> String {
        let json: [String: Any] = self.toJSON()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            return jsonString
            
        } catch {
            return ""
        }
    }
}

public struct UploadEventMeta {
    public let uploadParams: [String: Any]
    public let images: [String]
    public let isRetake: Bool
    public let sessionId: String
}

// MARK: - Image Meta JSON keys

struct ImageMetaKey {
    
    private init() { }
    
    static let sessionId = "session_id"
    static let images = "images"
    static let uri = "uri"
    static let uploadStatus = "upload_status"
    static let error = "error"
    static let status = "status"
    static let imageMetaData = "imagedata"
}
