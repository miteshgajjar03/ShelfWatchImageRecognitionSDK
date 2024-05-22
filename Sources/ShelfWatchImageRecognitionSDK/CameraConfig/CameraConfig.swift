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
    let showGridlines: Bool
    let languageCode: String
    let appName: String
    let wideAngleMeta: WideAngleMeta
    let showSingleOverlap: Bool
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
        showGridlines: Bool,
        languageCode: String,
        appName: String,
        wideAngleMeta: WideAngleMeta = WideAngleMeta.default,
        showSingleOverlap: Bool,
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
        self.showGridlines = showGridlines
        self.languageCode = languageCode
        self.appName = appName
        self.wideAngleMeta = wideAngleMeta
        self.showSingleOverlap = showSingleOverlap
        self.uploadParams = uploadParams
    }
}

public struct WideAngleMeta {
    let flag: Bool
    let freeze: Bool
    
    public init(flag: Bool, freeze: Bool) {
        self.flag = flag
        self.freeze = freeze
    }
    
    public static var `default`: WideAngleMeta {
        return WideAngleMeta(flag: true, freeze: false)
    }
}
