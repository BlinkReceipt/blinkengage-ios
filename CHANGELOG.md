# Change Log

## 1.9.0

### Added
- **Grouped earnings** — Multiple products qualifying for the same promotion are now shown as a single earnings row instead of one row per product.
- **Offer fine print** — Offer details now include a "More Details" section with the offer's full terms.

### Changed
- **Clip failure feedback** — A "Clip failed, retry later" message is now shown when an offer fails to clip.

## 1.8.0

### Added
- **Receipt details (history reopen)** — `BlinkEngageSDK.loadReceiptDetails(forBlinkReceiptId:completion:)` returns a `ReceiptDetailsViewController` for a previously completed scan. Provide the `blinkReceiptId` from your reward callback to load a past receipt, then present it and assign `onClose` to dismiss. Missed earnings corrections are available from receipt details within 12 hours of the scan.

## 1.7.0

### Added
- **Client event callback** — Optional callback for host-app analytics covering scan start, ad loading, receipt summary, offer wall (all offers), offer detail, and offer clipped.
- **Appearance text overrides** — New `AppearanceTextKey` enum and `Theme.text(forKey:)` let host apps customize on-screen labels and button titles. Initial keys: offer wall floating action button expanded (`"Scan Receipt"` default) and collapsed (`"Scan"` default).

### Changed
- **Offer wall filtered lists** — Removed the SDK's built-in header from store- and carousel-group offer lists. The selected store or group name is shown in the navigation bar instead; push these screens from the same navigation stack as the offer wall so your host navigation bar styling applies there as well.

### Breaking changes
- **`Theme` text method** — Implement `text(forKey:)` on your `Theme` type and return `nil` for keys you do not customize.
- **Removed offer-list header theme keys** — `offerWallHeaderBackground`, `offerWallHeaderTitleLabel`, `offerWallHeaderSubtitleLabel`, `offerWallHeaderBackButtonIcon`, and the header title/subtitle font keys. Remove these from your `Theme` if present.

## 1.6.0
- **Global color palette:** Implement the new optional `color(forGlobalKey:)` method on `Theme` to define a small semantic palette that the SDK applies across all screens — without overriding every individual `AppearanceColorKey`. Available roles: `primary`, `secondary`, `success`, `warning`, `error`, `border`, `textPrimary`, `textSecondary`, `textAccent`, `background`, `surfaceBackground`, `accentBackground`, `backgroundInverse`.
- **Hard currency boost deferral:** For apps operating in hard currency mode, Google rewarded boost credits are now deferred to comply with Google's rewarded ad policy. Your `BlinkEngageRewardConfig` reward callback may receive two new context strings:
  - `"BoostCreditEarned"` — user completed the rewarded ad; credit is held until their next receipt session.
  - `"BoostCreditApplied"` — held credit is applied when the user opens a subsequent receipt summary.

## 1.5.1
- Improved stability during scan sessions by resolving potential threading issues

## 1.0.0
