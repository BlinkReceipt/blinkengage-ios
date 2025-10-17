# BlinkEngage iOS SDK

This framework extends the [BlinkReceipt SDK](https://github.com/BlinkReceipt/blinkreceipt-ios) to enable rewards and monetization functionality. You must first install the BlinkReceipt framework according to the instructions in that repository.

## Requirements

- **iOS**: 13.0+
- **Swift**: 5.9+
- **Xcode**: 16.4+
- **Dependencies**: Google-Mobile-Ads-SDK, BlinkReceipt SDK
- **Complete the BlinkReceipt integration for receipt scanning**: https://blinkreceipt.github.io/blinkreceipt-ios/

## Installation

### Swift Package Manager (Recommended)
1. In Xcode, go to **File > Add Package Dependencies**
2. Enter: `https://github.com/BlinkReceipt/blinkengage-ios`
3. Select latest version and add **BlinkEngage** product

### CocoaPods
```ruby
pod 'BlinkEngage', '~> 1.0.0'
```
Then run: `pod install`

## Quick Start

### Initialization
```swift
import BlinkEngage
import BlinkReceipt

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure BlinkReceipt SDK (required for scanning experience)
        BRScanManager.shared().licenseKey = "YOUR-BLINKRECEIPT-LICENSE-KEY"
        // Enable BlinkEngage integration in BlinkReceipt
        BRScanManager.shared().enableBlinkEngage = true
        
        
        // Configure BlinkEngage SDK
        // User identification (at least one required)
        BlinkEngageSDK.shared.user.emailHash = "hashed_email_string"
        BlinkEngageSDK.shared.user.phoneHash = "hashed_phone_string"

        // Optional for extra mapping
        BlinkEngageSDK.shared.user.clientUserId = "your_client_user_id" 

        BlinkEngageSDK.shared.rewardCurrencyName = "points"
        BlinkEngageSDK.shared.rewardCurrencyPerDollar = 100.0

         // Optional: set to nil to show rewardCurrencyName instead
        BlinkEngageSDK.shared.rewardCurrencyIcon = UIImage(named: "coin_icon")
        
        // Customize default appearance
        // Additional Offer Wall customizations can be provided via the available delegate methods
        BlinkEngageSDK.shared.appearance.offerWallHeaderBackgroundColor = .systemBlue
        BlinkEngageSDK.shared.appearance.offerWallHeaderTextColor = .white
        BlinkEngageSDK.shared.appearance.receiptSummaryHeaderBackgroundColor = .systemGreen
        BlinkEngageSDK.shared.appearance.receiptSummaryHeaderTextColor = .white
        
        // Set up reward callback
        // Depending on `context`, this callback will either solicit a reward amount from the host app, which it should return as an `NSNumber`, or it will inform the host app, via the `rewardAmount` parameter, of an amount (in host app currency) that BlinkEngage awarded to the user
        BlinkEngageSDK.shared.rewardCallback = { context, scanResults, rewardAmount in
            switch context {
            if context == "ScanFinished" {
                // Return base reward value for scan completion, if any.
                // Use `scanResults` if the reward amount varies dynamically depending on receipt information.
                return NSNumber(value: 10.0) // Return base rewards value
            } else if context == "Promo" {
                // Handle promotional rewards. No return value is required
                print("User earned \(rewardAmount?.doubleValue ?? 0) points from promo")
            } else if context == "Boost" {
                // Handle boost rewards. No return value is required
                print("User earned \(rewardAmount?.doubleValue ?? 0) points from boost")
            }
            return nil
        }
        return true
    }
}
```

### Presenting Offer Wall
```swift
class YourViewController: UIViewController {
    
    func displayOfferWall() {
        let offerWallViewController = OffersWallViewController()
        offerWallViewController.delegate = self
        present(offerWallViewController, animated: true)
    }
}

extension YourViewController: OffersWallViewControllerDelegate {
    func offerWallShouldDisplayHeaderView(_ viewController: OffersWallViewController) -> Bool {
        return true // or false to hide header
    }
    
    // Optional delegate methods
    
    // Customize the title of the Offer Wall
    func offerWallHeaderTitle(_ viewController: OffersWallViewController) -> String? {
        return "My Offers"
    }
    
    // We’ll present a floating “Scan Receipt” action button and this callback will be triggered if the user clicks it.
    func offerWallDidSelectFloatingAction(_ viewController: OffersWallViewController) {
        // Handle floating action button tap
    }
    
    // A floating help icon will be presented to the user at X, Y and Z points in the journey
    func offerWallShouldDisplayFloatingAction(_ viewController: OffersWallViewController) -> Bool {
        return true // or false to hide floating action
    }
}
```

### Receipt Scanning Flow
```swift

class YourViewController: UIViewController {
    
    func scanReceipt() {
        let scanOptions = BRScanOptions()
        
        BRScanManager.shared().startStaticCamera(
            from: self,
            cameraType: .standard,
            scanOptions: scanOptions,
            with: self
        )
    }
}

```
------

Copyright (c) 2025 Actual. All rights reserved.