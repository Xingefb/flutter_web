import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewInputView extends StatefulWidget {
  ViewInputView(
      {Key key,
      this.onConfirm,
      @required this.msg,
      this.hintText,
      this.limitLength,
      this.onChanged})
      : super(key: key);
  final onConfirm;
  final onChanged;
  final String msg;
  final String hintText;
  final int limitLength;
  _ViewInputViewState createState() => _ViewInputViewState();
}

class _ViewInputViewState extends State<ViewInputView> {
  TextEditingController _controller = TextEditingController();
  FocusNode _node = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.msg ?? null;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.msg ?? null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xFFFAFAFA),
        ),
        height: 110,
        child: TextField(
          maxLines: 4,
          focusNode: _node,
          controller: _controller,
          textInputAction: TextInputAction.done,
          onChanged: (text) {
            widget.onConfirm(text);
          },
          onSubmitted: (text) {
            widget.onConfirm(text);
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(widget.limitLength ?? null),
          ],
          decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFA0A0A0)),
              border: InputBorder.none),
        ),
      ),
    );
  }
}
