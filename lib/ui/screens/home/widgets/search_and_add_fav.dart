import 'package:belks_tube/ui/screens/home/home_screen_c.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchAndAddFavorite extends HookConsumerWidget {
  const SearchAndAddFavorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(HomeScreenController.provider.notifier);
    final textSearchController = ref.watch(HomeScreenController
        .provider.notifier
        .select((v) => v.textEditingController));

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
              onSubmitted: c.fetchSearchResults,
              decoration: const InputDecoration(
                hintText: 'Find more',
              ),
            ),
          ],
        ));
  }
}
