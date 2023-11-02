//
//  ShelfWatchCameraManager.swift
//
//
//  Created by Mitesh on 31/10/23.
//

import UIKit
import ShelfWatchImageRecognitionFramework

public class ShelfWatchCameraManager {
    
    private let config: CameraConfig
    private let delegate: ImageUploadDelegate
    
    public init(config: CameraConfig, delegate: ImageUploadDelegate) {
        self.config = config
        self.delegate = delegate
    }
    
    public func showCamera(viewController: UIViewController) {
        
        let configuration = CameraConfiguration(
            orientation: self.config.orientation,
            widthPercent: self.config.widthPercent,
            deeplink: self.config.deeplink,
            dimension: self.config.dimension,
            referenceurl: self.config.referenceurl,
            shouldNavigateCropReview: self.config.shouldNavigateCropReview,
            blurCheckEnabled: self.config.blurCheckEnabled,
            zoomLevel: self.config.zoomLevel,
            uploadParameterJSON: self.config.uploadParameterJSON
        )
        
        ShelfWatchCamera.show(with: configuration, viewController: viewController, delegate: self)
    }
}

extension ShelfWatchCameraManager: CameraDelegate {
    
    public func didReceiveImageUpload(_ result: UploadResult) {
        switch result {
        case .success:
            self.delegate.didReceiveImageStatus(.success)
            
        case .failure(error: let error):
            self.delegate.didReceiveImageStatus(.failure(error: error))
            
        case .progress(progress: let progress):
            self.delegate.didReceiveImageStatus(.progress(progress: progress))
            
        @unknown default:
            fatalError("\n********************\nUnhandled CameraDelegate > UploadResult Case\n********************\n")
        }
        
    }
}
