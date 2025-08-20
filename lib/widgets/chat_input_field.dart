import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSendMessage;
  final VoidCallback? onTyping;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSendMessage,
    this.onTyping,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> with TickerProviderStateMixin {
  bool _isTextEmpty = true;
  late AnimationController _micToSendController;
  late Animation<double> _micToSendAnimation;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    
    _micToSendController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _micToSendAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _micToSendController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _micToSendController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final isEmpty = widget.controller.text.trim().isEmpty;
    if (isEmpty != _isTextEmpty) {
      setState(() {
        _isTextEmpty = isEmpty;
      });
      
      if (_isTextEmpty) {
        _micToSendController.reverse();
      } else {
        _micToSendController.forward();
      }
    }
    
    if (widget.onTyping != null && !_isTextEmpty) {
      widget.onTyping!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: isDark 
                ? Colors.white.withOpacity(0.1) 
                : Colors.black.withOpacity(0.1),
            width: 0.2,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text input field
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 40,
                  maxHeight: 120,
                ),
                decoration: BoxDecoration(
                  color: isDark 
                      ? WhatsAppColors.darkSurface 
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark 
                        ? Colors.transparent
                        : Colors.grey.shade300,
                    width: 0.5,
                  ),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Emoji button
                    IconButton(
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                        size: 24,
                      ),
                      onPressed: () {},
                      splashRadius: 20,
                    ),
                    
                    // Text field
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        maxLines: 6,
                        minLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Message',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white54 : Colors.grey.shade500,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 10,
                          ),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                    
                    // Attachment and Camera buttons
                    Row(
                      children: [
                        if (_isTextEmpty) ...[
                          IconButton(
                            icon: Transform.rotate(
                              angle: -0.5,
                              child: Icon(
                                Icons.attach_file,
                                color: isDark ? Colors.white70 : Colors.grey.shade600,
                                size: 22,
                              ),
                            ),
                            onPressed: () {
                              _showAttachmentMenu(context);
                            },
                            splashRadius: 20,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: isDark ? Colors.white70 : Colors.grey.shade600,
                              size: 22,
                            ),
                            onPressed: () {},
                            splashRadius: 20,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Send/Voice message button
            AnimatedBuilder(
              animation: _micToSendAnimation,
              builder: (context, child) {
                return GestureDetector(
                  onTap: _isTextEmpty ? null : widget.onSendMessage,
                  onLongPressStart: _isTextEmpty ? _startVoiceRecording : null,
                  onLongPressEnd: _isTextEmpty ? _stopVoiceRecording : null,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: WhatsAppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _isTextEmpty ? Icons.mic : Icons.send,
                        key: ValueKey(_isTextEmpty),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildAttachmentOption(
                  icon: Icons.insert_drive_file,
                  label: 'Document',
                  color: const Color(0xFF7C4DFF),
                  onTap: () {},
                ),
                _buildAttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: const Color(0xFFFF5722),
                  onTap: () {},
                ),
                _buildAttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: const Color(0xFFE91E63),
                  onTap: () {},
                ),
                _buildAttachmentOption(
                  icon: Icons.headset,
                  label: 'Audio',
                  color: const Color(0xFFFF9800),
                  onTap: () {},
                ),
                _buildAttachmentOption(
                  icon: Icons.location_on,
                  label: 'Location',
                  color: const Color(0xFF4CAF50),
                  onTap: () {},
                ),
                _buildAttachmentOption(
                  icon: Icons.person,
                  label: 'Contact',
                  color: const Color(0xFF2196F3),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _startVoiceRecording(LongPressStartDetails details) {
    // Implement voice recording start logic
    HapticFeedback.lightImpact();
    // You would typically start recording audio here
  }

  void _stopVoiceRecording(LongPressEndDetails details) {
    // Implement voice recording stop logic
    // You would typically stop recording and send the audio message here
  }
}
