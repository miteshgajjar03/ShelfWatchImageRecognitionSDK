# iOS Camera SDK Library by ParallelDots


### Introduction

iOS camera SDK offers various camera features which can be used conveniently.

### Features

Capture Images, retake image
Zoom camera
Image blur detection
Image enhancements
Crop image and get cropped coordinates.
Overlapping previous image as per given custom % area of screen.
Upload images.

### Compatibility

iOS 13.0 and higher

### Get Started

#### Prerequisites

1. Install XCode - [download](https://developer.apple.com/xcode/)

2. Make sure the device's orientation locks off. (for Landscape mode)

#### Steps:

1. Create a new iOS project.
2. In Xcode, with your app project open, navigate to File > Add Packages.
3. In the package explorer search for ShelfWatchImageRecognitionSDK or we will provide a GitHub link to install the package.
4. In your project open `info.plist` and add below keys.
```
Privacy - Camera Usage Description
Privacy - Location When In Use Usage Description
```

5. Import the ShelfWatchImageRecognitionSDK in your ViewController.

```ruby
import ShelfWatchImageRecognitionSDK
```

6. Initialize SDK

```
class ViewController: UIViewController {

     private var cameraManager: ShelfWatchCameraManager?

     override func viewDidLoad() {
             super.viewDidLoad()

             self.cameraManager = ShelfWatchCameraManager(projectId: "{YOUR_PROJECT_ID}", userId: “{ USER_ID }”, userInfo: [String: Any]? = nil, delegate: self)
     }

}
```

##### Init parameters descriptions:

`projectId: String` - The projectId will be provided by ParallelDots.

`userId: String` - The userId is sent by the SDK client, it should be a unique identifier (UUID).

`userInfo: [String: Any]` - UserInfo is an optional argument, it will be used for project specific configuration if required.

`delegate` - Implement delegate to listen to image upload status.



7. Implement `ShelfWatchDelegate` in your ViewController to listen to updates of your uploading image and get batch images.

```ruby
func didReceiveBatch(result: BatchResult) {
    
    switch result {
      
    case .didReceiveBatches(let batches):
      let jsonArray = batches.map({ $0.toJSON() })
      print("ALL BATCHES :: ", jsonArray)
            
    case .didReceiveBatch(let batch):
      print("BATCH WISE DATA :: \(batch)")
      
    case .didReceiveImageUploadStatus(let imageStatus):
      print("IMAGE UPLOAD STATUS :: \(imageStatus)")
      
    case .didFinishedUpload(let finished):
      print("ALL IMAGES UPLOADED! \(finished)")
    }
  }
```




If SDK has pending upload images in local storage then it will return all the pending images as soon as you initialize SDK in the delegate method.

SDK also allows you to upload failed image(s) by using self.cameraManager.uploadFailedImage() and you will receive an update on delegate method.

**Delegate method breakdown:**

```
case .didReceiveBatches(let batches):

This case receives all the captured image batches. It calls multiple times
and will return an updated batch after the image is uploaded.
```


```
case .didReceiveBatch(let batch):

This case receives a single batch along with the corresponding captured images.
(In future this case will be deprecated.)
```


```
case .didReceiveImageUploadStatus(let imageStatus):

This case returns uploaded image status.
```


```
case .didFinishedUpload(let finished):```

This case returns when all the batches uploaded with success/failure result.
```

8. Open SDK Camera

```ruby
class ViewController: UIViewController {

private func showCamera() {
        
        let config = CameraConfig(
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
            wideAngleMeta: WideAngleMeta,
            uploadParams: [String: Any],
        )
        
        self.cameraManager?.showCamera(config: config, viewController: self)
    }
}
```

Parameters are described below. All parameters are required.


| Name                      | Type         | Description |
| :---                      |     :---:    |   :---      |
| orientation               | String       | Orientation of camera. Possible values are "portrait", "landscape" or "" If an empty string is passed, then SDK gives an option to select orientation at a runtime. |


| Name                      | Type         | Description |
| :---                      |     :---:    |   :---      |
| widthPercentage           | CGFloat      | Overlapped area of previous image, E.G: 20, 40, 50 It will calculate the percentage of overlap area based on screen size. |


| Name                      | Type    | Description |
| :---                      |  :---:  |   :---      |
| resolution                | CGFloat | Resolution of camera |


| Name                      | Type    | Description |
| :---                      |  :---:  |   :---      |
| referenceUrl              | String  | URL to reference image. If "" (empty string) is passed, or the image can not be fetched, then no reference image will be shown. |

| Name                      | Type    | Description |
| :---                      |  :---:  |   :---      |
| allowCrop                 | Bool    | Crop image and get crop coordinates.|


| Name                      | Type    | Description |
| :---                      |  :---:  |   :---      |
| allowBlurCheck            | Bool    | Check the blur image after capture.|


| Name                      | Type    | Description |
| :---                      |  :---:  |   :---      |
| zoomLevel                 | String  | Pass zoom level of captured image. Pass selected image zoomLevel only in case of retake image. (1.0 | 1.5 | 2.0)|


| Name                      | Type    | Description |
| :---                      |  :---:  |   :---      |
| isRetake                  | Bool    | Allow to retake the image. isRetake allows you to retake selected image. (true/false)|


| Name                      | Type    | Description |
| :---                      |  :---:  |   :---      |
| showOverlapToggleButton   | Bool    | Show/Hide direction arrow. showOverlapToggleButton allows to show/hide direction selection arrow and previous image overlap. If it’s true then you can see the toggle button at the top left corner. Once you enable it you are able to see the direction arrow and image overlaps.|


| Name                      | Type    | Description |
| :---                      |  :---:  |   :---      |
| showGridlines             | Bool    | Show/Hide gridlines on camera.|


| Name                      | Type    | Description |
| :---                      |  :---:  |   :---      |
| languageCode              | String    | Language code for localization. |

Supported Languages

```ruby
English(en)
Polish(pl)
Slovak(sk)
Arabic(ar)
Chinese-Traditional(zh-Hant)
Spanish(es)
```

| Name                      | Type    | Description |
| :---                      |  :---:  |   :---      |
| appName                   | String  | Name of the application.|


| Name                      | Type           | Description |
| :---                      |  :---:         |   :---      |
| wideAngleMeta             | WideAngleMeta  | Wide angle camera config.|
                                  

WideAngleMeta has two properties flag: Bool and freeze: Bool

`flag` - Boolean value indicates that if the device supports a wide angle camera then it will switch to wide angle mode. Default is `true`

`freeze` - Restrict users to switching between wide angle or normal mode. Default is `false`.

For default settings you can use WideAngleMeta.default



| Name                      | Type                    | Description |
| :---                      |  :---:                  |   :---      |
| uploadParams              | Dictionary<String, Any> | JSON object of image.|

Example JSON:

```ruby
{
  "shop_id": 62475 / UUID,
  "category_id": 123456 / UUID,
  "shelf_image_id": null, (Ideal planogram reference image id - Optional)
  "asset_image_id": null, (Ideal asset reference image id - Optional)
  "shelf_type": "Primary Shelf", (Optional)
  "metadata": {}, (JSON Object, Optional)
}
```

NOTE: JSON must contain at least following keys 

```
category_id - (Given by ParallelDots)
shop_id - (Client side shop id)
```

`category_id` should be present in the list of category ids shared by ParallelDots.

Only one of the three optional parameters (`shelf_type`, `shelf_image_id`, `asset_image_id`) needs to be sent, in case none are sent `shelf_type` will be sent as `Primary Shelf` by default.

Any client side data that is required to be kept in upload params can be sent in metadata key like below: {key: value}

```ruby
“metadata”: {
  "store_name": “XYZ”,
}
```
