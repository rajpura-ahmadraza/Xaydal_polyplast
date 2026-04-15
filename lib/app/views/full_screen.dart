import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final List<String> images;
  final String imagePath;

  const FullScreenImage({
    super.key,
    required this.images,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          final path = images[index];

          return InteractiveViewer(
            child: Center(
              child: Image(
                image: path.startsWith('/')
                    ? FileImage(
                        File(path),
                      )
                    : MemoryImage(base64Decode(path)) as ImageProvider,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
