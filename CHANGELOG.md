# Change Log

## 1.13.0

### Changed
- **Report button** — The icon-only button that opens missed earnings (receipt summary header and receipt details navigation bar) is now a text pill reading "Report".
- **Missed earnings footer** — When missed earnings is available, the **Your Earnings** section now ends with a two-line "Missing rewards? / Update your receipt" action that opens the same correction flow as the Report button.

### Breaking changes
- **Receipt button theme keys** — `AppearanceColorKey.postScanReceiptButtonIcon` is replaced by `AppearanceColorKey.postScanReceiptButtonLabel` (the button's text color), and `AppearanceIconKey.postScanReceiptButtonIcon` is removed. New optional key: `AppearanceFontNameKey.postScanReceiptButtonLabel`. The button copy is always "Report".

## 1.12.0

### Added
- **Base scan override** — When the backend returns an override for a banner, the receipt summary shows that amount instead of the host app's base scan reward. If no override is returned, the host app value is used as before.

### Changed
- **Missing merchant only** — A scan missing only the merchant no longer interrupts the user. It finalizes as a normal scan and earns as expected. The missing-fields reviewer no longer asks for merchant.
- **Missing date or total recovery** — After the user enters a missing date and/or total (or retakes the photo), the SDK continues into the standard post-scan flow (loading screen, then receipt summary) instead of stopping on the review-pending screen. Manual corrections are sent with the review request only and are not merged into the scan results. Dates outside the rewards window and totals below $0.00 are rejected in the reviewer.

### Fixed
- **Offer wall empty state flash** — Opening the offer wall no longer briefly shows "No offers available" while offers are still loading. The loading state stays until the request finishes.

## 1.11.0

### Added
- **Merchant promos** — Support for spend-based promos that reward any purchase at a given retailer. They appear on the offer wall with a SPEND $25 badge, and a promo that qualifies for a scanned receipt shows up in Your Earnings as a "Merchant Boost" row.

### Fixed
- **Dark mode backgrounds** — On devices in dark mode, the request review sheet and the manual date and field entry screens used dark system backgrounds inside their light cards, leaving the comment field, date picker, and loading spinner unreadable. These screens now stay in light mode.

## 1.10.0

### Added
- **View original receipt** — Duplicate receipts include a **View original** button to open the previously submitted receipt.
- **Request review** — Receipts flagged during scanning (duplicate, unreadable, missing information, too old, or over the scan limit) can be submitted for manual review, with an optional note. The SDK confirms the request and closes the post scan flow.
- **Missing information entry** — When a scan is missing the merchant, date, or total, users can enter the missing details manually or retake the photo, then submit the receipt for review.

### Changed
- **Duplicate receipts** — No longer shown as a blocking error. The post scan screen opens normally with a "We've seen this" status card; no rewards are offered for the duplicate scan.
- **Unreadable receipts** — A clear "We couldn't read this receipt" screen with **Submit anyway** and **Retake photo** options replaces the generic error.
- **Unverified receipts** — No longer shown as a blocking error. The post scan screen opens normally with a "Receipt couldn't be verified" status card; no rewards are offered.
- **Older receipts** — Receipts outside the rewards window show a dedicated screen with **Request review** and **Close** options instead of a generic error.
- **Scan limits** — When a submission limit is exceeded, a dedicated screen shows which limit was reached and offers **Request review**.
- **Historical receipts** — Reopened duplicate or unverified receipts show the same status card, zero rewards, and no missed earnings corrections.
- **Offer wall performance** — Faster image loading and smoother scrolling.

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
