//
//  ImageUploadDelegate.swift
//
//
//  Created by Mitesh on 01/11/23.
//

import Foundation

// MARK: ShelfWatch Protocol

public protocol ShelfWatchDelegate: AnyObject {
    
    func didReceiveBatch(result: BatchUploadResult)
    func didReceiveAllBatches(results: [UploadBatch])
}

// MARK: - Protocol Result

public enum BatchUploadResult {

    case batch(batch: UploadBatch)

    case batchMetaStatus(meta: UploadBatchMeta)

    case success(sucess: Bool)
}

// MARK: - Result Meta
public struct UploadBatch {
    
    public let sessionId: String
    public let images: [UploadBatchMeta]
    
    public func toJSON() -> [String: Any] {
        
        let batchMetaArray = self.images.map({ $0.toJSON() })
        
        return [
            "sessionId": self.sessionId,
            "images": batchMetaArray
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
            "uri": self.uri,
            "uploadStatus": self.uploadStatus,
            "error": self.error?.localizedDescription as Any
        ]
    }
}
