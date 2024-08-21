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
    
    public func downloadDataProgress(progressMeta: DownloadProgressMeta) {
        
        let downloadMeta = DownloadMeta(
            title: progressMeta.title,
            subTitle: progressMeta.subTitle,
            progress: progressMeta.progress,
            finished: progressMeta.finished, 
            type: progressMeta.type.value
        )
        self.delegate?.downloadDataProgress(downloadMeta: downloadMeta)
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
        mergedImage: UIImage,
        jsonObjects: [[String: Any]],
        kpiAvailability: [String: Any]
    ) {
        
        self.shelfWatchCamera.showInsightDashboadViewController(
            from: viewController,
            mergedImage: mergedImage,
            jsonObjects: jsonObjects,
            skuAvailability: kpiAvailability
        )
    }
    
    public func uploadARImage(mergedImage: UIImage, detections: [[String: Any]]) {
        
        guard let config = self.config else { return }
        let cameraConfiguration = self.prepareCameraConfiguration(from: config)
        self.shelfWatchCamera.uploadARImage(
            config: cameraConfiguration,
            mergedImage: mergedImage,
            detectionJSON: detections
        )
    }
    
    public func calculateKPI(mergedImage: UIImage, detectionJSON: [[String: Any]]) -> String {
        guard let config = self.config else { return "CONFIG NOT FOUND!" }
        print("UPLOAD PARAM SEND TO NATIVE FOR KPI :: \(config.uploadParams)")
        if
            let metaData = config.uploadParams["metadata"] as? [String : Any],
              let planogramName = metaData["planogram_name"] as? String 
        {
            print("PLANOGRAM NAME :: \(planogramName)")
        }
        
        let jsonString = self.shelfWatchCamera.getKPICalculationResult(uploadParams: config.uploadParams, mergedImage: mergedImage, detectionsJSON: detectionJSON)
        return jsonString
    }
}
