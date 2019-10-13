import 'package:json_annotation/json_annotation.dart'; 
  
part 'model_job_cell.g.dart';


@JsonSerializable()
  class ModelJobCell extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'gid')
  int gid;

  @JsonKey(name: 'pid')
  int pid;

  @JsonKey(name: 'order')
  int order;

  @JsonKey(name: 'pic')
  String pic;

  @JsonKey(name: 'contace')
  String contace;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'danwei')
  String danwei;

  @JsonKey(name: 'reword')
  String reword;

  @JsonKey(name: 'jiesuan')
  String jiesuan;

  @JsonKey(name: 'qixian')
  String qixian;

  @JsonKey(name: 'sex')
  String sex;

  @JsonKey(name: 'b_pic')
  String bPic;

  @JsonKey(name: 'num')
  int num;

  @JsonKey(name: 't_time')
  String tTime;

  @JsonKey(name: 't_address')
  String tAddress;

  @JsonKey(name: 'info')
  String info;

  @JsonKey(name: 'mark')
  String mark;

  @JsonKey(name: 'create_time')
  String createTime;

  @JsonKey(name: 'collect')
  int collect;

  @JsonKey(name: 'join')
  int join;

  ModelJobCell(this.id,this.name,this.gid,this.pid,this.order,this.pic,this.contace,this.title,this.danwei,this.reword,this.jiesuan,this.qixian,this.sex,this.bPic,this.num,this.tTime,this.tAddress,this.info,this.mark,this.createTime,this.collect,this.join,);

  factory ModelJobCell.fromJson(Map<String, dynamic> srcJson) => _$ModelJobCellFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ModelJobCellToJson(this);

}

  
