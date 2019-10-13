// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelUser _$ModelUserFromJson(Map<String, dynamic> json) {
  return ModelUser(
    json['id'] as int,
    json['tel'] as String,
    json['openid'] as String,
    json['unionid'] as String,
    json['vxname'] as String,
    json['sex'] as int,
    json['area'] as String,
    json['age'] as int,
    json['img'] as String,
    json['status'] as int,
    json['nickname'] as String,
    json['sign'] as String,
    json['email'] as String,
    json['create_time'] as String,
    json['hasjl'] as String,
  );
}

Map<String, dynamic> _$ModelUserToJson(ModelUser instance) => <String, dynamic>{
      'id': instance.id,
      'tel': instance.tel,
      'openid': instance.openid,
      'unionid': instance.unionid,
      'vxname': instance.vxname,
      'sex': instance.sex,
      'area': instance.area,
      'age': instance.age,
      'img': instance.img,
      'status': instance.status,
      'nickname': instance.nickname,
      'sign': instance.sign,
      'email': instance.email,
      'create_time': instance.createTime,
      'hasjl': instance.hasjl,
    };
