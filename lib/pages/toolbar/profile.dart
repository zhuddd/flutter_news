import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings.dart';
import '../../utils/auth_provider.dart';
import '../publish/ArticlePublishPage.dart';
import '../user/login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          profile(authProvider),
          if (authProvider.isLoggedIn) _buildLogoutTile(authProvider),
          if (!authProvider.isLoggedIn) _buildLoginTile(),
          _buildPublishTile(),
        ],
      ),
    );
  }

  // 用户信息展示
  Widget profile(AuthProvider authProvider) {
    final userInfo = authProvider.userInfo ?? {};
    return ProfileHeader(userInfo: userInfo);
  }

  // 登录按钮
  Widget _buildLoginTile() {
    return ListTile(
      leading: Icon(Icons.login),
      title: Text("登录"),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      },
    );
  }

  // 登出按钮
  Widget _buildLogoutTile(AuthProvider authProvider) {
    return ListTile(
      leading: Icon(Icons.logout),
      title: Text("退出登录"),
      onTap: () {
        authProvider.logout();
      },
    );
  }

  // 发布按钮
  Widget _buildPublishTile() {
    return ListTile(
      leading: Icon(Icons.publish),
      title: Text("发布"),
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticlePublishPage()));
        // 在此可以添加跳转到发布页面的功能
      },
    );
  }
}


class ProfileAvatar extends StatelessWidget {
  final String? profileImage;

  ProfileAvatar({this.profileImage});

  @override
  Widget build(BuildContext context) {
    return profileImage != null && profileImage!.isNotEmpty
        ? CircleAvatar(
      backgroundImage: Image.network(mediaUrl + profileImage!).image,
      radius: 35.0,
    )
        : CircleAvatar(
      backgroundColor: Colors.grey,
      radius: 35.0,
      child: Icon(Icons.person, color: Colors.white),
    );
  }
}


class ProfileDetails extends StatelessWidget {
  final String username;
  final String email;

  ProfileDetails({required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          username.isNotEmpty ? username : '未登录',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
        Text(
          email.isNotEmpty ? email : '未登录',
          style: TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ],
    );
  }
}


class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  ProfileHeader({required this.userInfo});

  @override
  Widget build(BuildContext context) {
    final username = userInfo['username'] ?? '';
    final email = userInfo['email'] ?? '';
    final profile = userInfo['profile'] ?? '';

    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      padding: EdgeInsets.zero,
      child: Align(
        alignment: FractionalOffset.bottomLeft,
        child: Container(
          height: 70.0,
          margin: EdgeInsets.only(left: 12.0, bottom: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProfileAvatar(profileImage: profile),
              Container(
                margin: EdgeInsets.only(left: 6.0),
                child: ProfileDetails(username: username, email: email),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
