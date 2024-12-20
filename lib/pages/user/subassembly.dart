import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildTitle( String title) {
  return  Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        title,
        style: TextStyle(fontSize: 42),
      ));
}

class PasswordTextField extends StatefulWidget {
  final String labelText; // 标签文本
  final FormFieldSetter<String>? onSaved; // 保存回调
  final FormFieldValidator<String>? validator; // 验证规则
  final ValueChanged<String>? onChanged; // 修改回调

  const PasswordTextField({
    Key? key,
    this.labelText = "密码",
    this.onSaved,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscure = true; // 是否隐藏密码
  Color _eyeColor = Colors.grey; // 图标颜色

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      obscureText: _isObscure,
      onSaved: widget.onSaved,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: _eyeColor,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
              _eyeColor = _isObscure
                  ? Colors.grey
                  : Theme.of(context).iconTheme.color!;
            });
          },
        ),
      ),
    );
  }
}
