import 'package:flutter/material.dart';
import 'package:news/pages/user/register.dart';
import 'package:news/pages/user/subassembly.dart';
import 'package:provider/provider.dart';

import '../../utils/api_service.dart';
import '../../utils/auth_provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: 300,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: kToolbarHeight),
                        // 距离顶部一个工具栏的高度
                        buildTitle("登录"),
                        // Login
                        const SizedBox(height: 60),
                        buildEmailTextField(),
                        // 输入邮箱
                        const SizedBox(height: 30),
                        buildPasswordTextField(context),
                        // 输入密码
                        buildForgetPasswordText(context),
                        // 忘记密码
                        const SizedBox(height: 30),
                        buildLoginButton(context),
                        // 登录按钮
                        const SizedBox(height: 40),
                        buildRegisterText(context),
                        // 注册
                      ])),
            ],
          )),
    );
  }

  Widget buildRegisterText(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('没有账号?'),
            GestureDetector(
              child: const Text('点击注册', style: TextStyle(color: Colors.green)),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
            // 设置圆角
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text('登录', style: TextStyle(fontSize: 20)),
          onPressed: () {
            // 表单校验通过才会继续执行
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              loginUser(context, _email, _password).then((value) {
                if (value) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('登录失败', style: TextStyle(fontSize: 20)),
                  ));
                }
              });
            }
          },
        ),
      ),
    );
  }

  Widget buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            // Navigator.pop(context);
            print("忘记密码");
          },
          child: const Text("忘记密码？",
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ),
      ),
    );
  }

  Widget buildEmailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: '用户名或邮箱'),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return '请输入用户名或邮箱';
        }
        return null;
      },
      onSaved: (v) => _email = v!,
    );
  }

  Widget buildPasswordTextField(BuildContext context) {
    return PasswordTextField(
      onSaved: (v) => _password = v!,
      labelText: "请输入密码",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "密码不能为空";
        }
        return null;
      },
    );
  }

  Future<bool> loginUser(
      BuildContext context, String identifier, String password) async {
    try {
      final response = await ApiService.login(
        identifier,
        password,
      );
      String token = response['jwt'];
      // 保存到全局状态
      Provider.of<AuthProvider>(context, listen: false).setToken(token);
      Provider.of<AuthProvider>(context, listen: false).checkLoginStatus();
      return true;
    } catch (e) {
      return false;
    }
  }
}