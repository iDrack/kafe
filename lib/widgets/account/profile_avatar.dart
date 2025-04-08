import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileAvatar extends StatelessWidget {

  final String? imageUrl;
  final double radius;
  final VoidCallback? onTapGallery;
  final VoidCallback? onTapCamera;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.radius = 80.0,
    this.onTapGallery,
    this.onTapCamera,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context, 
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir depuis la galerie'),
                onTap: () {
                  Navigator.of(context).pop();
                  if (onTapGallery != null)  {
                    onTapGallery!();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Prendre une photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  if (onTapCamera != null) {
                    onTapCamera!();
                  }
                },
              ),
            ],
          )
          );
        },
      child: CircleAvatar(
            radius: radius,
            backgroundImage: imageUrl != null 
              ? NetworkImage(imageUrl!) 
              : null,
            backgroundColor: Colors.grey[300],
            child: imageUrl == null
                ? Icon(
                    Icons.person,
                    size: radius,
                    color: Colors.grey[800],
                  )
                : null,
          ),
      );
  }
}