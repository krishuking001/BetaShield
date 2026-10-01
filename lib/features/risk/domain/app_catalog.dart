/// Android package names the risk engine cares about. Kept in Dart (not native)
/// so the lists are unit-testable and updatable without touching Kotlin.
abstract final class AppCatalog {
  static const _payment = <String>{
    'com.phonepe.app',
    'com.google.android.apps.nbu.paisa.user', // Google Pay
    'net.one97.paytm',
    'in.org.npci.upiapp', // BHIM
    'com.dreamplug.androidapp', // CRED
    'com.mobikwik_new',
    'com.freecharge.android',
    'com.myairtelapp',
    'com.sbi.upi',
    'com.csam.icici.bank.imobile',
    'com.snapwork.hdfc',
    'com.axis.mobile',
    'com.infra.boiupi',
    'com.canarabank.mobility',
    'in.amazon.mShop.android.shopping',
    'com.whatsapp.w4b.payments',
  };

  /// package → short label sent as `meta.app` (never a free-text app name).
  static const _remoteAccess = <String, String>{
    'com.anydesk.anydeskandroid': 'anydesk',
    'com.anydesk.adcontrol.ad1': 'anydesk',
    'com.teamviewer.quicksupport.market': 'teamviewer',
    'com.teamviewer.host.market': 'teamviewer',
    'com.carriez.flutter_hbb': 'rustdesk',
    'com.sand.airmirror': 'airmirror',
    'com.sand.airdroid': 'airdroid',
    'com.microsoft.rdc.androidx': 'remote_desktop',
  };

  static bool isPaymentApp(String pkg) => _payment.contains(pkg);

  static String? remoteAccessLabel(String pkg) => _remoteAccess[pkg];

  static bool isMessagingApp(String pkg) =>
      pkg == 'com.whatsapp' ||
      pkg == 'com.whatsapp.w4b' ||
      pkg == 'com.google.android.apps.messaging' ||
      pkg == 'com.samsung.android.messaging' ||
      pkg == 'com.android.mms' ||
      pkg == 'com.miui.mms' ||
      pkg == 'org.telegram.messenger';
}
