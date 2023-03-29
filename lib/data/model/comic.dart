import 'package:json_annotation/json_annotation.dart';
import 'package:marvel_app/data/model/comic.dart';
import 'package:marvel_app/data/model/thumbnail.dart';

part 'comic.g.dart';

@JsonSerializable(explicitToJson: true)
class Comic {
  int? id;
  String? title;
  String? description;
  String? resourceURI;
  Thumbnail? thumbnail;


  Comic({this.id, this.title, this.description, this.resourceURI, this.thumbnail});

  factory Comic.fromJson(Map<String, dynamic> json) =>
      _$ComicFromJson(json);

  Map<String, dynamic> toJson() => _$ComicToJson(this);
}

