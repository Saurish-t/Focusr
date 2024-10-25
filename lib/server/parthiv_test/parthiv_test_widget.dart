import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ParthivTestWidget extends StatefulWidget {
  final VoidCallback onCalibrationComplete;
  final Function(double, double) onGazeValuesUpdated;

  const ParthivTestWidget({
    Key? key,
    required this.onCalibrationComplete,
    required this.onGazeValuesUpdated,
  }) : super(key: key);

  @override
  State<ParthivTestWidget> createState() => _ParthivTestWidgetState();
}

class _ParthivTestWidgetState extends State<ParthivTestWidget> {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  bool isStreaming = false;
  String streamStatus = 'Stream not started';
  int totalFrames = 0;
  CameraImage? latestImage;
  String? base64String;
  WebSocketChannel? _channel;
  IO.Socket? socket;
  double gazeX = 0.0;
  double gazeY = 0.0;
  bool isCalibrated = false;
  Timer? _debounceTimer;
  bool _isSendingImage = false;
  int calibrationTimes = 0;

  //String url =
  //    'http://10.0.2.2:5000/run?query=a'; // Use this for Android emulator
  //String url =
  //    'http://127.0.0.1:5000/run?query=a'; // Use this for iOS simulator or web
  //String url =
  //    'http://192.168.1.208:5000/run?query=a'; // Use this for physical device - query test code
  String url =
      'http://192.168.1.208:5000/upload_image'; // Use this for code to send image over flask
  String wsUrl =
      'http://192.168.1.208:5000'; // Update with your WebSocket server URL. Hotspot -> {172.20.10.1} At home->{192.168.1.208}
  String output = "";

  @override
  void initState() {
    super.initState();
    _setCameraControl();
  }

  void _processAndSendImage(CameraImage image) {
    if (_debounceTimer?.isActive ?? false) return;
    _debounceTimer =
        Timer(Duration(milliseconds: 300), () => _sendImageViaWebSocket(image));
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await cameraController!.initialize();
    if (mounted) setState(() {});

    cameraController!.startImageStream(_processAndSendImage);
  }

  void _sendImageViaWebSocket(CameraImage image) async {
    if (_isSendingImage || socket == null || !socket!.connected) return;
    _isSendingImage = true;

    try {
      // Convert CameraImage to JPEG bytes directly using platform-specific methods
      final jpegBytes = await convertCameraImageToJpeg(image);
      final base64Image = base64Encode(jpegBytes);

      socket!.emit('image', {
        'image': base64Image,
        'filename': 'image.jpg',
        'contentType': 'image/jpeg',
      });
    } catch (e) {
      print('Error sending image via WebSocket: $e');
    } finally {
      _isSendingImage = false;
    }
  }

  Future<List<int>> convertCameraImageToJpeg(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;

      final Uint8List y = image.planes[0].bytes;
      final Uint8List u = image.planes[1].bytes;
      final Uint8List v = image.planes[2].bytes;

      final img.Image rgbImage = img.Image(width: width, height: height);
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel!;

      for (int x = 0; x < width; x++) {
        for (int yCoord = 0; yCoord < height; yCoord++) {
          final int uvIndex = uvPixelStride * (x / 2).floor() +
              uvRowStride * (yCoord / 2).floor();
          final int index = yCoord * width + x;

          final int yp = y[index];
          final int up = u[uvIndex];
          final int vp = v[uvIndex];

          int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
          int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

          rgbImage.setPixelRgb(x, yCoord, r, g, b);
        }
      }
      final rotatedImage = img.copyRotate(rgbImage, angle: -90);

      final List<int> jpegBytes = img.encodeJpg(rotatedImage, quality: 90);
      return jpegBytes;
    } catch (e) {
      print('Error converting image: $e');
      return [];
    }
  }

  void _handleWebSocketResponse(dynamic data) {
    setState(() {
      output = data['output'] ?? 'No output';
    });
  }

  void _connectWebSocket() {
    socket = IO.io(wsUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();
    socket!.onConnect((_) => print('Connected to WebSocket server'));
    socket!.onDisconnect((_) => print('Disconnected from WebSocket server'));
    socket!.on('times', (data) {
      calibrationTimes = data['times'];
    });
    socket!.on('gaze_data', (data) {
      setState(() {
        print("recieved");
        double gazeX = data['gaze_x'];
        double gazeY = data['gaze_y'];
        widget.onGazeValuesUpdated(gazeX, gazeY);
      });

      if (!isCalibrated) {
        isCalibrated = true;
        widget.onCalibrationComplete();
      }
    });
  }

  Future<void> _setCameraControl() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );

        cameraController = CameraController(
          frontCamera,
          ResolutionPreset.low,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
        await cameraController!.initialize();
        setState(() {});
        _showSnackBar("Camera Initialized. Ready to use!");
      } else {
        _showSnackBar("Error: No cameras found.");
      }
    } catch (e) {
      _showSnackBar("Error: Failed to initialize camera: $e");
    }
  }

  Future<String> sendImageData() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    try {
      XFile imageFile = await cameraController!.takePicture();

      List<int> imageBytes = await imageFile.readAsBytes();

      print('Sending ${imageBytes.length} bytes');

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Server response: ${response.body}');
        throw Exception('Failed to send image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error capturing or sending image: $e');
    }
  }

  void _startImageStream() {
    if (cameraController != null &&
        cameraController!.value.isInitialized &&
        !isStreaming) {
      _connectWebSocket();
      cameraController!.startImageStream((CameraImage image) {
        setState(() {
          latestImage = image;
          totalFrames++;
          if (totalFrames % 150 == 0) {
            calibrationTimes += 1;
          }
          streamStatus =
              'Streaming: Frame $totalFrames (${image.width}x${image.height}, Times: $calibrationTimes)';
          _sendImageViaWebSocket(image);
        });
      });
      setState(() {
        isStreaming = true;
        streamStatus = 'Stream started';
      });
      _showSnackBar("Image Stream Started");
    }
  }

  void _stopImageStream() {
    if (cameraController != null && isStreaming) {
      cameraController!.stopImageStream();
      socket?.disconnect();
      setState(() {
        isStreaming = false;
        streamStatus = 'Stream stopped. Total frames: $totalFrames';
      });
      _showSnackBar("Image Stream Stopped");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildLatestImageWidget() {
    if (latestImage == null) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: latestImage!.width / latestImage!.height,
      child: CameraPreview(cameraController!),
    );
  }

  Widget _buildUi() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return isStreaming
        ? _buildLatestImageWidget()
        : CameraPreview(cameraController!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: Text(
          'Camera Stream',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 22.0,
              ),
        ),
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildUi(),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.black.withOpacity(0.5),
                      child: Text(
                        streamStatus,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Times: $calibrationTimes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Gaze X: $gazeX, Gaze Y: $gazeY',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FFButtonWidget(
                  onPressed: () {
                    setState(() {
                      if (isStreaming) {
                        _stopImageStream();
                      } else {
                        _startImageStream();
                      }
                    });
                  },
                  text: isStreaming ? 'Stop Streaming' : 'Start Streaming',
                  options: FFButtonOptions(
                    height: 40.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    color: isStreaming
                        ? Colors.red
                        : FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Inter',
                          color: Colors.white,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    setState(() {
                      output = "Capturing and sending image...";
                    });
                    try {
                      final responseData = await sendImageData();
                      print('Raw response: $responseData');

                      final decoded = jsonDecode(responseData);
                      print('Decoded data: $decoded');

                      setState(() {
                        output =
                            decoded['output'] ?? 'No output field in response';
                      });
                    } catch (e) {
                      print('Error sending or parsing data: $e');
                      setState(() {
                        output = 'Error: $e';
                      });
                    }
                  },
                  text: 'Capture and Send',
                  options: FFButtonOptions(
                    height: 40.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    color: FlutterFlowTheme.of(context).secondary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Inter',
                          color: Colors.white,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopImageStream();
    cameraController?.dispose();
    socket?.disconnect();
    super.dispose();
  }
}
