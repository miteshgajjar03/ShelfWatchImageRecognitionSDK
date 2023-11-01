//
//  CameraConfig.swift
//  
//
//  Created by Mitesh on 01/11/23.
//

import Foundation

public struct CameraConfig {
    
    let orientation: String
    let widthPercent: CGFloat
    let deeplink: String
    let dimension: CGFloat
    let referenceurl: String
    let shouldNavigateCropReview: Bool
    let blurCheckEnabled: Bool
    let zoomLevel: String
    let uploadParameterJSON: [String : Any]
    
    public init(orientation: String, widthPercent: CGFloat, deeplink: String, dimension: CGFloat, referenceurl: String, shouldNavigateCropReview: Bool, blurCheckEnabled: Bool, zoomLevel: String, uploadParameterJSON: [String : Any]) {
        self.orientation = orientation
        self.widthPercent = widthPercent
        self.deeplink = deeplink
        self.dimension = dimension
        self.referenceurl = referenceurl
        self.shouldNavigateCropReview = shouldNavigateCropReview
        self.blurCheckEnabled = blurCheckEnabled
        self.zoomLevel = zoomLevel
        self.uploadParameterJSON = uploadParameterJSON
    }
}
