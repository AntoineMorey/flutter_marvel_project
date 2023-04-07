import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marvel_app/data/endpoint/characters_endpoint.dart';
import 'package:marvel_app/data/model/character.dart';
import 'package:marvel_app/infrastructure/injections/injector.dart';
import 'package:marvel_app/infrastructure/services/connectivity_service.dart';
import 'package:provider/provider.dart';

import '../../data/model/comic.dart';

class DetailsViewModel extends ChangeNotifier {
  final CharacterEndpoint characterEndpoint;
  final ConnectivityServive _connectivityServive;
  final int characterId;
  Character? character;
  bool isLoading = true;
  List<Comic>? comics;
  bool isFavorite = false;


  DetailsViewModel._(this._connectivityServive, {required this.characterEndpoint, required this.characterId});

  static ChangeNotifierProvider<DetailsViewModel> buildWithProvider(
      {required Widget Function(BuildContext context, Widget? child)? builder, required int id,
      Widget? child}) {
    return ChangeNotifierProvider<DetailsViewModel>(
      create: (BuildContext context) => DetailsViewModel._(
        injector<ConnectivityServive>(),
        characterEndpoint: injector<CharacterEndpoint>(),
        characterId: id,
      )..loadCharacter(id)
      ..loadComics(id),
      builder: builder,
      lazy: false,
      child: child,
    );
  }

  Future<void> loadCharacter(int id) async {
    try {
      final responseDto = await characterEndpoint.getCharacterById(id);
      final charactersJson = responseDto.data['results'] as List<dynamic>;
      character = charactersJson.map((json) => Character.fromJson(json)).first;
      await Hive.initFlutter();
      var box = await Hive.openBox('favorite_spot');
      isFavorite = box.containsKey(character?.id);
      isLoading = !isLoading;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadComics(int id) async {
    try {
      final responseDto = await characterEndpoint.getCharacterComics(id);
      final comicsJson = responseDto.data['results'] as List<dynamic>;
      comics = comicsJson.map((json) => Comic.fromJson(json)).toList();
      isLoading = !isLoading;
      notifyListeners();
    }catch (e) {
      rethrow;
    }
  }

  Future<void> setFavorite() async{
    try{
      await Hive.initFlutter();
      var box = await Hive.openBox('favorite_spot');
      isFavorite = !isFavorite;
      if(box.containsKey(character?.id)){
        box.put(character?.id,false);
      }else{
        box.put(character?.id,true);
      }
      notifyListeners();
    }catch (e){
      rethrow;
    }
  }

}