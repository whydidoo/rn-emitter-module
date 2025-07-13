package com.rnemittermoduleexample

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import org.json.JSONObject

class RNHandlerEmitter : BroadcastReceiver() {



  override fun onReceive(context: Context?, intent: Intent?) {
    val action = "${context?.packageName}.RNEmitterResponse";

    if (intent != null && intent.action == "${context?.packageName}.RNEmitterSend") {
      val event = intent.getStringExtra("event")
      val data = intent.getStringExtra("data")

      val jsonObject = data?.let { JSONObject(it) }

      Log.d("com.rnemittermoduleexample.MyBroadcastReceiver", "Received event: $event, data: $jsonObject")

      val responseIntent = Intent(action)
      responseIntent.putExtra("event", event)

      when (event) {
        "RNTEST" -> {
          val testMap = mapOf(
            "result" to "result"
          )
          val jsonString = JSONObject(testMap).toString()
          responseIntent.putExtra("data", jsonString)
          context?.sendBroadcast(responseIntent)
        }
      }
    }
  }
}