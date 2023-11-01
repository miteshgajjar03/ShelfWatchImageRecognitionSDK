//
//  ShelfWatchCameraManager.swift
//
//
//  Created by Mitesh on 31/10/23.
//

import UIKit
import ShelfWatchImageRecognitionFramework

public class ShelfWatchCameraManager {
    
    public static func showCamera(with config: CameraConfig, viewController: UIViewController, delegate: CameraDelegate) {
        
        let configuration = CameraConfiguration(
            orientation: config.orientation,
            widthPercent: config.widthPercent,
            deeplink: config.deeplink,
            dimension: config.dimension,
            referenceurl: config.referenceurl,
            shouldNavigateCropReview: config.shouldNavigateCropReview,
            blurCheckEnabled: config.blurCheckEnabled,
            zoomLevel: config.zoomLevel,
            uploadParameterJSON: config.uploadParameterJSON
        )
        
        ShelfWatchCamera.show(with: configuration, viewController: viewController, delegate: delegate)
    }
}
