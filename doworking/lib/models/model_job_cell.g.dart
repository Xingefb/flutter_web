// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_job_cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelJobCell _$ModelJobCellFromJson(Map<String, dynamic> json) {
  return ModelJobCell(
    json['id'] as int,
    json['name'] as String,
    json['gid'] as int,
    json['pid'] as int,
    json['order'] as int,
    json['pic'] as String,
    json['contace'] as String,
    json['title'] as String,
    json['danwei'] as String,
    json['reword'] as String,
    json['jiesuan'] as String,
    json['qixian'] as String,
    json['sex'] as String,
    json['b_pic'] as String,
    json['num'] as int,
    json['t_time'] as String,
    json['t_address'] as String,
    json['info'] as String,
    json['mark'] as String,
    json['create_time'] as String,
    json['collect'] as int,
    json['join'] as int,
  );
}

Map<String, dynamic> _$ModelJobCellToJson(ModelJobCell instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gid': instance.gid,
      'pid': instance.pid,
      'order': instance.order,
      'pic': instance.pic,
      'contace': instance.contace,
      'title': instance.title,
      'danwei': instance.danwei,
      'reword': instance.reword,
      'jiesuan': instance.jiesuan,
      'qixian': instance.qixian,
      'sex': instance.sex,
      'b_pic': instance.bPic,
      'num': instance.num,
      't_time': instance.tTime,
      't_address': instance.tAddress,
      'info': instance.info,
      'mark': instance.mark,
      'create_time': instance.createTime,
      'collect': instance.collect,
      'join': instance.join,
    };
