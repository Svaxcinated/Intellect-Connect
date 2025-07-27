import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  // Mock message data for UI demonstration
  final List<Map<String, dynamic>> messages = const [
    {
      'name': 'Sarah Johnson',
      'subject': 'Math Tutor',
      'lastMessage': 'Great job on the algebra problems!',
      'time': '2 min ago',
      'unread': true,
      'avatar': 'SJ',
    },
    {
      'name': 'Mike Chen',
      'subject': 'Science Tutor',
      'lastMessage': 'Don\'t forget about tomorrow\'s experiment',
      'time': '1 hour ago',
      'unread': false,
      'avatar': 'MC',
    },
    {
      'name': 'Emily Davis',
      'subject': 'English Tutor',
      'lastMessage': 'Your essay is ready for review',
      'time': '3 hours ago',
      'unread': true,
      'avatar': 'ED',
    },
    {
      'name': 'David Wilson',
      'subject': 'History Tutor',
      'lastMessage': 'Great discussion about World War II',
      'time': '1 day ago',
      'unread': false,
      'avatar': 'DW',
    },
    {
      'name': 'Lisa Brown',
      'subject': 'Art Tutor',
      'lastMessage': 'Your painting technique is improving!',
      'time': '2 days ago',
      'unread': false,
      'avatar': 'LB',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF98CDB0),
        elevation: 0,
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF98CDB0)),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Placeholder for search action
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Placeholder for more options
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF98CDB0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chat with your tutors',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${messages.where((m) => m['unread']).length} unread messages',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            // Messages List
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessageItem(
                      message: message,
                      isLast: index == messages.length - 1,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for new message action
        },
        backgroundColor: const Color(0xFF98CDB0),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _buildMessageItem({
    required Map<String, dynamic> message,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: () {
        // Placeholder for opening chat
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: isLast ? null : Border(
            bottom: BorderSide(
              color: const Color(0xFFE9ECEF),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF98CDB0).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF98CDB0),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  message['avatar'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF98CDB0),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Message Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: message['unread'] ? FontWeight.bold : FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        message['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: message['unread'] ? const Color(0xFF98CDB0) : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message['subject'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF98CDB0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message['lastMessage'],
                    style: TextStyle(
                      fontSize: 14,
                      color: message['unread'] ? Colors.black : Colors.black54,
                      fontWeight: message['unread'] ? FontWeight.w500 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Unread indicator
            if (message['unread'])
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF98CDB0),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
