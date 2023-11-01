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
}
