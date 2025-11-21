package com.qeyafa.mobile

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.annotation.NonNull
import com.google.mediapipe.framework.image.BitmapImageBuilder
import com.google.mediapipe.framework.image.MPImage
import com.google.mediapipe.tasks.core.BaseOptions
import com.google.mediapipe.tasks.core.Delegate
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarker
import com.google.mediapipe.tasks.vision.poselandmarker.PoseLandmarkerResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.nio.ByteBuffer

class MediaPipePlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var context: Context
    private var poseLandmarker: PoseLandmarker? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        
        methodChannel = MethodChannel(binding.binaryMessenger, "com.qeyafa/mediapipe")
        methodChannel.setMethodCallHandler(this)
        
        eventChannel = EventChannel(binding.binaryMessenger, "com.qeyafa/mediapipe_stream")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> initialize(call, result)
            "processFrame" -> processFrame(call, result)
            "startLiveStream" -> startLiveStream(result)
            "stopLiveStream" -> stopLiveStream(result)
            "dispose" -> dispose(result)
            else -> result.notImplemented()
        }
    }

    private fun initialize(call: MethodCall, result: MethodChannel.Result) {
        try {
            val modelPath = call.argument<String>("modelPath") ?: "pose_landmarker_heavy.task"
            val delegateType = call.argument<String>("delegate") ?: "CPU"
            val numPoses = call.argument<Int>("numPoses") ?: 1
            val minDetectionConfidence = call.argument<Double>("minDetectionConfidence")?.toFloat() ?: 0.75f
            val minPresenceConfidence = call.argument<Double>("minPresenceConfidence")?.toFloat() ?: 0.75f
            val minTrackingConfidence = call.argument<Double>("minTrackingConfidence")?.toFloat() ?: 0.7f

            val delegate = when (delegateType) {
                "GPU" -> Delegate.GPU
                else -> Delegate.CPU
            }

            val baseOptions = BaseOptions.builder()
                .setDelegate(delegate)
                .setModelAssetPath(modelPath)
                .build()

            val options = PoseLandmarker.PoseLandmarkerOptions.builder()
                .setBaseOptions(baseOptions)
                .setRunningMode(RunningMode.LIVE_STREAM)
                .setNumPoses(numPoses)
                .setMinPoseDetectionConfidence(minDetectionConfidence)
                .setMinPosePresenceConfidence(minPresenceConfidence)
                .setMinTrackingConfidence(minTrackingConfidence)
                .setResultListener { detectionResult, inputImage ->
                    handlePoseResult(detectionResult, inputImage.timestampMs)
                }
                .setErrorListener { error ->
                    eventSink?.error("MEDIAPIPE_ERROR", error.message, null)
                }
                .build()

            poseLandmarker = PoseLandmarker.createFromOptions(context, options)
            result.success(true)
        } catch (e: Exception) {
            result.error("INIT_ERROR", "Failed to initialize MediaPipe: ${e.message}", null)
        }
    }

    private fun processFrame(call: MethodCall, result: MethodChannel.Result) {
        try {
            val imageData = call.argument<ByteArray>("imageData")
            val width = call.argument<Int>("width") ?: 0
            val height = call.argument<Int>("height") ?: 0

            if (imageData == null || poseLandmarker == null) {
                result.error("PROCESS_ERROR", "Invalid data or landmarker not initialized", null)
                return
            }

            val bitmap = BitmapFactory.decodeByteArray(imageData, 0, imageData.size)
            val mpImage = BitmapImageBuilder(bitmap).build()
            
            val detectionResult = poseLandmarker!!.detect(mpImage)
            val resultMap = convertPoseResultToMap(detectionResult, System.currentTimeMillis())
            
            result.success(resultMap)
        } catch (e: Exception) {
            result.error("PROCESS_ERROR", "Error processing frame: ${e.message}", null)
        }
    }

    private fun handlePoseResult(detectionResult: PoseLandmarkerResult, timestamp: Long) {
        val resultMap = convertPoseResultToMap(detectionResult, timestamp)
        eventSink?.success(resultMap)
    }

    private fun convertPoseResultToMap(result: PoseLandmarkerResult, timestamp: Long): Map<String, Any> {
        val landmarksList = mutableListOf<Map<String, Any>>()
        
        if (result.landmarks().isNotEmpty()) {
            val landmarks = result.landmarks()[0] // First person
            val worldLandmarks = result.worldLandmarks()[0] // 3D coordinates
            
            for (i in landmarks.indices) {
                val landmark = landmarks[i]
                val worldLandmark = worldLandmarks[i]
                
                landmarksList.add(mapOf(
                    "x" to landmark.x(),
                    "y" to landmark.y(),
                    "z" to worldLandmark.z(), // 3D depth
                    "visibility" to landmark.visibility().orElse(0f)
                ))
            }
        }

        return mapOf(
            "landmarks" to landmarksList,
            "timestamp" to timestamp.toDouble()
        )
    }

    private fun startLiveStream(result: MethodChannel.Result) {
        result.success(true)
    }

    private fun stopLiveStream(result: MethodChannel.Result) {
        result.success(true)
    }

    private fun dispose(result: MethodChannel.Result) {
        poseLandmarker?.close()
        poseLandmarker = null
        result.success(true)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        poseLandmarker?.close()
    }
}
