import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewMsgInput extends StatefulWidget {
  ViewMsgInput(
      {Key key,
      @required this.title,
      @required this.msg,
      this.height,
      this.onConfirm,
      @required this.hintText,
      this.limitLength,
      this.onChanged})
      : super(key: key);
  final String title;
  final String msg;
  final int limitLength;
  final String hintText;
  final double height;
  final onConfirm;
  final onChanged;
  _ViewMsgInputState createState() => _ViewMsgInputState();
}

class _ViewMsgInputState extends State<ViewMsgInput> {
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
      height: widget?.height ?? 60,
      child: Column(
        children: <Widget>[
          Container(
            height: (widget?.height ?? 60) - 1,
            child: Row(
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 14, color: Color(0xFF39393A)),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    focusNode: _node,
                    controller: _controller,
                    style: TextStyle(fontSize: 14, color: Color(0xFF39393A)),
                    textAlign: TextAlign.right,
                    textInputAction: TextInputAction.done,
                    onChanged: (text) {
                      widget.onConfirm(text);
                    },
                    onSubmitted: (text) {
                      widget.onConfirm(text);
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                          widget.limitLength ?? null),
                    ],
                    decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle:
                            TextStyle(fontSize: 14, color: Color(0xFFA0A0A0)),
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 0),
            height: 1,
            color: Color(0xFFEBEAEA),
          ),
        ],
      ),
    );
  }
}
