import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PreviewPhotoView extends StatefulWidget {
  final File file;
  final CameraController cameraController;

  const PreviewPhotoView({
    Key? key,
    required this.file,
    required this.cameraController,
  }) : super(key: key);

  @override
  _PreviewPhotoViewState createState() => _PreviewPhotoViewState();
}

class _PreviewPhotoViewState extends State<PreviewPhotoView> {
  bool isFlashOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.file(widget.file, fit: BoxFit.cover),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(
                      isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isFlashOn = !isFlashOn;
                        _toggleFlash();
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context, widget.file);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleFlash() {
    if (widget.cameraController == null) return;

    final flashMode = isFlashOn ? FlashMode.torch : FlashMode.off;
    widget.cameraController.setFlashMode(flashMode);
  }
}
