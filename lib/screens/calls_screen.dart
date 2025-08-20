import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calls = _generateMockCalls();
    
    return ListView.builder(
      itemCount: calls.length,
      itemBuilder: (context, index) {
        final call = calls[index];
        return _buildCallTile(context, call);
      },
    );
  }

  Widget _buildCallTile(BuildContext context, CallInfo call) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 24,
        backgroundColor: WhatsAppColors.lightSecondary,
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 24,
        ),
      ),
      title: Text(
        call.name,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      subtitle: Row(
        children: [
          Icon(
            call.isIncoming ? Icons.call_received : Icons.call_made,
            size: 16,
            color: call.isMissed 
                ? Colors.red 
                : WhatsAppColors.primaryGreen,
          ),
          const SizedBox(width: 4),
          Text(
            DateFormat.MMMd().add_jm().format(call.timestamp),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      trailing: Icon(
        call.isVideoCall ? Icons.videocam : Icons.call,
        color: WhatsAppColors.primaryGreen,
        size: 20,
      ),
      onTap: () {
        // Handle call tap
      },
    );
  }

  List<CallInfo> _generateMockCalls() {
    final now = DateTime.now();
    
    return [
      CallInfo(
        name: 'Alice Johnson',
        timestamp: now.subtract(const Duration(hours: 2)),
        isIncoming: true,
        isMissed: false,
        isVideoCall: false,
      ),
      CallInfo(
        name: 'Bob Smith',
        timestamp: now.subtract(const Duration(hours: 5)),
        isIncoming: false,
        isMissed: false,
        isVideoCall: true,
      ),
      CallInfo(
        name: 'Carol Davis',
        timestamp: now.subtract(const Duration(days: 1)),
        isIncoming: true,
        isMissed: true,
        isVideoCall: false,
      ),
      CallInfo(
        name: 'David Wilson',
        timestamp: now.subtract(const Duration(days: 2)),
        isIncoming: false,
        isMissed: false,
        isVideoCall: true,
      ),
    ];
  }
}

class CallInfo {
  final String name;
  final DateTime timestamp;
  final bool isIncoming;
  final bool isMissed;
  final bool isVideoCall;

  CallInfo({
    required this.name,
    required this.timestamp,
    required this.isIncoming,
    required this.isMissed,
    required this.isVideoCall,
  });
}
