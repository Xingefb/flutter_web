import 'package:doworking/models/model_job_cell.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:flutter/material.dart';

class ViewCollectCell extends StatefulWidget {
  ViewCollectCell({Key key, this.model, this.onTap, this.cancnel})
      : super(key: key);
  final ModelJobCell model;
  final onTap;
  final cancnel;
  _ViewCollectCellState createState() => _ViewCollectCellState();
}

class _ViewCollectCellState extends State<ViewCollectCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.only(left: 16, top: 16, right: 16),
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
                        Container(
                          padding: EdgeInsets.only(
                              left: 16, top: 5, right: 16, bottom: 22),
                          child: Row(
                            children: <Widget>[
                              Text.rich(
                                TextSpan(
                                  text: widget.model?.reword ?? '--',
                                  style: JobStyle.moneyStyle,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' 元/',
                                        style: JobStyle.moneyStateStyle),
                                    TextSpan(
                                        text: widget.model?.danwei ?? '--',
                                        style: JobStyle.moneyStateStyle),
                                  ],
                                ),
                              ),
                              Wrap(
                                children: <Widget>[
                                  _type(widget.model?.qixian ?? ''),
                                  _type(widget.model?.jiesuan ?? ''),
                                  _type(widget.model?.sex ?? '')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.cancnel();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '取消收藏',
                        style: TextStyle(color: JobColor.red, fontSize: 15),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: JobColor.red),
                        color: JobColor.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
