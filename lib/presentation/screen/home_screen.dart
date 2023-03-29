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
      body: SingleChildScrollView(
        controller: homeViewModel.scrollController,
        child: Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: homeViewModel.isLoading
                  ? homeViewModel.charactersList.length + 1
                  : homeViewModel.charactersList
                      .length,
              itemBuilder: (context, index) {
                if (index == homeViewModel.charactersList.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  // afficher un élément de la liste
                  final character = homeViewModel.charactersList[index];
                  return ListTile(
                    title: Text(character.name!),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        '${character.thumbnail?.path}.${character.thumbnail?.extension}',
                      ),
                    ),
                    trailing: const Icon(Icons.info),
                    onTap: () {
                      homeViewModel.navigateToDetail(context, index);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
