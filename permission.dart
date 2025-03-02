import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:app_usage/app_usage.dart';

// Function to request Camera and Microphone permissions
Future<void> requestPermissions() async {
  PermissionStatus cameraStatus = await Permission.camera.request();
  PermissionStatus microphoneStatus = await Permission.microphone.request();

  if (cameraStatus.isGranted && microphoneStatus.isGranted) {
    print("Permissions granted");
  } else {
    print("Permissions denied");
  }
}

// Function to check if the camera is currently in use
Future<bool> isCameraInUse() async {
  try {
    final List<CameraDescription> cameras = await availableCameras();
    return cameras.isNotEmpty;
  } catch (e) {
    print("Error checking camera usage: \$e");
    return false;
  }
}

// Function to check for suspicious apps using the camera or microphone
Future<void> checkRunningApps() async {
  try {
    List<AppUsageInfo> usageList = await AppUsage().getUsage(
      DateTime.now().subtract(Duration(minutes: 5)),
      DateTime.now(),
    );

    for (var app in usageList) {
      if (app.packageName.contains("camera") || app.packageName.contains("record")) {
        print("Suspicious App Detected: \${app.packageName}");
        // Implement further action like alerting the user
      }
    }
  } catch (e) {
    print("Error checking running apps: \$e");
  }
}
