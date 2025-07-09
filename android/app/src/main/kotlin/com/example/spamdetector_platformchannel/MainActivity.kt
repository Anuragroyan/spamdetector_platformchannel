package com.example.spamdetector_platformchannel


import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "spam_detection"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "detectSpam") {
                val message = call.argument<String>("message") ?: ""
                val prediction = classifyMessage(message)
                result.success(prediction)
            } else {
                result.notImplemented()
            }
        }
    }

    // 🧠 Simple Naive Bayes-like spam classifier using keyword frequency
    private fun classifyMessage(text: String): String {
        val spamWords = listOf(
            "free", "win", "winner", "cash", "prize", "offer",
            "click", "subscribe", "money", "urgent", "claim"
        )
        val tokens = text.lowercase().split(" ", ".", ",", "!", "?", ":", ";", "\n")
        var spamScore = 0

        for (word in tokens) {
            if (spamWords.contains(word)) {
                spamScore++
            }
        }

        return if (spamScore >= 2) "Spam" else "Not Spam"
    }
}
