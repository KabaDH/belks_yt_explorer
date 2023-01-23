import 'package:belks_tube/domain/channel/channel_model.dart';
import 'package:belks_tube/ui/screens/home/home_screen_c.dart';
import 'package:belks_tube/ui/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildFavorites extends ConsumerWidget {
  const BuildFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // favoriteChannels.length
    final m = ref.watch(HomeScreenController.provider
        .select((v) => v.favoriteChannels.length)); // model

    return Expanded(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: m == 0
            ? const SizedBox.shrink()
            : ListView.builder(
                itemCount: m,
                itemBuilder: (context, index) {
                  return _BuildFavoriteChannelElement(
                    index: index,
                  );
                }),
      ),
    );
  }
}

class _BuildFavoriteChannelElement extends ConsumerWidget {
  const _BuildFavoriteChannelElement({Key? key, required this.index})
      : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Channel
    final m = ref.watch(
      HomeScreenController.provider.select(
        (v) {
          // to avoid range error upon deletion
          try {
            return v.favoriteChannels[index];
          } catch (_) {
            return null;
          }
        },
      ),
    );
    final c = ref.read(HomeScreenController.provider.notifier);

    return m == null
        ? const SizedBox.shrink()
        : GestureDetector(
            onTap: () => c.setNewMainChannel(m),
            child: Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(80),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 3)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BuildProfileImg(imgUrl: m.profilePictureUrl, size: 60),
                  const SizedBox(
                    width: 7,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 2)
                            ]),
                      ),
                      Text(
                        m.lastPublishedAt,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      )
                    ],
                  )),
                  const SizedBox(width: 7),
                  IconButton(
                      onPressed: () =>
                          _removeDialog(m, context, c.removeChannel),
                      icon: const Icon(
                        Icons.cancel,
                        size: 30,
                        color: Colors.black54,
                      ))
                ],
              ),
            ),
          );
  }
}

// Button remove fav pressed
Future<void> _removeDialog(
    Channel c, BuildContext context, void Function(Channel) onRemove) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, //user must tap the button
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation require'),
          content: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                  text: 'Remove channel ',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                        text: c.title,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    const TextSpan(
                        text: ' from list?',
                        style: TextStyle(color: Colors.black, fontSize: 16))
                  ]),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => {Navigator.of(context).pop(), onRemove(c)},
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.black),
                )),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.black),
                )),
          ],
        );
      });
}
