import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/story.dart';

class StoryViewScreen extends StatefulWidget {
  final List<Story> stories;
  final int initialIndex;

  const StoryViewScreen({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  int _currentStoryIndex = 0;
  int _currentItemIndex = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _currentStoryIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    _progressController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _startStoryTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _startStoryTimer() {
    _progressController.reset();
    _progressController.forward().then((_) {
      if (!_isPaused && mounted) {
        _nextItem();
      }
    });
  }

  void _nextItem() {
    final currentStory = widget.stories[_currentStoryIndex];
    if (_currentItemIndex < currentStory.items.length - 1) {
      setState(() {
        _currentItemIndex++;
      });
      _startStoryTimer();
    } else {
      _nextStory();
    }
  }

  void _previousItem() {
    if (_currentItemIndex > 0) {
      setState(() {
        _currentItemIndex--;
      });
      _startStoryTimer();
    } else {
      _previousStory();
    }
  }

  void _nextStory() {
    if (_currentStoryIndex < widget.stories.length - 1) {
      setState(() {
        _currentStoryIndex++;
        _currentItemIndex = 0;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      setState(() {
        _currentStoryIndex--;
        _currentItemIndex = widget.stories[_currentStoryIndex].items.length - 1;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _pauseStory() {
    setState(() {
      _isPaused = true;
    });
    _progressController.stop();
    _scaleController.forward();
    HapticFeedback.lightImpact();
  }

  void _resumeStory() {
    setState(() {
      _isPaused = false;
    });
    _progressController.forward();
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPressStart: (_) => _pauseStory(),
        onLongPressEnd: (_) => _resumeStory(),
        child: Stack(
          children: [
            // Story Content
            PageView.builder(
              controller: _pageController,
              itemCount: widget.stories.length,
              onPageChanged: (index) {
                setState(() {
                  _currentStoryIndex = index;
                  _currentItemIndex = 0;
                });
                _startStoryTimer();
              },
              itemBuilder: (context, index) {
                final story = widget.stories[index];
                return AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: _buildStoryContent(story, isTablet),
                    );
                  },
                );
              },
            ),

            // Progress Indicators
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: isTablet ? 32 : 8,
              right: isTablet ? 32 : 8,
              child: _buildProgressIndicators(),
            ),

            // User Info
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: isTablet ? 32 : 16,
              right: isTablet ? 32 : 16,
              child: _buildUserInfo(),
            ),

            // Navigation Areas
            Positioned.fill(
              child: Row(
                children: [
                  // Previous Story
                  Expanded(
                    child: GestureDetector(
                      onTap: _previousItem,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  // Next Story
                  Expanded(
                    child: GestureDetector(
                      onTap: _nextItem,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicators() {
    final currentStory = widget.stories[_currentStoryIndex];

    return Row(
      children: [
        // Progress bars for current story items
        ...List.generate(currentStory.items.length, (itemIndex) {
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  double progress = 0;
                  if (itemIndex < _currentItemIndex) {
                    progress = 1;
                  } else if (itemIndex == _currentItemIndex) {
                    progress = _progressController.value;
                  }

                  return LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildUserInfo() {
    final currentStory = widget.stories[_currentStoryIndex];

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.grey,
          backgroundImage: currentStory.userAvatar != null
              ? NetworkImage(currentStory.userAvatar!)
              : null,
          child: currentStory.userAvatar == null
              ? const Icon(Icons.person, color: Colors.white, size: 16)
              : null,
        ),
        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentStory.userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _formatTimestamp(currentStory.timestamp),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {
            HapticFeedback.lightImpact();
          },
        ),

        // Close button with animation
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoryContent(Story story, bool isTablet) {
    if (story.items.isEmpty) {
      return _buildTextStory('Story', isTablet);
    }

    final currentItem = story.items[_currentItemIndex];

    if (currentItem.imageUrl != null) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.network(
          currentItem.imageUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: Colors.white,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildTextStory(currentItem.text ?? 'Story', isTablet);
          },
        ),
      );
    } else if (currentItem.text != null) {
      return _buildTextStory(currentItem.text!, isTablet);
    }

    return _buildTextStory('Story', isTablet);
  }

  Widget _buildTextStory(String text, bool isTablet) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6B73FF), Color(0xFF000DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 48 : 24),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 32 : 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}
