// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_user_jl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelUserJl _$ModelUserJlFromJson(Map<String, dynamic> json) {
  return ModelUserJl(
    json['id'] as int,
    json['uid'] as int,
    json['name'] as String,
    json['sex'] as int,
    json['age'] as int,
    json['school'] as String,
    json['s_time'] as String,
    json['background'] as String,
    json['info'] as String,
    json['create_time'] as String,
    json['xueli'] as String,
  );
}

Map<String, dynamic> _$ModelUserJlToJson(ModelUserJl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'name': instance.name,
      'sex': instance.sex,
      'age': instance.age,
      'school': instance.school,
      's_time': instance.sTime,
      'background': instance.background,
      'info': instance.info,
      'create_time': instance.createTime,
      'xueli': instance.xueli,
    };
