import 'package:belks_tube/domain/search/search_model.dart';
import 'package:flutter/material.dart';

class SearchMenuElement extends StatefulWidget {
  final SearchChannel channel;

  const SearchMenuElement({Key? key, required this.channel}) : super(key: key);

  @override
  State<SearchMenuElement> createState() => _SearchMenuElement();
}

class _SearchMenuElement extends State<SearchMenuElement> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {});
      },
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
                  color: Colors.black26, offset: Offset(0, 2), blurRadius: 3)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image(
                image: NetworkImage(widget.channel.profilePictureUrl),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 7,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.channel.title,
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
                  widget.channel.description,
                  maxLines: 2,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12,),
                )
              ],
            )),
            const SizedBox(
              width: 7,
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.green,
                ))
          ],
        ),
      ),
    );
  }
}
