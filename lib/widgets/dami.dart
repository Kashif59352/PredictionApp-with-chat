import 'package:flutter/material.dart';
import 'package:fypproject/module/upload_model.dart';

class Dami extends StatefulWidget {
  final UploadModel user;
  const Dami({super.key, required this.user});

  @override
  State<Dami> createState() => _DamiState();
}

class _DamiState extends State<Dami> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Preview")),
      body: Center(
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(widget.user.imageUrl ?? ""),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
