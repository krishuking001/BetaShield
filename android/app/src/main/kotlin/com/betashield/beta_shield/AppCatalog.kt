package com.betashield.beta_shield

/**
 * Mirrors `lib/features/risk/domain/app_catalog.dart`. Kept in sync manually
 * — both sides are small, explicit allow-lists, not something worth codegen.
 */
object AppCatalog {
    val PAYMENT_APPS: Set<String> = setOf(
        "com.phonepe.app",
        "com.google.android.apps.nbu.paisa.user",
        "net.one97.paytm",
        "in.org.npci.upiapp",
        "com.dreamplug.androidapp",
        "com.mobikwik_new",
        "com.freecharge.android",
        "com.myairtelapp",
        "com.sbi.upi",
        "com.csam.icici.bank.imobile",
        "com.snapwork.hdfc",
        "com.axis.mobile",
        "com.infra.boiupi",
        "com.canarabank.mobility",
        "in.amazon.mShop.android.shopping",
        "com.whatsapp.w4b.payments",
    )

    val REMOTE_ACCESS_APPS: Map<String, String> = mapOf(
        "com.anydesk.anydeskandroid" to "anydesk",
        "com.anydesk.adcontrol.ad1" to "anydesk",
        "com.teamviewer.quicksupport.market" to "teamviewer",
        "com.teamviewer.host.market" to "teamviewer",
        "com.carriez.flutter_hbb" to "rustdesk",
        "com.sand.airmirror" to "airmirror",
        "com.sand.airdroid" to "airdroid",
        "com.microsoft.rdc.androidx" to "remote_desktop",
    )

    val MESSAGING_APPS: Set<String> = setOf(
        "com.whatsapp",
        "com.whatsapp.w4b",
        "com.google.android.apps.messaging",
        "com.samsung.android.messaging",
        "com.android.mms",
        "com.miui.mms",
        "org.telegram.messenger",
    )
}
