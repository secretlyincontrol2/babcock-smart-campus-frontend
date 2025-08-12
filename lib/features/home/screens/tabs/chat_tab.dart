import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/providers/chat_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  String? _selectedRoomId;

  // Sample chat rooms data
  final List<Map<String, dynamic>> _sampleChatRooms = [
    {
      'id': '1',
      'name': 'Computer Science 2024',
      'lastMessage': 'When is the next assignment due?',
      'lastMessageTime': '2 min ago',
      'unreadCount': 3,
      'isOnline': true,
      'avatar': 'CS',
      'members': 45,
    },
    {
      'id': '2',
      'name': 'Study Group - Math',
      'lastMessage': 'Can someone explain calculus?',
      'lastMessageTime': '15 min ago',
      'unreadCount': 0,
      'isOnline': false,
      'avatar': 'MG',
      'members': 12,
    },
    {
      'id': '3',
      'name': 'Campus Events',
      'lastMessage': 'Don\'t forget the career fair tomorrow!',
      'lastMessageTime': '1 hour ago',
      'unreadCount': 7,
      'isOnline': true,
      'avatar': 'CE',
      'members': 156,
    },
    {
      'id': '4',
      'name': 'Library Study Session',
      'lastMessage': 'Who wants to study together?',
      'lastMessageTime': '2 hours ago',
      'unreadCount': 0,
      'isOnline': false,
      'avatar': 'LS',
      'members': 8,
    },
    {
      'id': '5',
      'name': 'Sports Team',
      'lastMessage': 'Great game today, team!',
      'lastMessageTime': '3 hours ago',
      'unreadCount': 2,
      'isOnline': true,
      'avatar': 'ST',
      'members': 23,
    },
  ];

  // Sample messages for the selected chat room
  final List<Map<String, dynamic>> _sampleMessages = [
    {
      'id': '1',
      'senderId': 'user1',
      'senderName': 'John Doe',
      'message': 'Hey everyone! How\'s the semester going?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'isOwn': false,
      'avatar': 'JD',
    },
    {
      'id': '2',
      'senderId': 'currentUser',
      'senderName': 'You',
      'message': 'It\'s going great! Really enjoying the new courses.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 25)),
      'isOwn': true,
      'avatar': 'ME',
    },
    {
      'id': '3',
      'senderId': 'user2',
      'senderName': 'Jane Smith',
      'message': 'Same here! The professors are amazing this year.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 20)),
      'isOwn': false,
      'avatar': 'JS',
    },
    {
      'id': '4',
      'senderId': 'user3',
      'senderName': 'Mike Johnson',
      'message': 'Anyone up for a study session this weekend?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'isOwn': false,
      'avatar': 'MJ',
    },
    {
      'id': '5',
      'senderId': 'currentUser',
      'senderName': 'You',
      'message': 'I\'m in! Library at 2 PM on Saturday?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
      'isOwn': true,
      'avatar': 'ME',
    },
    {
      'id': '6',
      'senderId': 'user1',
      'senderName': 'John Doe',
      'message': 'Perfect! See you there.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'isOwn': false,
      'avatar': 'JD',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Select the first chat room by default
    if (_sampleChatRooms.isNotEmpty) {
      _selectedRoomId = _sampleChatRooms.first['id'];
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final message = _messageController.text.trim();
      
      // Add the new message to the list
      setState(() {
        _sampleMessages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'senderId': 'currentUser',
          'senderName': 'You',
          'message': message,
          'timestamp': DateTime.now(),
          'isOwn': true,
          'avatar': 'ME',
        });
      });

      // Clear the input field
      _messageController.clear();

      // Scroll to the bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

      // Simulate typing indicator
      setState(() => _isTyping = true);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isTyping = false);
      });
    }
  }

  void _selectChatRoom(String roomId) {
    setState(() {
      _selectedRoomId = roomId;
    });
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            // Chat rooms sidebar
            Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  right: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              child: Column(
                children: [
                  _buildChatRoomsHeader(),
                  Expanded(
                    child: _buildChatRoomsList(),
                  ),
                ],
              ),
            ),
            // Chat messages area
            Expanded(
              child: _selectedRoomId != null
                  ? _buildChatMessagesArea()
                  : _buildNoRoomSelected(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatRoomsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.chat_bubble_rounded,
            color: AppTheme.primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          const Text(
            'Chats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // TODO: Implement new chat functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('New chat functionality coming soon!'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            icon: const Icon(Icons.add),
            tooltip: 'New Chat',
          ),
        ],
      ),
    );
  }

  Widget _buildChatRoomsList() {
    return ListView.builder(
      itemCount: _sampleChatRooms.length,
      itemBuilder: (context, index) {
        final room = _sampleChatRooms[index];
        final isSelected = room['id'] == _selectedRoomId;
        
        return GestureDetector(
          onTap: () => _selectChatRoom(room['id']),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[100]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryColor : Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      room['avatar'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Chat room info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              room['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            room['lastMessageTime'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? AppTheme.primaryColor.withOpacity(0.7) : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              room['lastMessage'],
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected ? AppTheme.primaryColor.withOpacity(0.8) : Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (room['unreadCount'] > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                room['unreadCount'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: room['isOnline'] ? Colors.green : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${room['members']} members',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatMessagesArea() {
    final selectedRoom = _sampleChatRooms.firstWhere(
      (room) => room['id'] == _selectedRoomId,
    );

    return Column(
      children: [
        // Chat header
        _buildChatHeader(selectedRoom),
        // Messages area
        Expanded(
          child: _buildMessagesList(),
        ),
        // Typing indicator
        if (_isTyping) _buildTypingIndicator(),
        // Message input
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildChatHeader(Map<String, dynamic> room) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                room['avatar'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: room['isOnline'] ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      room['isOnline'] ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${room['members']} members',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement chat room options
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chat room options coming soon!'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _sampleMessages.length,
      itemBuilder: (context, index) {
        final message = _sampleMessages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isOwn = message['isOwn'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isOwn) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  message['avatar'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isOwn ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: isOwn ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight: isOwn ? const Radius.circular(4) : const Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isOwn)
                    Text(
                      message['senderName'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  if (!isOwn) const SizedBox(height: 4),
                  Text(
                    message['message'],
                    style: TextStyle(
                      fontSize: 16,
                      color: isOwn ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message['timestamp']),
                    style: TextStyle(
                      fontSize: 11,
                      color: isOwn ? Colors.white.withOpacity(0.7) : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isOwn) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'JD',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // TODO: Implement attachment functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Attachment functionality coming soon!'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            icon: Icon(
              Icons.attach_file,
              color: Colors.grey[600],
            ),
            tooltip: 'Attach file',
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              tooltip: 'Send message',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoRoomSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/wave.json',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          const Text(
            'Select a chat room',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Choose a conversation from the sidebar to start chatting',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
