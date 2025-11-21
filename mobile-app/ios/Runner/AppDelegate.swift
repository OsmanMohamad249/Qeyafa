import UIKit
import Flutter
import MediaPipeTasksVision

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var poseLandmarker: PoseLandmarker?
    private var eventSink: FlutterEventSink?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let methodChannel = FlutterMethodChannel(
            name: "com.qeyafa/mediapipe",
            binaryMessenger: controller.binaryMessenger
        )
        
        let eventChannel = FlutterEventChannel(
            name: "com.qeyafa/mediapipe_stream",
            binaryMessenger: controller.binaryMessenger
        )
        
        methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            self?.handleMethodCall(call: call, result: result)
        }
        
        eventChannel.setStreamHandler(self)
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            initializeMediaPipe(call: call, result: result)
        case "processFrame":
            processFrame(call: call, result: result)
        case "startLiveStream":
            result(true)
        case "stopLiveStream":
            result(true)
        case "dispose":
            disposeMediaPipe(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initializeMediaPipe(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let modelPath = args["modelPath"] as? String else {
            result(FlutterError(code: "INIT_ERROR", message: "Invalid arguments", details: nil))
            return
        }
        
        do {
            let modelURL = Bundle.main.url(forResource: modelPath.replacingOccurrences(of: ".task", with: ""),
                                          withExtension: "task")!
            
            let baseOptions = BaseOptions(modelAssetPath: modelURL.path)
            let options = PoseLandmarkerOptions()
            options.baseOptions = baseOptions
            options.runningMode = .liveStream
            options.numPoses = (args["numPoses"] as? Int) ?? 1
            options.minPoseDetectionConfidence = Float(args["minDetectionConfidence"] as? Double ?? 0.75)
            options.minPosePresenceConfidence = Float(args["minPresenceConfidence"] as? Double ?? 0.75)
            options.minTrackingConfidence = Float(args["minTrackingConfidence"] as? Double ?? 0.7)
            
            options.poseLandmarkerLiveStreamDelegate = self
            
            poseLandmarker = try PoseLandmarker(options: options)
            result(true)
        } catch {
            result(FlutterError(code: "INIT_ERROR", 
                              message: "Failed to initialize: \(error.localizedDescription)", 
                              details: nil))
        }
    }
    
    private func processFrame(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let imageData = args["imageData"] as? FlutterStandardTypedData,
              let image = UIImage(data: imageData.data) else {
            result(FlutterError(code: "PROCESS_ERROR", message: "Invalid image data", details: nil))
            return
        }
        
        do {
            let mpImage = try MPImage(uiImage: image)
            let detectionResult = try poseLandmarker?.detect(image: mpImage)
            
            if let detectionResult = detectionResult {
                let resultMap = convertPoseResultToMap(result: detectionResult, timestamp: Date().timeIntervalSince1970 * 1000)
                result(resultMap)
            } else {
                result(nil)
            }
        } catch {
            result(FlutterError(code: "PROCESS_ERROR", 
                              message: "Error processing frame: \(error.localizedDescription)", 
                              details: nil))
        }
    }
    
    private func convertPoseResultToMap(result: PoseLandmarkerResult, timestamp: Double) -> [String: Any] {
        var landmarksList: [[String: Any]] = []
        
        if !result.landmarks.isEmpty {
            let landmarks = result.landmarks[0]
            let worldLandmarks = result.worldLandmarks[0]
            
            for i in 0..<landmarks.count {
                let landmark = landmarks[i]
                let worldLandmark = worldLandmarks[i]
                
                landmarksList.append([
                    "x": landmark.x,
                    "y": landmark.y,
                    "z": worldLandmark.z,
                    "visibility": landmark.visibility ?? 0.0
                ])
            }
        }
        
        return [
            "landmarks": landmarksList,
            "timestamp": timestamp
        ]
    }
    
    private func disposeMediaPipe(result: @escaping FlutterResult) {
        poseLandmarker = nil
        result(true)
    }
}

extension AppDelegate: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}

extension AppDelegate: PoseLandmarkerLiveStreamDelegate {
    func poseLandmarker(_ poseLandmarker: PoseLandmarker, 
                       didFinishDetection result: PoseLandmarkerResult?, 
                       timestampInMilliseconds: Int, 
                       error: Error?) {
        if let error = error {
            eventSink?(FlutterError(code: "MEDIAPIPE_ERROR", message: error.localizedDescription, details: nil))
            return
        }
        
        if let result = result {
            let resultMap = convertPoseResultToMap(result: result, timestamp: Double(timestampInMilliseconds))
            eventSink?(resultMap)
        }
    }
}

