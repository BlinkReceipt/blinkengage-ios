# Change Log

## 1.6.0
- **Global color palette:** Implement the new optional `color(forGlobalKey:)` method on `Theme` to define a small semantic palette that the SDK applies across all screens — without overriding every individual `AppearanceColorKey`. Available roles: `primary`, `secondary`, `success`, `warning`, `error`, `border`, `textPrimary`, `textSecondary`, `textAccent`, `background`, `surfaceBackground`, `accentBackground`, `backgroundInverse`.
- **Hard currency boost deferral:** For apps operating in hard currency mode, Google rewarded boost credits are now deferred to comply with Google's rewarded ad policy. Your `BlinkEngageRewardConfig` reward callback may receive two new context strings:
  - `"BoostCreditEarned"` — user completed the rewarded ad; credit is held until their next receipt session.
  - `"BoostCreditApplied"` — held credit is applied when the user opens a subsequent receipt summary.

## 1.5.1
- Improved stability during scan sessions by resolving potential threading issues

## 1.0.0
