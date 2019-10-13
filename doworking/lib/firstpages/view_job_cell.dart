import 'package:doworking/models/model_job_cell.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:flutter/material.dart';

class ViewJobCell extends StatefulWidget {
  ViewJobCell({Key key, @required this.model, this.onTap}) : super(key: key);
  final ModelJobCell model;
  final onTap;
  _ViewJobCellState createState() => _ViewJobCellState();
}

class _ViewJobCellState extends State<ViewJobCell> {
  ModelJobCell model;
  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.asset('assets/images/公司@2x.png',
                              width: 18, fit: BoxFit.fitWidth),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              model?.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: JobStyle.subTitleStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        model?.title ?? '',
                        style: JobStyle.titleStyle,
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: model?.reword ?? '--',
                    style: JobStyle.moneyStyle,
                    children: <TextSpan>[
                      TextSpan(
                          text: ' 元/' + model?.danwei ?? '--',
                          style: JobStyle.moneyStateStyle)
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                height: 0.6,
                color: JobColor.line,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
