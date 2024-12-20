import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../utils/api_service.dart';
import 'news_cards.dart';
import 'news_info.dart';
import 'news_obj.dart';

// 新闻页面
class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Article> _newsList = [];
  int _currentPage = 1;
  int? _pageCount;
  bool _isLoading = false;
  bool _isLoadMore = false;
  bool _isRefreshing = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadNews();
    _scrollController.addListener(_scrollListener); // 监听滚动事件
  }

  // 加载新闻
  void _loadNews() {
    if (_isLoading) return; // 防止重复加载

    setState(() {
      _isRefreshing = true; // 正在刷新
      _isLoading = true; // 正在加载数据
    });

    ApiService.getArticles().then((response) {
      print(response);
      print("response");
      List newsList = response['data'];
      setState(() {
        _newsList.clear(); // 清空新闻列表
        _newsList.addAll(newsList.map((item) {
          return Article.fromJson(item);
        }));
        Map<String, dynamic> meta = response['meta']['pagination'];
        _currentPage = meta['page']!;
        _pageCount = meta['pageCount'];
        _isRefreshing = false; // 刷新完成
        _isLoading = false; // 加载完成
      });
    });
  }

  // 加载更多
  void _loadMore() {
    if (_isLoading || _currentPage >= _pageCount!) return; // 防止重复加载

    setState(() {
      _isLoadMore = true; // 正在加载更多
      _isLoading = true; // 正在加载数据
    });

    ApiService.getArticles(page: _currentPage + 1).then((response) {
      List newsList = response['data'];
      setState(() {
        _newsList.addAll(newsList.map((item) {
          return Article.fromJson(item);
        }));
        Map<String, dynamic> meta = response['meta']['pagination'];
        _currentPage = meta['page']!;
        _pageCount = meta['pageCount'];
        _isLoadMore = false; // 加载完成
        _isLoading = false; // 加载完成
      });
    });
  }

  // 滚动监听器
  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // 滚动到底部，加载更多
      _loadMore();
      print('加载更多');
    }
    // 这里不再需要滚动到顶部时加载数据，避免重复调用 _loadNews()
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            if (_isRefreshing) Center(child: CircularProgressIndicator()),
            // 如果正在刷新，显示进度指示器
            Expanded(
              child: MasonryGridView.builder(
                controller: _scrollController, // 添加滚动控制器
                itemCount: _newsList.length,
                itemBuilder: (context, index) {
                  var news = _newsList[index];
                  return GestureDetector(
                    onTap: () {
                      // 点击卡片跳转到新闻详情页
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailPage(news),
                        ),
                      );
                    },
                    child: NewsCard(news),
                  );
                },
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 每行展示 2 列
                ),
              ),
            ),
            if (_isLoadMore)
              Center(child: CircularProgressIndicator()),
            // 如果正在加载更多，显示进度指示器
          ],
        ),
      ),
    );
  }
}