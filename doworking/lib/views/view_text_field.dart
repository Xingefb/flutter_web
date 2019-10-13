import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewTextField extends StatefulWidget {
  ViewTextField({Key key, this.onChanged, this.hintText, this.limitLength}) : super(key: key);
  final onChanged;
  final String hintText;
  final int limitLength;
  _ViewTextFieldState createState() => _ViewTextFieldState();
}

class _ViewTextFieldState extends State<ViewTextField> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
       return Theme(
      child: TextField(
        controller: _textEditingController,
        focusNode: _focusNode,
        textInputAction: TextInputAction.done,
        onSubmitted: (text) {
          widget.onChanged(text);
        },
        onChanged: (text) {
          widget.onChanged(text);
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.limitLength ?? null),
        ],
        style: TextStyle(color: Color(0xFF39393A), fontSize: 15),
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Color(0xFFC6B6B9), fontSize: 15),
            border: InputBorder.none),
      ),
      data: ThemeData(
        primaryColor: Colors.purple,
      ),
    );
  }
}