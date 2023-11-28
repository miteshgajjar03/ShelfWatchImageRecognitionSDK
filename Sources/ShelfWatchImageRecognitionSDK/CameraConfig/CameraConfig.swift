//
//  CameraConfig.swift
//  
//
//  Created by Mitesh on 01/11/23.
//

import Foundation

public struct CameraConfig {
    
    let orientation: String
    let widthPercentage: CGFloat
    let resolution: CGFloat
    let referenceUrl: String
    let allowCrop: Bool
    let allowBlurCheck: Bool
    let zoomLevel: String
    let isRetake: Bool
    let showOverlapToggleButton: Bool
    let uploadParams: [String : Any]
    
    public init(
        orientation: String,
        widthPercentage: CGFloat,
        resolution: CGFloat,
        referenceUrl: String,
        allowCrop: Bool,
        allowBlurCheck: Bool,
        zoomLevel: String,
        isRetake: Bool,
        showOverlapToggleButton: Bool,
        uploadParams: [String : Any]
    ) {
        self.orientation = orientation
        self.widthPercentage = widthPercentage
        self.resolution = resolution
        self.referenceUrl = referenceUrl
        self.allowCrop = allowCrop
        self.allowBlurCheck = allowBlurCheck
        self.zoomLevel = zoomLevel
        self.isRetake = isRetake
        self.showOverlapToggleButton = showOverlapToggleButton
        self.uploadParams = uploadParams
    }
}
