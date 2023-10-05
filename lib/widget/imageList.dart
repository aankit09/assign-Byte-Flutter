import 'package:flutter/material.dart';

import '../model/image_model.dart';

class ImageList extends StatelessWidget {
  final List<Photo> photos;

  ImageList({required this.photos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              photo.thumbnailUrl,
            ));
      },
    );
  }
}
