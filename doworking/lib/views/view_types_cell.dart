import 'package:doworking/models/model_job_cell.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:flutter/material.dart';

class ViewTypesCell extends StatefulWidget {
  ViewTypesCell({Key key, this.model, this.type, this.onTap, this.onCancle, this.onLianxi})
      : super(key: key);
  final ModelJobCell model;
  final int type;
  final onTap;
  final onCancle;
  final onLianxi;
  _ViewTypesCellState createState() => _ViewTypesCellState();
}

class _ViewTypesCellState extends State<ViewTypesCell> {
  @override
  void initState() {
    super.initState();
  }

  _cancleJoin() {
    widget.onCancle();
  }

  _lianxi() {
    widget.onLianxi();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.model?.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                color: JobColor.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          '已报名',
                          style: TextStyle(
                              fontSize: 15,
                              color: JobColor.black,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16, top: 5, right: 16),
                    child: Row(
                      children: <Widget>[
                        Text.rich(
                          TextSpan(
                            text: widget.model?.reword ?? '--',
                            style: JobStyle.moneyStyle,
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' 元/', style: JobStyle.moneyStateStyle),
                              TextSpan(
                                  text: widget.model?.danwei ?? '--',
                                  style: JobStyle.moneyStateStyle),
                            ],
                          ),
                        ),
                        _type(widget.model?.qixian ?? ''),
                        _type(widget.model?.jiesuan ?? ''),
                        _type(widget.model?.sex ?? '')
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(),
                        ),
                        (widget.type == 0 || widget.type == 1)
                            ? GestureDetector(
                                onTap: () {
                                  _cancleJoin();
                                },
                                child: Container(
                                  child: Text(
                                    '取消报名',
                                    style: TextStyle(
                                        color: JobColor.red, fontSize: 15),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: JobColor.red),
                                    color: JobColor.white,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _lianxi();
                          },
                          child: Container(
                            child: Text(
                              '联系商家',
                              style: TextStyle(
                                  color: JobColor.white, fontSize: 15),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: JobColor.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _typeView() {
    switch (widget.type) {
      case 0:
        return Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(),
            ),
            GestureDetector(
              child: Container(
                child: Text(
                  '取消报名',
                  style: TextStyle(color: JobColor.red, fontSize: 15),
                ),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: JobColor.red),
                  color: JobColor.white,
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                child: Text(
                  '联系商家',
                  style: TextStyle(color: JobColor.white, fontSize: 15),
                ),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: JobColor.red,
                ),
              ),
            ),
          ],
        );
        break;
      case 1:
        return Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(),
            ),
            GestureDetector(
              child: Container(
                child: Text(
                  '取消报名',
                  style: TextStyle(color: JobColor.red, fontSize: 15),
                ),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: JobColor.red),
                  color: JobColor.white,
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                child: Text(
                  '联系商家',
                  style: TextStyle(color: JobColor.white, fontSize: 15),
                ),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: JobColor.red,
                ),
              ),
            ),
          ],
        );

        break;
      case 2:
        return Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(),
            ),
            GestureDetector(
              child: Container(
                child: Text(
                  '联系商家',
                  style: TextStyle(color: JobColor.white, fontSize: 15),
                ),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: JobColor.red,
                ),
              ),
            ),
          ],
        );
        break;
      case 3:
        return SizedBox();
        break;
      default:
    }
  }

  Container _type(String name) {
    return name.isEmpty
        ? Container()
        : Container(
            padding: EdgeInsets.only(left: 10),
            child: Container(
              color: Color(0xFFF5F5F5),
              child: Text(
                name,
                style: TextStyle(fontSize: 12, color: Color(0xFFB0B0B0)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 3),
            ),
          );
  }
}
