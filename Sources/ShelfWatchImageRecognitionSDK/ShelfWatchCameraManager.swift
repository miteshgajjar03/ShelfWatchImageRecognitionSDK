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
    
    private var shelfWatchCamera: ShelfWatchCamera!
    private weak var delegate: ShelfWatchDelegate?
    private var config: CameraConfig?
    public var uploadParams: [String: Any] {
        return self.config?.uploadParams ?? [:]
    }
    
    // MARK: - Initialization
    
    public init(projectId: String, userId: String, userInfo: [String: Any]? = nil, delegate: ShelfWatchDelegate, objectDetectionDelegate: ObjectDetectionDelegate) {
        
        self.delegate = delegate
        
        self.shelfWatchCamera = ShelfWatchCamera(
            projectId: projectId,
            userId: userId,
            userInfo: userInfo ?? [:],
            delegate: self,
            objectDetectionDelegate: objectDetectionDelegate
        )
    }
    
    public func showCamera(viewController: UIViewController) {
        
        guard let config = self.config else {
            fatalError("CONFIG IS NIL!! CALL setupConfig(config: ) to set camera Config")
        }
        
        let cameraConfiguration = self.prepareCameraConfiguration(from: config)
        self.shelfWatchCamera.showCamera(with: cameraConfiguration, viewController: viewController)
    }
}

// MARK: Extension

// MARK: - Setup Config

extension ShelfWatchCameraManager {
    
    public func setupConfig(config: CameraConfig) {
        self.config = config
        
        let cameraConfig = self.prepareCameraConfiguration(from: config)
        self.shelfWatchCamera.setupCamera(configuration: cameraConfig)
    }
    
    private func prepareCameraConfiguration(from config: CameraConfig) -> CameraConfiguration {
        
        let cameraConfiguration = CameraConfiguration(
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
            appName: config.appName,
            wideAngleMode:  WideAngleMode(
                flag: config.wideAngleMeta.flag,
                freeze: config.wideAngleMeta.freeze
            ),
            showSingleOverlap: config.showSingleOverlap,
            overlapImageOpacity: config.overlapImageOpacity,
            setOverlapArea: config.setOverlapArea,
            uploadParams: config.uploadParams
        )
        
        return cameraConfiguration
    }
}

// MARK: - ImageUploadDelegate

extension ShelfWatchCameraManager: ImageUploadDelegate {
    
    public func didReceiveBatchUpload(result: BatchUploadResult) {
        
        switch result {
            
        case .didReceiveBatches(batches: let batches):
            
            let pendingBatches = batches.map({
                self.getUploadBatch(from: $0)
            })
            self.delegate?.didReceiveBatch(result: .didReceiveBatches(batches: pendingBatches))
            
        case .didReceiveBatch(batch: let batch):
            
            let uploadBatch: UploadBatch = self.getUploadBatch(from: batch)
            self.delegate?.didReceiveBatch(result: .didReceiveBatch(batch: uploadBatch))
            
        case .didReceiveImageUploadStatus(imageStatus: let uploadMeta):
            
            let imageUploadStatus = ImageUploadStatusMeta(
                uri: uploadMeta.uri,
                status: uploadMeta.status,
                imageMetaData: uploadMeta.imageMetaData,
                error: uploadMeta.error
            )
            self.delegate?.didReceiveBatch(result: .didReceiveImageUploadStatus(imageStatus: imageUploadStatus))
            
        case .didFinishedUpload(finished: let finished):
            
            self.delegate?.didReceiveBatch(result: .didFinishedUpload(finished: finished))
            
        @unknown default:
            fatalError("ShelfWatchImageRecognitionSDK - UNKNOWN CASE")
        }
    }
    
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
    
    public func downloadDataProgress(progressMeta: DownloadProgressMeta, sendUpdates: Bool) {
        
        guard sendUpdates else { return }
        
        let downloadMeta = DownloadMeta(
            title: progressMeta.title,
            subTitle: progressMeta.subTitle,
            progress: progressMeta.progress,
            finished: progressMeta.finished, 
            type: progressMeta.type.value
        )
        self.delegate?.downloadDataProgress(downloadMeta: downloadMeta)
    }
    
    public func didReceivePendingARData(item: ARPendingData) {
        
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

// MARK: - Prepare UploadBatch

extension ShelfWatchCameraManager {
    
    private func getUploadBatch(from batch: ImageBatch) -> UploadBatch {
        
        let uploadBatch: UploadBatch = UploadBatch(
            sessionId: batch.sessionId,
            images: batch.images.map({
                UploadBatchMeta(
                    uri: $0.uri,
                    status: $0.status,
                    error: $0.error
                )
            })
        )
        
        return uploadBatch
    }
}

// MARK: - Log Init SDK in Framework

extension ShelfWatchCameraManager {
    
    public func logSDKInitialise(message: String) {
        self.shelfWatchCamera?.logInitSDK(logMessage: message)
    }
}

// MARK: - Unity

extension ShelfWatchCameraManager {
    
    public func sendUnityImage(image: UIImage) {
        self.shelfWatchCamera.imageFromUnity(image: image)
    }
    
    public func showInsightDashboadViewController(
        from viewController: UIViewController,
        jsonObjects: [[String: Any]],
        kpiAvailability: [String: Any]
    ) {
        
//        self.shelfWatchCamera.showInsightDashboadViewController(
//            from: viewController,
//            jsonObjects: jsonObjects,
//            skuAvailability: kpiAvailability
//        )
    }
    
    public func getKPIResult(mergedImage: UIImage, detectionJSON: [[String: Any]], completion: @escaping ((_ kpiJSON: [String: Any]) -> Void)) {
        guard let config = self.config else { fatalError("CONFIG NOT FOUND!") }
        
        self.shelfWatchCamera.getKPIResults(
            mergedImage: mergedImage,
            uploadParams: config.uploadParams,
            detectionsJSON: detectionJSON,
            completion: completion
        )
    }
    
    public func uploadARData(shopId: Int, categoryId: Int, visitDate: String) {
        self.shelfWatchCamera.uploadARData(shopId: shopId, categoryId: categoryId, visitDate: visitDate)
    }
    
    public func getPendingARData() -> ARPendingData {
        return self.shelfWatchCamera.getPendingARData()
    }
    
    public func getAnnotation(for file: String) -> [String: Any] {
        return self.shelfWatchCamera.getAnnotation(for: file)
    }
}
