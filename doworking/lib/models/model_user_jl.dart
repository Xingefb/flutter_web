import 'package:json_annotation/json_annotation.dart'; 
  
part 'model_user_jl.g.dart';


@JsonSerializable()
  class ModelUserJl extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'uid')
  int uid;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'sex')
  int sex;

  @JsonKey(name: 'age')
  int age;

  @JsonKey(name: 'school')
  String school;

  @JsonKey(name: 's_time')
  String sTime;

  @JsonKey(name: 'background')
  String background;

  @JsonKey(name: 'info')
  String info;

  @JsonKey(name: 'create_time')
  String createTime;

  @JsonKey(name: 'xueli')
  String xueli;

  ModelUserJl(this.id,this.uid,this.name,this.sex,this.age,this.school,this.sTime,this.background,this.info,this.createTime,this.xueli,);

  factory ModelUserJl.fromJson(Map<String, dynamic> srcJson) => _$ModelUserJlFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ModelUserJlToJson(this);

}

  
