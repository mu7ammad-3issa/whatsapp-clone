import 'package:flutter/material.dart';

import '../widgets/custom_tab_bar.dart';
import '../widgets/animated_transitions.dart';
import '../constants/colors.dart';

import 'chats_screen.dart';
import 'stories_screen.dart';
import 'calls_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.of(context).push(
                  SlideUpPageRoute(child: const SettingsScreen()),
                );
              }
              // Handle other menu items here
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'new_group',
                child: Text('New group'),
              ),
              const PopupMenuItem(
                value: 'new_broadcast',
                child: Text('New broadcast'),
              ),
              const PopupMenuItem(
                value: 'linked_devices',
                child: Text('Linked devices'),
              ),
              const PopupMenuItem(
                value: 'starred_messages',
                child: Text('Starred messages'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
            ],
          ),
        ],
        bottom: CustomTabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Status'),
            Tab(text: 'Chats'),
            Tab(text: 'Calls'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          StoriesScreen(),
          ChatsScreen(),
          CallsScreen(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget? _buildFloatingActionButton() {
    switch (_tabController.index) {
      case 0: // Stories
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButtonHero(
              onPressed: () {},
              heroTag: "edit_story",
              backgroundColor: Colors.white.withOpacity(0.9),
              child: const Icon(Icons.edit,
                  color: WhatsAppColors.primaryGreen, size: 20),
            ),
            const SizedBox(height: 8),
            FloatingActionButtonHero(
              onPressed: () {},
              heroTag: "camera_story",
              backgroundColor: WhatsAppColors.primaryGreen,
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ],
        );
      case 1: // Chats
        return FloatingActionButtonHero(
          onPressed: () {},
          heroTag: "chat_fab",
          backgroundColor: WhatsAppColors.primaryGreen,
          child: const Icon(Icons.chat, color: Colors.white),
        );
      case 2: // Calls
        return FloatingActionButtonHero(
          onPressed: () {},
          heroTag: "call_fab",
          backgroundColor: WhatsAppColors.primaryGreen,
          child: const Icon(Icons.add_call, color: Colors.white),
        );
      default:
        return null;
    }
  }
}
