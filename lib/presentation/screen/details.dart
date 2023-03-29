import 'package:flutter/material.dart';
import 'package:marvel_app/presentation/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../data/model/character.dart';
import '../viewmodel/details_viewmodel.dart';

class DetailsScreen extends StatelessWidget {
  final int index;

  const DetailsScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DetailsViewModel.buildWithProvider(
        builder: (_, __) => const DetailsContent(), id: index);
  }
}

class DetailsContent extends StatelessWidget {
  const DetailsContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final detailsViewModel = context.watch<DetailsViewModel>();
    return Scaffold(
        appBar: AppBar(
          title: Text(detailsViewModel.character?.name ?? ""),
        ),
        body: detailsViewModel.character == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      '${detailsViewModel.character?.thumbnail?.path}.${detailsViewModel.character?.thumbnail?.extension}',
                    ),
                    radius: 100,
                  ),
                  Text(detailsViewModel.character?.description ?? ""),
                  ExpansionTile(
                    title: Text('Liste des comics'),
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: detailsViewModel.isLoading
                              ? detailsViewModel.comics!.length + 1
                              : detailsViewModel.comics?.length,
                          itemBuilder: (context, index) {
                            if (index == detailsViewModel.comics?.length) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              // afficher un élément de la liste
                              final comic = detailsViewModel.comics?[index];
                              return SizedBox(
                                width: 200,
                                child: ListTile(
                                  title: Text(comic?.title ?? ""),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      '${comic?.thumbnail?.path}.${comic?.thumbnail?.extension}',
                                    ),
                                  ),
                                  trailing: const Icon(Icons.info),
                                  onTap: () {
                                    // detailsViewModel.navigateToDetail(context, index);
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )));
  }
}
