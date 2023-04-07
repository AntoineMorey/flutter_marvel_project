import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:marvel_app/data/model/thumbnail.dart';

part 'character.g.dart';

@HiveType()
@JsonSerializable(explicitToJson: true)
class Character extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? resourceURI;
  @HiveField(4)
  Thumbnail? thumbnail;


  Character({this.id, this.name, this.description, this.resourceURI, this.thumbnail});

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
