//
//  ShelfWatchCameraManager.swift
//
//
//  Created by Mitesh on 31/10/23.
//

import UIKit
import ShelfWatchImageRecognitionFramework

public class ShelfWatchCameraManager {
    
    private let licenseKey: String
    private let firebaseBucket: String
    private weak var delegate: ShelfWatchDelegate?
    
    private var shelfWatchCamera: ShelfWatchCamera!
    
    public init(licenseKey: String, firebaseBucket: String, delegate: ShelfWatchDelegate) {
        
        self.licenseKey = licenseKey
        self.firebaseBucket = firebaseBucket
        self.delegate = delegate
        
        self.shelfWatchCamera = ShelfWatchCamera(
            licenseKey: licenseKey,
            firebaseBucket: firebaseBucket,
            delegate: self
        )
    }
    
    public func showCamera(config: CameraConfig, viewController: UIViewController) {
        
        let config = CameraConfiguration(
            orientation: config.orientation,
            widthPercentage: config.widthPercentage,
            resolution: config.resolution,
            referenceUrl: config.referenceUrl,
            allowCrop: config.allowCrop,
            allowBlurCheck: config.allowBlurCheck,
            zoomLevel: config.zoomLevel,
            isRetake: config.isRetake, 
            showOverlapToggleButton: config.showOverlapToggleButton,
            uploadParams: config.uploadParams
        )
        
        shelfWatchCamera.showCamera(with: config, viewController: viewController)
    }
}

//extension ShelfWatchCameraManager: CameraDelegate {
//    
//    public func didReceiveImageUpload(_ result: UploadResult) {
//        switch result {
//        case .success:
//            self.delegate.didReceiveImageStatus(.success)
//            
//        case .failure(error: let error):
//            self.delegate.didReceiveImageStatus(.failure(error: error))
//            
//        case .progress(progress: let progress):
//            self.delegate.didReceiveImageStatus(.progress(progress: progress))
//            
//        @unknown default:
//            fatalError("\n********************\nUnhandled CameraDelegate > UploadResult Case\n********************\n")
//        }
//        
//    }
//}

extension ShelfWatchCameraManager: ImageUploadDelegate {
    
    public func didReceiveAllImages(batches: [ImageBatch]) {
        
        let pendingImages = batches.map({
            UploadBatch(
                sessionId: $0.sessionId,
                images: $0.images.map({
                    UploadBatchMeta(
                        uri: $0.uri,
                        uploadStatus: $0.uploadStatus,
                        error: $0.error
                    )
                })
            )
        })
        
        self.delegate?.didReceiveAllBatches(results: pendingImages)
    }
    
    
    public func didReceiveImage(result: BatchImageUploadResult) {
        
        switch result {
        case .batch(batch: let batch):
            
            let uploadBatch: UploadBatch = UploadBatch(
                sessionId: batch.sessionId,
                images: batch.images.map({
                    UploadBatchMeta(
                        uri: $0.uri,
                        uploadStatus: $0.uploadStatus,
                        error: $0.error
                    )
                })
            )
            
            self.delegate?.didReceiveBatch(result: .batch(batch: uploadBatch))
            
        case .batchMetaStatus(meta: let imageBatchMeta):
            
            let batchMeta = UploadBatchMeta(
                uri: imageBatchMeta.uri,
                uploadStatus: imageBatchMeta.uploadStatus,
                error: imageBatchMeta.error
            )
            
            self.delegate?.didReceiveBatch(result: .batchMetaStatus(meta: batchMeta))
            
        case .sucess(sucess: let success):
            self.delegate?.didReceiveBatch(result: .success(success: success))
            
        @unknown default:
            fatalError("FRAMEWORK'S UNHANDLED CASE")
        }
    }
    
}
