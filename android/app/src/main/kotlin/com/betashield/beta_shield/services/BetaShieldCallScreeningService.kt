package com.betashield.beta_shield.services

import android.telecom.Call
import android.telecom.CallScreeningService
import android.telecom.CallScreeningService.CallResponse

/**
 * Holds Android's call-screening role (Q+) so the OS recognises Beta Shield
 * as a legitimate call-protection app. It never blocks a call itself — the
 * design is a calm, informed *pause* the parent chooses, not a silent
 * rejection they never see. Ring-time detection and the actual warning are
 * driven by [MonitorService]'s phone-state listener, which also works below
 * Android Q where this service cannot be granted the role at all.
 */
class BetaShieldCallScreeningService : CallScreeningService() {
    override fun onScreenCall(callDetails: Call.Details) {
        respondToCall(callDetails, CallResponse.Builder().build())
    }
}
