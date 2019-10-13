import 'package:doworking/utils/job_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class ViewMsgSelect extends StatefulWidget {
  ViewMsgSelect(
      {Key key,
      @required this.title,
      @required this.msg,
      @required this.data,
      this.height,
      this.onConfirm,
      @required this.hintText})
      : super(key: key);
  final String title;
  final String msg;
  final String hintText;
  final List data;
  final double height;
  final onConfirm;
  _ViewMsgSelectState createState() => _ViewMsgSelectState();
}

class _ViewMsgSelectState extends State<ViewMsgSelect> {
  String _msg;

  @override
  void initState() {
    super.initState();
    _msg = widget?.msg ?? '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  _selectMsg() {
    Picker(
        adapter: PickerDataAdapter(pickerdata: widget.data),
        itemExtent: 46,
        changeToFirst: true,
        cancelText: '取消',
        // looping: widget.type == Ctype.Sex ? false : true,
        height: 200,
        cancelTextStyle: TextStyle(fontSize: 16, color: JobColor.red),
        confirmText: '确定',
        confirmTextStyle: TextStyle(fontSize: 16, color: JobColor.red),
        footer: Container(
          height: 46,
          color: JobColor.white,
        ),
        onConfirm: (picker, list) {
          var str = widget.data[list.first];
          widget.onConfirm(str.toString());
          setState(() {
            _msg = str.toString();
          });
        },
        onSelect: (picker, index, list) {
          debugPrint(index.toString() + list.toString());
        }).showModal(this.context);
  }

  @override
  Widget build(BuildContext context) {
    _msg = widget?.msg ?? '';
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
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _selectMsg,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          (null == _msg || _msg.isEmpty)
                              ? widget.hintText
                              : _msg,
                          style: (null == _msg || _msg.isEmpty)
                              ? TextStyle(color: Color(0xFFA0A0A0))
                              : TextStyle(color: Color(0xFF39393A)),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: Color(0xFFA0A0A0),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 1),
            height: 1,
            color: Color(0xFFEBEAEA),
          ),
        ],
      ),
    );
  }
}
