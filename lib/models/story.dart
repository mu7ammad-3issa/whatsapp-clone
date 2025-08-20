class Story {
  final String id;
  final String userName;
  final String? userAvatar;
  final List<StoryItem> items;
  final bool isViewed;
  final DateTime timestamp;

  Story({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.items,
    this.isViewed = false,
    required this.timestamp,
  });
}

class StoryItem {
  final String id;
  final String? imageUrl;
  final String? videoUrl;
  final String? text;
  final Duration duration;
  final DateTime timestamp;

  StoryItem({
    required this.id,
    this.imageUrl,
    this.videoUrl,
    this.text,
    this.duration = const Duration(seconds: 5),
    required this.timestamp,
  });
}
