import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_it/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeghtWidth = 120;
    double iconSize = 60;
    final currentTheme = ref.watch(themeNotifiereProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap:()=>navigateToType(context,'image'),
          child: SizedBox(
            height: cardHeghtWidth,
            width: cardHeghtWidth,
            child: Card(
              color: currentTheme.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap:()=>navigateToType(context,'text'),
          child: SizedBox(
            height: cardHeghtWidth,
            width: cardHeghtWidth,
            child: Card(
              color: currentTheme.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.font_download,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap:()=>navigateToType(context,'link'),
          child: SizedBox(
            height: cardHeghtWidth,
            width: cardHeghtWidth,
            child: Card(
              color: currentTheme.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.link,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
