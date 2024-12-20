import 'package:flutter/material.dart';
import 'package:news/pages/user/subassembly.dart';
import '../../utils/api_service.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}
class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _username, _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: kToolbarHeight),
                buildTitle("注册"),
                const SizedBox(height: 60),
                buildTextField("用户名", (v) => _username = v!, "请输入用户名"),
                const SizedBox(height: 30),
                buildTextField("邮箱", (v) => _email = v!, "请输入邮箱", isEmail: true),
                const SizedBox(height: 30),
                buildPasswordField(),
                const SizedBox(height: 30),
                buildPasswordConfirmationField(),
                const SizedBox(height: 30),
                buildRegisterButton(context),
                const SizedBox(height: 40),
                buildRegisterText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, Function(String) onSaved, String errorMessage, {bool isEmail = false}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return errorMessage;
        }
        if (isEmail) {
          RegExp regExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
          if (!regExp.hasMatch(v)) {
            return '请输入正确的邮箱';
          }
        }
        return null;
      },
      onSaved: (v) => onSaved(v!),
    );
  }

  Widget buildPasswordField() {
    return PasswordTextField(
      labelText: "请输入密码",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "密码不能为空";
        }
        return null;
      },
      onChanged: (value) {
        _password = value;
      },
      onSaved: (value) {
        _password = value;
      },
    );
  }

  Widget buildPasswordConfirmationField() {
    return PasswordTextField(
      labelText: "请确认密码",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "密码不能为空";
        }
        if (value != _password) {
          return "两次输入的密码不一致";
        }
        return null;
      },
    );
  }

  Widget buildRegisterButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const StadiumBorder()),
          ),
          child: Text('注册', style: TextStyle(fontSize: 20)),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              registerUser(context, _username!, _email!, _password!).then((value) {
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('注册成功', style: TextStyle(fontSize: 20)),
                  ));
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('注册失败', style: TextStyle(fontSize: 20)),
                  ));
                }
              });
            }
          },
        ),
      ),
    );
  }

  Widget buildRegisterText(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('已有账号?'),
            GestureDetector(
              child: const Text('点击登录', style: TextStyle(color: Colors.green)),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Future<bool> registerUser(BuildContext context, String username, String email, String password) async {
    try {
      final response = await ApiService.register(username, email, password);
      String token = response['jwt'];
      return true;
    } catch (e) {
      return false;
    }
  }
}