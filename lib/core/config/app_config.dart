/// Build-time configuration, supplied with `--dart-define`.
///
/// Nothing secret lives here: AdMob unit IDs are public identifiers, and the
/// defaults are Google's official *test* IDs so a fresh checkout can never
/// serve live ads by accident. See README → "Configuration".
abstract final class AppConfig {
  /// Base URL of the Cloud Functions API, e.g.
  /// `https://asia-south1-<project>.cloudfunctions.net/api`.
  /// Empty → the app runs against the in-memory demo backend.
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// `on` (default) pins TLS trust to the roots in `assets/certs/` for https API hosts.
  static const certPinning = String.fromEnvironment(
    'CERT_PINNING',
    defaultValue: 'on',
  );

  static const privacyPolicyUrl = String.fromEnvironment(
    'PRIVACY_POLICY_URL',
    defaultValue: 'https://betashield.example/privacy',
  );
  static const supportEmail = String.fromEnvironment(
    'SUPPORT_EMAIL',
    defaultValue: 'support@betashield.example',
  );

  // Google's published test ad units (Android).
  static const _testBanner = 'ca-app-pub-3940256099942544/9214589741';
  static const _testInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const _testRewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const _testAppOpen = 'ca-app-pub-3940256099942544/9257395921';

  static const admobBannerId = String.fromEnvironment(
    'ADMOB_BANNER_ID',
    defaultValue: _testBanner,
  );
  static const admobInterstitialId = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_ID',
    defaultValue: _testInterstitial,
  );
  static const admobRewardedId = String.fromEnvironment(
    'ADMOB_REWARDED_ID',
    defaultValue: _testRewarded,
  );
  static const admobAppOpenId = String.fromEnvironment(
    'ADMOB_APP_OPEN_ID',
    defaultValue: _testAppOpen,
  );

  /// Comma-separated hashed device IDs printed by the AdMob SDK in logcat.
  static const admobTestDevices = String.fromEnvironment('ADMOB_TEST_DEVICES');

  /// UMP debug geography: `eea`, `us` or empty. Only honoured with test devices.
  static const umpDebugGeography = String.fromEnvironment(
    'UMP_DEBUG_GEOGRAPHY',
  );

  static bool get useDemoBackend => apiBaseUrl.isEmpty;
  static bool get pinningEnabled =>
      apiBaseUrl.startsWith('https://') && certPinning != 'off';
  static bool get usingTestAdUnits =>
      admobBannerId == _testBanner || admobInterstitialId == _testInterstitial;

  static List<String> get testDeviceIds => admobTestDevices
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  static const deepLinkScheme = 'betashield';
}
