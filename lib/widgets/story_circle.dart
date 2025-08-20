import 'package:flutter/material.dart';
import '../constants/colors.dart';

class StoryCircle extends StatelessWidget {
  final String? imageUrl;
  final bool isViewed;
  final double size;
  final int storyCount;

  const StoryCircle({
    super.key,
    this.imageUrl,
    required this.isViewed,
    this.size = 56,
    this.storyCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: !isViewed 
            ? const LinearGradient(
                colors: [
                  WhatsAppColors.primaryGreen,
                  WhatsAppColors.lightTeal,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        border: isViewed 
            ? Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 2,
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(isViewed ? 2 : 3),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: CircleAvatar(
              radius: (size - 8) / 2,
              backgroundColor: WhatsAppColors.lightSecondary,
              backgroundImage: imageUrl != null 
                  ? NetworkImage(imageUrl!) 
                  : null,
              child: imageUrl == null 
                  ? Icon(
                      Icons.person,
                      color: Colors.white,
                      size: (size - 8) / 2,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
