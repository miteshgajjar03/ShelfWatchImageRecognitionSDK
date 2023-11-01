//
//  ImageUploadDelegate.swift
//
//
//  Created by Mitesh on 01/11/23.
//

import Foundation

public protocol ImageUploadDelegate: AnyObject {
    func didReceiveImageStatus(_ result: CameraImageUploadResult)
}


public enum CameraImageUploadResult {

    case success

    case failure(error: Error)

    case progress(progress: Float)
}
