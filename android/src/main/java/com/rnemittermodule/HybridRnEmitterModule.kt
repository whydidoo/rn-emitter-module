package com.rnemittermodule

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import com.margelo.nitro.NitroModules
import com.margelo.nitro.rnemittermodule.HybridRnEmitterModuleSpec

typealias RNMessageCallback = (msg: String, data: String?) -> Unit

data class RNListener<T>(
    val id: Double,
    val callback: T
)

@SuppressLint("UnspecifiedRegisterReceiverFlag")
open class HybridRnEmitterModule: HybridRnEmitterModuleSpec() {
    private val applicationContext = NitroModules.applicationContext?.applicationContext
    private val packageName: String? = applicationContext?.packageName
    private var currentListenerId = 0.0;
    private val listeners = mutableListOf<RNListener<RNMessageCallback>>()

    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(ctx: Context?, intent: Intent?) {
            val event = intent?.getStringExtra("event") ?: return
            val data = intent.getStringExtra("data")

            listeners.forEach { it.callback(event, data) }
        }
    }

    init {
        packageName?.let {
            val filter = IntentFilter("$it.RNEmitterResponse")
            applicationContext?.registerReceiver(receiver, filter)
        }
    }

    override fun emitToNative(message: String, data: String?) {
        val action = packageName?.let { "$it.RNEmitterSend" } ?: return

        val intent = Intent(action).apply {
            putExtra("event", message)
            putExtra("data", data)
        }

        applicationContext?.sendBroadcast(intent)
    }

    override fun addNativeEventListener(callback: (event: String, data: String?) -> Unit): Double {
        currentListenerId += 1
        listeners.add(RNListener(currentListenerId, callback))
        return currentListenerId
    }

    override fun removeNativeEventListener(id: Double) {
        listeners.removeAll { it.id == id }
    }

    protected fun destroy() {
        applicationContext?.unregisterReceiver(receiver)
    }
}
