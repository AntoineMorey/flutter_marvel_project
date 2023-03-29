import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marvel_app/data/endpoint/characters_endpoint.dart';
import 'package:marvel_app/data/model/character.dart';
import 'package:marvel_app/infrastructure/injections/injector.dart';
import 'package:marvel_app/infrastructure/services/connectivity_service.dart';
import 'package:provider/provider.dart';

import '../screen/details.dart';

class HomeViewModel extends ChangeNotifier {
  final CharacterEndpoint characterEndpoint;
  final ConnectivityServive _connectivityServive;

  int _offset = 0;
  List<Character> charactersList = [];
  bool isLoading = true;
  ScrollController scrollController = ScrollController();


  HomeViewModel._(this._connectivityServive, {required this.characterEndpoint});

  static ChangeNotifierProvider<HomeViewModel> buildWithProvider(
      {required Widget Function(BuildContext context, Widget? child)? builder,
      Widget? child}) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (BuildContext context) => HomeViewModel._(
        injector<ConnectivityServive>(),
        characterEndpoint: injector<CharacterEndpoint>(),
      )..load()
      ..initScroll(),
      builder: builder,
      lazy: false,
      child: child,
    );
  }

  void initScroll() {
    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent * 0.9) {
        if (!isLoading) {
          isLoading = !isLoading;
          notifyListeners();
          load();
        }
      }
    });
  }
 

  Future<void> load() async {
    try {
      final responseDto = await characterEndpoint.getCharacters(offset: _offset, limit: 20);
      final charactersJson = responseDto.data['results'] as List<dynamic>;
      final characters = charactersJson.map((json) => Character.fromJson(json)).toList();
      _offset += characters.length; // augmenter la valeur d'offset
      charactersList.addAll(characters);
      isLoading = !isLoading;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void navigateToDetail(BuildContext context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailsScreen(index: charactersList[index].id ?? 0),
      ),
    );
  }
}
