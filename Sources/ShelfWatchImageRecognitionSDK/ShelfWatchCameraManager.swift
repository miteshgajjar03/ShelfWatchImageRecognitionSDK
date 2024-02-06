//
//  ShelfWatchCameraManager.swift
//
//
//  Created by Mitesh on 31/10/23.
//

import UIKit
import ShelfWatchImageRecognitionFramework

public class ShelfWatchCameraManager {
    
    // MARK: - Properties
    
    private let licenseKey: String
    private let firebaseBucket: String

    private var shelfWatchCamera: ShelfWatchCamera!
    private weak var delegate: ShelfWatchDelegate?
    
    // MARK: - Initialization
    
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
            showGridlines: config.showGridlines, 
            languageCode: config.languageCode,
            uploadParams: config.uploadParams
        )
        
        shelfWatchCamera.showCamera(with: config, viewController: viewController)
    }
}

// MARK: Extension

// MARK: - Send Event

extension ShelfWatchCameraManager: ImageUploadDelegate {
    
    public func didCloseCameraSDK() {
        self.delegate?.didCameraSDKClosed()
    }
    
    public func onUploadImagePressed(uploadImageEventMeta: UploadImageEventMeta) {
        
        let uploadEventMeta = UploadEventMeta(
            uploadParams: uploadImageEventMeta.uploadParams,
            images: uploadImageEventMeta.images,
            isRetake: uploadImageEventMeta.isRetake,
            sessionId: uploadImageEventMeta.sessionId
        )
        
        self.delegate?.didImageUploadButtonPressed(uploadEventMeta: uploadEventMeta)
    }
    
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
            
        case .batchImageUploadStatus(meta: let uploadMeta):
            
            let uploadStatusMeta = ImageUploadStatusMeta(
                uri: uploadMeta.uri,
                status: uploadMeta.status,
                imageMetaData: uploadMeta.imageMetaData,
                error: uploadMeta.error
            )
            
            self.delegate?.didReceiveBatch(result: .imageUploadStatus(meta: uploadStatusMeta))
            
        case .sucess(sucess: let success):
            self.delegate?.didReceiveBatch(result: .success(success: success))
            
        @unknown default:
            fatalError("FRAMEWORK'S UNHANDLED CASE")
        }
    }
}

// MARK: - Receive Event From React Native

extension ShelfWatchCameraManager {
    
    public
    func uploadFailedImage() {
        self.shelfWatchCamera.uploadFailedImage()
    }
    
    public
    func logout() {
        self.shelfWatchCamera.logout()
    }
    
}
