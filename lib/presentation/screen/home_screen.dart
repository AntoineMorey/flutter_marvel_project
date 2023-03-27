import 'package:flutter/material.dart';
import 'package:marvel_app/presentation/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../data/model/character.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeViewModel.buildWithProvider(
      builder: (_, __) => const HomeContent(),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marvel Characters'),
      ),
      body: FutureBuilder<List<Character>?>(
        future: homeViewModel.load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final characters = snapshot.data!;
            return ListView.builder(
              itemCount: characters.length + 1, // ajouter 1 pour le bouton "Charger plus"
              itemBuilder: (context, index) {
                if (index == characters.length) {
                  // afficher le bouton "Charger plus" en bas de la liste
                  return ElevatedButton(
                    onPressed: () => homeViewModel.load(), // charger la page suivante
                    child: const Text('Charger plus'),
                  );
                } else {
                  // afficher un élément de la liste
                  final character = characters[index];
                  return ListTile(
                    title: Text(character.name!),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        '${character.thumbnail?.path}.${character.thumbnail?.extension}',
                      ),
                    ),
                    trailing: const Icon(Icons.info),
                    onTap: () {},
                  );
                  }
              },
            );
          } else {
            return const Center(
              child: Text('No data'),
            );
          }
        },
      ),
    );
  }
}
