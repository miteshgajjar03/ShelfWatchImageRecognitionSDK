//
//  ShelfWatchCameraManager.swift
//
//
//  Created by Mitesh on 31/10/23.
//

import UIKit
import ShelfWatchImageRecognitionFramework

public class ShelfWatchCameraManager {
    
    public static func showCamera(with config: CameraConfiguration, viewController: UIViewController, delegate: CameraDelegate) {
        
        ShelfWatchCamera.show(with: config, viewController: viewController, delegate: delegate)
    }
}
