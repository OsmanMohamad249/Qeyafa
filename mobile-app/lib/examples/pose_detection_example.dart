// Example usage of VisionService for pose detection
import 'package:flutter/material.dart';
import '../core/services/vision_service.dart';

class PoseDetectionExample extends StatefulWidget {
  const PoseDetectionExample({super.key});

  @override
  State<PoseDetectionExample> createState() => _PoseDetectionExampleState();
}

class _PoseDetectionExampleState extends State<PoseDetectionExample> {
  bool _isInitialized = false;
  String _status = 'Initializing...';
  List<PoseLandmark> _currentLandmarks = [];

  @override
  void initState() {
    super.initState();
    _initializeMediaPipe();
  }

  Future<void> _initializeMediaPipe() async {
    try {
      await VisionService.instance.initialize();
      
      // Listen to pose stream
      VisionService.instance.poseStream.listen((poseResult) {
        setState(() {
          _currentLandmarks = poseResult.landmarks;
          _status = 'Detected ${poseResult.landmarks.length} landmarks';
        });
        
        // Example: Print nose position (landmark 0)
        if (poseResult.landmarks.isNotEmpty) {
          final nose = poseResult.landmarks[0];
          print('Nose: x=${nose.x.toStringAsFixed(3)}, '
                'y=${nose.y.toStringAsFixed(3)}, '
                'z=${nose.z.toStringAsFixed(3)} meters');
        }
      });

      await VisionService.instance.startLiveStream();
      
      setState(() {
        _isInitialized = true;
        _status = 'MediaPipe Ready';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    VisionService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediaPipe Pose Detection'),
      ),
      body: Column(
        children: [
          // Status indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: _isInitialized ? Colors.green : Colors.orange,
            child: Row(
              children: [
                Icon(
                  _isInitialized ? Icons.check_circle : Icons.hourglass_empty,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _status,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          
          // Landmarks count
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Tracking ${_currentLandmarks.length} landmarks',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          
          // Example: Display key landmarks
          Expanded(
            child: ListView(
              children: _buildLandmarkWidgets(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLandmarkWidgets() {
    if (_currentLandmarks.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text('No pose detected yet...'),
          ),
        ),
      ];
    }

    // Key landmark indices
    final keyLandmarks = {
      0: 'Nose',
      11: 'Left Shoulder',
      12: 'Right Shoulder',
      13: 'Left Elbow',
      14: 'Right Elbow',
      23: 'Left Hip',
      24: 'Right Hip',
      25: 'Left Knee',
      26: 'Right Knee',
    };

    return keyLandmarks.entries.map((entry) {
      final index = entry.key;
      final name = entry.value;
      
      if (index >= _currentLandmarks.length) {
        return const SizedBox.shrink();
      }
      
      final landmark = _currentLandmarks[index];
      
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            child: Text('$index'),
          ),
          title: Text(name),
          subtitle: Text(
            'X: ${landmark.x.toStringAsFixed(3)} | '
            'Y: ${landmark.y.toStringAsFixed(3)} | '
            'Z: ${landmark.z.toStringAsFixed(3)}m',
            style: const TextStyle(fontFamily: 'monospace'),
          ),
          trailing: CircularProgressIndicator(
            value: landmark.visibility,
            backgroundColor: Colors.grey[300],
          ),
        ),
      );
    }).toList();
  }
}
