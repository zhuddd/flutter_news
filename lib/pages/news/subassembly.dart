import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

// 封面图片
class CoverImage extends StatelessWidget {
  final String imageUrl;

  CoverImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击封面图片，放大显示
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.contain,
      ),
    );
  }
}

// 作者信息
class AuthorInfo extends StatelessWidget {
  final String authorName;

  AuthorInfo({required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Text(
      '作者: $authorName',
      style: TextStyle(fontSize: 16, color: Colors.grey),
    );
  }
}

// 最后修改日期
class LastModifiedDate extends StatelessWidget {
  final String lastModifiedDate;

  LastModifiedDate({required this.lastModifiedDate});

  @override
  Widget build(BuildContext context) {
    // 将 ISO 8601 格式的时间字符串转换为 DateTime 对象
    DateTime dateTime = DateTime.parse(lastModifiedDate).toLocal();

    // 格式化时间为更友好的格式
    String formattedDate = DateFormat('yyyy年MM月dd日 HH:mm:ss').format(dateTime);

    return Text(
      '最后修改: $formattedDate',
      style: TextStyle(fontSize: 14, color: Colors.grey),
    );
  }
}

// Markdown 渲染
class MarkdownContent extends StatelessWidget {
  final String content;

  MarkdownContent({required this.content});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: content,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
    );
  }
}

// 视频播放器
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

// 视频播放器状态
class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (_videoController.value.isPlaying) {
                _videoController.pause();
              } else {
                _videoController.play();
              }
            });
          },
          child: Icon(
            _videoController.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
          ),
        ),
      ],
    )
        : Center(child: CircularProgressIndicator());
  }
}
