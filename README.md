# BlinkEngage iOS SDK

This framework extends the [BlinkReceipt SDK](https://github.com/BlinkReceipt/blinkreceipt-ios) to enable rewards and monetization functionality. You must first install the BlinkReceipt framework according to the instructions in that repository.

## Requirements

- **iOS**: 15.0+
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
pod 'BlinkEngage', '~> 1.4.0'
```
Then run: `pod install`

## Quick Start

### Initialization
```swift
import BlinkEngage
import BlinkReceipt

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure BlinkReceipt SDK (required for scanning experience). If you don't have BOTH of these keys, talk to your Account Management team.
        BRScanManager.shared().licenseKey = "YOUR-BLINKRECEIPT-LICENSE-KEY"
        BRScanManager.shared().prodIntelKey = "YOUR-BLINKRECEIPT-PRODINTEL-KEY"

        // Enable BlinkEngage integration in BlinkReceipt
        BRScanManager.shared().enableBlinkEngage = true
        
        
        // Configure BlinkEngage SDK
        // User identification (at least one required)
        BlinkEngageSDK.shared.user.emailHash = "hashed_email_string"
        BlinkEngageSDK.shared.user.phoneHash = "hashed_phone_string"

        // Optional for extra mapping
        BlinkEngageSDK.shared.user.clientUserId = "your_client_user_id" 

        // Configure reward currency
        BlinkEngageSDK.shared.rewardConfig = BlinkEngageRewardConfig(
            currencyName: "points",
            currencyPerDollar: 100.0,
            rewardCallback: { context, rewardAmount, blinkReceiptId in
                switch context {
                case "ScanFinished":
                    return NSNumber(value: 10.0)
                case "Promo":
                    print("User earned \(rewardAmount?.doubleValue ?? 0) points from promo (receipt: \(blinkReceiptId ?? "nil"))")
                    return nil
                case "Boost":
                    print("User earned \(rewardAmount?.doubleValue ?? 0) points from boost (receipt: \(blinkReceiptId ?? "nil"))")
                    return nil
                case "BarcodeCollection":
                    print("User earned \(rewardAmount?.doubleValue ?? 0) points from barcode collection (receipt: \(blinkReceiptId ?? "nil"))")
                    return nil
                default:
                    return nil
                }
            }
        )

        // Styling: pass a custom Theme (e.g. BlinkEngageTheme from [Styling (Theme)](#styling-theme) below).
        BlinkEngageSDK.shared.appearance = Appearance(theme: BlinkEngageTheme())
        
        // Optional: Enable debug mode for development (shows test ad units)
        BlinkEngageSDK.shared.debugModeEnabled = false
        
        // Set up reward callback
        // Depending on `context`, this callback will either solicit a reward amount from the host app, which it should return as an `NSNumber`, or it will inform the host app, via the `rewardAmount` parameter, of an amount (in host app currency) that BlinkEngage awarded to the user
        BlinkEngageSDK.shared.rewardCallback = { context, scanResults, rewardAmount, blinkReceiptId in
            switch context {
            case "ScanFinished":
                return NSNumber(value: 10.0) // Base reward for scan completion; use scanResults if amount varies.
            case "Promo":
                print("User earned \(rewardAmount?.doubleValue ?? 0) points from promo (receipt: \(blinkReceiptId ?? "nil"))")
                return nil
            case "Boost":
                print("User earned \(rewardAmount?.doubleValue ?? 0) points from boost (receipt: \(blinkReceiptId ?? "nil"))")
                return nil
            case "BarcodeCollection":
                print("User earned \(rewardAmount?.doubleValue ?? 0) points from barcode collection (receipt: \(blinkReceiptId ?? "nil"))")
                return nil
            default:
                return nil
            }
        }
        return true
    }
}
```

### Styling (Theme)

Control colors, fonts, and images across the SDK (offer wall, receipt summary, loading screen, error modals, missed earnings, etc.) by implementing the `Theme` protocol and passing your theme when creating `Appearance`.

**Color resolution:** `color(forKey:)` → `color(forGlobalKey:)` (when the key maps to a semantic color role) → SDK built-in default. Per-key colors always override global colors.

```swift
class BlinkEngageTheme: NSObject, Theme {
    var isMerchantIconEnabled: Bool { true } // Load merchant logos on the Stores screen
    var globalFontMatrix: NSDictionary? {
        // Keys: NSNumber(UIFont.Weight.rawValue), values: font name String. Used when fontName(forKey:) returns nil.
        [
            NSNumber(value: UIFont.Weight.ultraLight.rawValue): "Outfit-Light",
            NSNumber(value: UIFont.Weight.thin.rawValue): "Outfit-Light",
            NSNumber(value: UIFont.Weight.light.rawValue): "Outfit-Light",
            NSNumber(value: UIFont.Weight.regular.rawValue): "Outfit-Regular",
            NSNumber(value: UIFont.Weight.medium.rawValue): "Outfit-Medium",
            NSNumber(value: UIFont.Weight.semibold.rawValue): "Outfit-SemiBold",
            NSNumber(value: UIFont.Weight.bold.rawValue): "Outfit-Bold",
            NSNumber(value: UIFont.Weight.heavy.rawValue): "Outfit-ExtraBold",
            NSNumber(value: UIFont.Weight.black.rawValue): "Outfit-Black",
        ] as NSDictionary
    }

    func color(forGlobalKey key: AppearanceGlobalColorKey) -> UIColor? {
        switch key {
        case .primary:           return UIColor(red: 0, green: 0.38, blue: 0.95, alpha: 1)
        case .secondary:         return UIColor(red: 0.4, green: 0.2, blue: 0.8, alpha: 1)
        case .success:           return .systemGreen
        case .warning:           return .systemOrange
        case .error:             return .systemRed
        case .border:            return .separator
        case .textPrimary:       return .label
        case .textSecondary:     return .secondaryLabel
        case .textAccent:        return UIColor(red: 0, green: 0.38, blue: 0.95, alpha: 1)
        case .background:        return .systemBackground
        case .surfaceBackground: return .secondarySystemBackground
        case .accentBackground:  return UIColor(red: 0, green: 0.38, blue: 0.95, alpha: 0.1)
        case .backgroundInverse: return .label
        default:                 return nil
        }
    }

    func color(forKey key: AppearanceColorKey) -> UIColor? {
        switch key {
        case .postScanHeaderBackground: return .systemBlue
        case .offerWallHeaderBackground: return .systemIndigo
        default: return nil  // Fall through to global roles (when mapped), then SDK defaults
        }
    }

    func fontName(forKey key: AppearanceFontNameKey) -> String? {
        nil  // Use SDK default fonts; or return e.g. "Outfit-Bold" for specific keys
    }

    func image(forKey key: AppearanceIconKey) -> UIImage? {
        nil
    }
}

// During setup:
BlinkEngageSDK.shared.appearance = Appearance(theme: BlinkEngageTheme())
```

See `AppearanceColorKey`, `AppearanceGlobalColorKey`, `AppearanceFontNameKey`, and `AppearanceIconKey` in the SDK headers for the complete list of customizable keys.

#### Objective-C

Adopt `Theme` from Objective-C the same way: implement `globalFontMatrix`, `colorForGlobalKey:`, `colorForKey:`, `fontNameForKey:`, and `imageForKey:`. Import the generated Swift header (e.g. `#import <BlinkEngage/BlinkEngage-Swift.h>`) for `AppearanceGlobalColorKey` constants.

```objc
@interface BlinkEngageTheme : NSObject <Theme>
@end

@implementation BlinkEngageTheme

- (BOOL)isMerchantIconEnabled {
    return YES;
}

- (NSDictionary *)globalFontMatrix {
    return @{
        @(UIFontWeightRegular): @"Outfit-Regular",
        @(UIFontWeightMedium): @"Outfit-Medium",
        @(UIFontWeightSemibold): @"Outfit-SemiBold",
        @(UIFontWeightBold): @"Outfit-Bold",
    };
}

- (UIColor *)colorForGlobalKey:(AppearanceGlobalColorKey)key {
    switch (key) {
        case AppearanceGlobalColorKeyPrimary:           return [UIColor colorWithRed:0 green:0.38 blue:0.95 alpha:1];
        case AppearanceGlobalColorKeySecondary:         return [UIColor colorWithRed:0.4 green:0.2 blue:0.8 alpha:1];
        case AppearanceGlobalColorKeySuccess:           return UIColor.systemGreenColor;
        case AppearanceGlobalColorKeyWarning:           return UIColor.systemOrangeColor;
        case AppearanceGlobalColorKeyError:             return UIColor.systemRedColor;
        case AppearanceGlobalColorKeyBorder:            return UIColor.separatorColor;
        case AppearanceGlobalColorKeyTextPrimary:       return UIColor.labelColor;
        case AppearanceGlobalColorKeyTextSecondary:     return UIColor.secondaryLabelColor;
        case AppearanceGlobalColorKeyTextAccent:        return [UIColor colorWithRed:0 green:0.38 blue:0.95 alpha:1];
        case AppearanceGlobalColorKeyBackground:        return UIColor.systemBackgroundColor;
        case AppearanceGlobalColorKeySurfaceBackground: return UIColor.secondarySystemBackgroundColor;
        case AppearanceGlobalColorKeyAccentBackground:  return [UIColor colorWithRed:0 green:0.38 blue:0.95 alpha:0.1];
        case AppearanceGlobalColorKeyBackgroundInverse: return UIColor.labelColor;
        default:                                        return nil;
    }
}

- (UIColor *)colorForKey:(AppearanceColorKey)key {
    // Use case constants from the generated Swift header (e.g. `AppearanceColorKeyPostScanHeaderBackground`).
    if (key == AppearanceColorKeyPostScanHeaderBackground) {
        return UIColor.systemBlueColor;
    }
    return nil;
}

- (NSString *)fontNameForKey:(AppearanceFontNameKey)key {
    return nil;
}

- (UIImage *)imageForKey:(AppearanceIconKey)key {
    return nil;
}

@end
```

- Return `nil` from `color(forKey:)` to fall through to global roles (when mapped), then SDK defaults.
- `color(forGlobalKey:)` / `colorForGlobalKey:` is **optional** — omit the method entirely to skip the global color tier for all keys. Return `nil` from individual cases to skip that role for just those keys.
- Return `nil` from `fontName(forKey:)` / `fontNameForKey:` or `image(forKey:)` / `imageForKey:` for SDK defaults there.
- Use `AppearanceColorKey`, `AppearanceGlobalColorKey`, `AppearanceFontNameKey`, and `AppearanceIconKey` (see SDK headers) for the full list of customizable keys.
- To use default styling, pass `Appearance(theme: nil)` or `Appearance()`.

### Presenting Offer Wall
```swift
class YourViewController: UIViewController {
    
    func displayOfferWall() {
        // Show all offers (default), or use .clipped to show only offers the user has clipped
        let offerWallViewController = OffersWallViewController(offerWallViewType: .all)
        offerWallViewController.delegate = self
        present(offerWallViewController, animated: true)
    }
}

extension YourViewController: OffersWallViewControllerDelegate {
    // We’ll present a floating “Scan Receipt” action button and this callback will be triggered if the user clicks it.
    func offerWallDidSelectFloatingAction(_ viewController: OffersWallViewController) {
        // Handle floating action button tap
    }
    
    // A floating help icon will be presented to the user at X, Y and Z points in the journey
    func offerWallShouldDisplayFloatingAction(_ viewController: OffersWallViewController) -> Bool {
        return true // or false to hide floating action
    }
    
    // Called when the offer list loads or when the user clips/unclips an offer. Use the count to update a badge or other UI.
    func offerWall(_ viewController: OffersWallViewController, didUpdateClippedOffersCount count: Int) {
        tabBarItem.badgeValue = count > 0 ? "\(count)" : nil
    }
}
```

**Clipped count delegate:** Implement `offerWall(_:didUpdateClippedOffersCount:)` to be notified when the number of clipped offers changes (initial load, clip, or unclip). Use it to show a badge on a tab or button without polling.

```swift
// Example: update a tab bar badge or custom label when clipped count changes
func offerWall(_ viewController: OffersWallViewController, didUpdateClippedOffersCount count: Int) {
    tabBarItem.badgeValue = count > 0 ? "\(count)" : nil
    // or: clippedCountLabel.text = "\(count) saved"
}
```

**Offer wall view types:**
- **`.all`** — Show all offers (default).
- **`.clipped`** — Show only offers the user has clipped.

**All offers (default):**
```swift
let offerWall = OffersWallViewController(offerWallViewType: .all)
offerWall.delegate = self
present(offerWall, animated: true)
```

**Clipped offers only:**
```swift
let clippedWall = OffersWallViewController(offerWallViewType: .clipped)
clippedWall.delegate = self
present(clippedWall, animated: true)
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