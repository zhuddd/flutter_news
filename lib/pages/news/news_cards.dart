// 新闻卡片组件
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../settings.dart';
import 'news_obj.dart';

class NewsCard extends StatelessWidget {
  Article news;

  NewsCard(this.news);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (news.poster != null) ...[
            Image.network(mediaUrl+news.poster!.url),
          ],
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                if (news.author != null)
                Text(
                  '作者: ${news.author!.username}',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  news.introduction,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}