# Beta Shield release ProGuard/R8 rules.
# The Flutter Gradle plugin already applies proguard-android-optimize.txt and
# keeps the Flutter engine itself; these rules cover the native plugins this
# app uses so shrinking/obfuscation doesn't strip anything they need at
# runtime via reflection.

# --- Firebase (Analytics, Crashlytics, Messaging) --------------------------------------
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Crashlytics needs line-number info to symbolicate stack traces, and the
# original source file name so they map back correctly.
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# --- Google Mobile Ads (AdMob) ---------------------------------------------------------
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# --- WorkManager (background outbox flush) ------------------------------------------------
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**

# --- Our own native bridge / services: invoked by name from AndroidManifest / MethodChannel ------
-keep class com.betashield.beta_shield.** { *; }

# --- Play Core (Flutter's deferred-components support probes for this at runtime) -----------------
-dontwarn com.google.android.play.core.**

# --- flutter_local_notifications: (de)serialises scheduled notifications via reflection -----------
-keep class com.dexterous.** { *; }

# --- General Kotlin/AndroidX metadata Crashlytics and reflection-based plugins rely on -------------
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes EnclosingMethod
-keepattributes InnerClasses
