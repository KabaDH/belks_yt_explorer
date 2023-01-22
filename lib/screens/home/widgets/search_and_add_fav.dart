import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchAndAddFavorite extends HookConsumerWidget {
  const SearchAndAddFavorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textSearchController = useTextEditingController();

    return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            TextField(
              controller: textSearchController,
              onSubmitted: (newRequest) async {
                // List<SearchChannel> _newSearchResults = await APIService
                //     .instance
                //     .fetchSearchResults(searchRequest: newRequest);
                // setState(() {
                //   searchChannels = _newSearchResults;
                //   debugPrint(searchChannels.toString());
                // });
              },
              decoration: const InputDecoration(
                hintText: 'Find more',
              ),
            ),
          ],
        ));
  }
}
