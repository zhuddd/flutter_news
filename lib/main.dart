import 'package:flutter/material.dart';
import 'package:news/pages/news/news_page.dart';
import 'package:news/pages/toolbar/profile.dart';
import 'package:news/settings.dart';
import 'package:news/utils/auth_provider.dart';
import 'package:news/utils/http_service.dart';
import 'package:provider/provider.dart';

void main() async {
  HttpService().init(
    baseUrl: baseUrl,
    connectTimeout: 10000, // 可选
    receiveTimeout: 10000, // 可选
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context,listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '新闻展示',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新闻展示'),
      ),
      body: NewsPage(),
      drawer: Drawer(
        child: Profile(),
      ),
    );
  }
}


