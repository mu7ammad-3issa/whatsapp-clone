import 'package:flutter/material.dart';
import '../models/story.dart';
import '../widgets/story_tile.dart';
import '../widgets/story_circle.dart';
import 'story_view_screen.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final List<Story> _stories = _generateMockStories();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // My Status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Stack(
                children: [
                  const StoryCircle(
                    imageUrl: null,
                    isViewed: false,
                    size: 48,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My status',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'Tap to add status update',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'status_privacy',
                    child: Text('Status privacy'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Recent updates header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).colorScheme.surface,
          child: Text(
            'Recent updates',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),

        // Stories list
        Expanded(
          child: ListView.builder(
            itemCount: _stories.length,
            itemBuilder: (context, index) {
              final story = _stories[index];
              return StoryTile(
                story: story,
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          StoryViewScreen(
                        stories: _stories,
                        initialIndex: index,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.easeOut;

                        var tween = Tween(begin: begin, end: end).chain(
                          CurveTween(curve: curve),
                        );

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  static List<Story> _generateMockStories() {
    final now = DateTime.now();

    return [
      Story(
        id: '1',
        userName: 'Alice Johnson',
        timestamp: now.subtract(const Duration(minutes: 30)),
        isViewed: false,
        items: [
          StoryItem(
            id: '1_1',
            imageUrl: 'https://picsum.photos/400/600?random=1',
            timestamp: now.subtract(const Duration(minutes: 30)),
          ),
          StoryItem(
            id: '1_2',
            text: 'Beautiful sunset today! 🌅',
            timestamp: now.subtract(const Duration(minutes: 25)),
          ),
        ],
      ),
      Story(
        id: '2',
        userName: 'Bob Smith',
        timestamp: now.subtract(const Duration(hours: 2)),
        isViewed: true,
        items: [
          StoryItem(
            id: '2_1',
            imageUrl: 'https://picsum.photos/400/600?random=2',
            timestamp: now.subtract(const Duration(hours: 2)),
          ),
        ],
      ),
      Story(
        id: '3',
        userName: 'Carol Davis',
        timestamp: now.subtract(const Duration(hours: 4)),
        isViewed: false,
        items: [
          StoryItem(
            id: '3_1',
            imageUrl: 'https://picsum.photos/400/600?random=3',
            timestamp: now.subtract(const Duration(hours: 4)),
          ),
          StoryItem(
            id: '3_2',
            imageUrl: 'https://picsum.photos/400/600?random=4',
            timestamp: now.subtract(const Duration(hours: 3, minutes: 45)),
          ),
        ],
      ),
      Story(
        id: '4',
        userName: 'David Wilson',
        timestamp: now.subtract(const Duration(hours: 8)),
        isViewed: true,
        items: [
          StoryItem(
            id: '4_1',
            text: 'Good morning everyone! ☀️',
            timestamp: now.subtract(const Duration(hours: 8)),
          ),
        ],
      ),
      Story(
        id: '5',
        userName: 'Emma Thompson',
        timestamp: now.subtract(const Duration(hours: 12)),
        isViewed: false,
        items: [
          StoryItem(
            id: '5_1',
            imageUrl: 'https://picsum.photos/400/600?random=5',
            timestamp: now.subtract(const Duration(hours: 12)),
          ),
        ],
      ),
    ];
  }
}
