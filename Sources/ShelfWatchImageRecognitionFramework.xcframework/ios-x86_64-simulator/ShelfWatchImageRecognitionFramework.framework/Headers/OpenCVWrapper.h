//
//  OpenCVWrapper.h
//  ShelfWatchImageRecognitionFramework
//
//  Created by Mitesh on 30/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (BOOL) isImageBlurry:(UIImage *) image;

@end

NS_ASSUME_NONNULL_END
