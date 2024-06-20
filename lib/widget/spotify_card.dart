import 'package:flutter/material.dart';
import 'package:flutter_chocolatecookies/flutter_chocolatecookies.dart';
import 'package:flutter_chocolatecookies/widget/item_card.dart';
import 'package:flutter_justplay_player/model/spotify/_models.dart' as sp;
import 'package:flutter_justplay_player/widget/image_rounded.dart';

class SpArtistCard extends StatelessWidget {
  const SpArtistCard({super.key, required this.artist});

  final sp.Artist artist;

  @override
  Widget build(BuildContext context) {
    return ItemCard(
        child: Row(
      children: [
        ImageRounded(
          artist.images!.first.url!,
          isHttpHeader: true,
          fit: BoxFit.cover,
          size: 20,
        ),
        space12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(artist.name ?? ''),
              Text(artist.type ?? ''),
            ],
          ),
        ),
        space12,
        ItemCard(
            borderWidth: 1,
            borderColor: Colors.black,
            child: RichText(
              text: TextSpan(
                style: AppStyle.textNormal.size12.blackText,
                children: [
                  TextSpan(
                    text: '${artist.followers?.total ?? 0}',
                  ),
                  const WidgetSpan(
                    child: Icon(Icons.person, size: 14),
                  ),
                ],
              ),
            )),
      ],
    ));
  }
}

class SpSongCard extends StatelessWidget {
  const SpSongCard({super.key, required this.track});

  final sp.Track track;

  @override
  Widget build(BuildContext context) {
    return ItemCard(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          children: [
            Image.network(
              track.album!.images!.first.url ?? '',
              fit: BoxFit.cover,
              width: 50,
            ),
            space8,
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(track.name ?? ''),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: AppStyle.textNormal.size12.blackText,
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.explicit, size: (track.explicit!) ? 14 : 0),
                      ),
                      TextSpan(
                        text: '${track.type ?? ''} · ',
                      ),
                      for (var i in track.artists!)
                        TextSpan(
                          text: '${i.name ?? ''}${i != track.artists!.last ? ', ' : ''}',
                        ),
                    ],
                  ),
                )
              ],
            )),
            space8,
            const InkWell(
              onTap: null,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.more_vert),
              ),
            ),
          ],
        ));
  }
}
