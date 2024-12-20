import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ArticlePublishPage extends StatefulWidget {
  @override
  _ArticlePublishPageState createState() => _ArticlePublishPageState();
}

class _ArticlePublishPageState extends State<ArticlePublishPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  File? _coverImage;
  VideoPlayerController? _videoController;
  bool _pickedVideo = false;

  // 选择封面图像
  Future<void> _pickCoverImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _coverImage = File(result.files.single.path!);

      setState(() {});
    }
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Use VideoPlayerController.file instead of VideoPlayerController.network for local file
      print(result.files.single.path);
      _videoController = VideoPlayerController.file(File(result.files.single.path!))
        ..initialize().then((_) {
          setState(() {
            _pickedVideo = true;
          });
        });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    if (_videoController != null) {
      _videoController!.dispose(); // Dispose video controller
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("文章发布")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 标题
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "文章标题"),
            ),
            SizedBox(height: 16),

            // 简介
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "文章简介"),
              maxLines: 3,
            ),
            SizedBox(height: 16),

            // 封面
            Row(
              children: [
                _coverImage == null
                    ? Text("没有选择封面")
                    : Image.file(File(_coverImage!.path), width: 100),
                IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: _pickCoverImage,
                ),
              ],
            ),
            SizedBox(height: 16),

            // 正文
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: "文章正文"),
              maxLines: 10,
            ),
            SizedBox(height: 16),

            // 视频
            Row(
              children: [
                _pickedVideo
                    ? Text("没有选择视频")
                    : _videoController == null
                    ? CircularProgressIndicator()  // Show a loading indicator until the video is initialized
                    : SizedBox(
                  height: 200,
                  child: VideoPlayer(_videoController!),
                ),
                IconButton(
                  icon: Icon(Icons.video_library),
                  onPressed: _pickVideo,
                ),
              ],
            ),
            SizedBox(height: 16),

            // 提交按钮
            ElevatedButton(
              onPressed: () {
                // 提交文章逻辑
              },
              child: Text("发布文章"),
            ),
          ],
        ),
      ),
    );
  }
}