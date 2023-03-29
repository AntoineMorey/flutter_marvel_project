import 'package:json_annotation/json_annotation.dart';
import 'package:marvel_app/data/model/comic.dart';
import 'package:marvel_app/data/model/thumbnail.dart';

part 'character.g.dart';

@JsonSerializable(explicitToJson: true)
class Character {
  int? id;
  String? name;
  String? description;
  String? resourceURI;
  Thumbnail? thumbnail;


  Character({this.id, this.name, this.description, this.resourceURI, this.thumbnail});

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
