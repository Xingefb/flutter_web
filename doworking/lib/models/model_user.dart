import 'package:json_annotation/json_annotation.dart'; 
  
part 'model_user.g.dart';


@JsonSerializable()
  class ModelUser extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'tel')
  String tel;

  @JsonKey(name: 'openid')
  String openid;

  @JsonKey(name: 'unionid')
  String unionid;

  @JsonKey(name: 'vxname')
  String vxname;

  @JsonKey(name: 'sex')
  int sex;

  @JsonKey(name: 'area')
  String area;

  @JsonKey(name: 'age')
  int age;

  @JsonKey(name: 'img')
  String img;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'nickname')
  String nickname;

  @JsonKey(name: 'sign')
  String sign;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'create_time')
  String createTime;

  @JsonKey(name: 'hasjl')
  String hasjl;

  ModelUser(this.id,this.tel,this.openid,this.unionid,this.vxname,this.sex,this.area,this.age,this.img,this.status,this.nickname,this.sign,this.email,this.createTime,this.hasjl,);

  factory ModelUser.fromJson(Map<String, dynamic> srcJson) => _$ModelUserFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ModelUserToJson(this);

}

  
