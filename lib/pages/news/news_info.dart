import 'package:flutter/material.dart';
import 'package:news/pages/news/subassembly.dart';
import '../../settings.dart';
import '../../utils/api_service.dart';
import 'news_obj.dart';

class NewsDetailPage extends StatefulWidget {
  Article news;

  NewsDetailPage(this.news);

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 异步加载新闻数据
    _loadNewsData();
  }

  void _loadNewsData() async {
    try {
      var art = await ApiService.getOneArticle(documentId: widget.news.documentId);
      setState(() {
        widget.news = Article.fromJson(art['data']);
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('加载失败')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text("新闻详情"),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.news.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 封面
              if (widget.news.poster != null)
                CoverImage(imageUrl: mediaUrl + widget.news.poster!.url),
              SizedBox(height: 16),

              // 作者
              if (widget.news.author != null)
                AuthorInfo(authorName: widget.news.author!.username),
              SizedBox(height: 8),

              // 最后修改日期
              if (widget.news.updatedAt != null)
                LastModifiedDate(lastModifiedDate: widget.news.updatedAt!),
              SizedBox(height: 16),

              // 简介
              Text(
                widget.news.introduction,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // 视频播放
              if (widget.news.video != null)
                VideoPlayerWidget(videoUrl: mediaUrl + widget.news.video!.url),
              SizedBox(height: 16),

              // 正文，Markdown 渲染
              if (widget.news.info != null)
                MarkdownContent(content: widget.news.info!),
            ],
          ),
        ),
      ),
    );
  }
}