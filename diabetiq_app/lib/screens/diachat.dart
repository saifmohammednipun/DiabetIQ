// import 'package:flutter/material.dart';

// class DiaChatScreen extends StatefulWidget {
//   const DiaChatScreen({super.key});

//   @override
//   State<DiaChatScreen> createState() => _DiaChatScreenState();
// }

// class _DiaChatScreenState extends State<DiaChatScreen> {
//   TextEditingController _controller = TextEditingController();
//   List<Map<String, String>> messages = []; // Stores the list of messages
//   bool isTyping = false; // Flag to show typing indicator

//   // Simulate chatbot responses
//   void _sendMessage() {
//     if (_controller.text.isEmpty) return;

//     setState(() {
//       // Add the user's message to the chat
//       messages.add({
//         'sender': 'user',
//         'message': _controller.text,
//       });

//       // Show typing indicator
//       isTyping = true;

//       // Simulate a delay before bot response
//       Future.delayed(const Duration(seconds: 2), () {
//         setState(() {
//           // Add bot's response after a delay
//           messages.add({
//             'sender': 'bot',
//             'message': "DiaChat Response: I'm here to assist you with DiaCare.",
//           });
//           isTyping = false; // Hide typing indicator
//         });
//       });

//       // Clear the input field
//       _controller.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF7F7F8), // Light background color
//       appBar: AppBar(
//         title: const Text(
//           'DiaChat',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 1,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
//             onPressed: () {
//               setState(() {
//                 messages.clear(); // Start new chat session
//               });
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Chat Message List
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: messages.length + (isTyping ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index == messages.length && isTyping) {
//                   // Show typing indicator
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: Row(
//                       children: [
//                         const CircleAvatar(
//                           backgroundImage: AssetImage('images/blood.png'),
//                           radius: 18,
//                         ),
//                         const SizedBox(width: 10),
//                         const Text(
//                           "DiaChat is typing...",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 final message = messages[index];
//                 final isUser = message['sender'] == 'user';

//                 return Align(
//                   alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Row(
//                     mainAxisAlignment:
//                         isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//                     children: [
//                       if (!isUser)
//                         const CircleAvatar(
//                           backgroundImage: AssetImage('images/blood.png'),
//                           radius: 18,
//                         ),
//                       const SizedBox(width: 8),
//                       Flexible(
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 8),
//                           padding:
//                               const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                           decoration: BoxDecoration(
//                             color: isUser ? Colors.blue[100] : Colors.grey[300],
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             message['message']!,
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ),
//                       if (isUser)
//                         const CircleAvatar(
//                           backgroundImage: AssetImage('images/profile.png'),
//                           radius: 18,
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Message Input Section
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 // Input Field
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                     textInputAction: TextInputAction.send,
//                     keyboardType: TextInputType.text,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 // Send Button
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.blue),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiaChatScreen extends StatefulWidget {
  const DiaChatScreen({super.key});

  @override
  State<DiaChatScreen> createState() => _DiaChatScreenState();
}

class _DiaChatScreenState extends State<DiaChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  bool isTyping = false;
  final String apiUrl = "http://10.0.2.2:8000/chat"; // For emulator

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      messages.add({
        'sender': 'user',
        'message': _controller.text,
        'timestamp': DateTime.now().toIso8601String(),
      });
      isTyping = true;
      _controller.clear();
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': messages.last['message']}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          messages.add({
            'sender': 'bot',
            'message': data['response'],
            'sources': data['sources'],
            'timestamp': DateTime.now().toIso8601String(),
          });
          isTyping = false;
        });
      } else {
        throw Exception('Failed to get response from server');
      }
    } catch (e) {
      setState(() {
        messages.add({
          'sender': 'bot',
          'message': "Sorry, I encountered an error. Please try again later.",
          'timestamp': DateTime.now().toIso8601String(),
        });
        isTyping = false;
      });
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['sender'] == 'user';
    final sources = message['sources'] as List<dynamic>?;

    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser)
              const CircleAvatar(
                backgroundImage: AssetImage('images/blood.png'),
                radius: 18,
              ),
            if (!isUser) const SizedBox(width: 8),
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: isUser ? Colors.blue[100] : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isUser ? 20 : 0),
                    bottomRight: Radius.circular(isUser ? 0 : 20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message['message'],
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(message['timestamp']),
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            if (isUser) const SizedBox(width: 8),
            if (isUser)
              const CircleAvatar(
                backgroundImage: AssetImage('images/profile.png'),
                radius: 18,
              ),
          ],
        ),
        if (sources != null && sources.isNotEmpty && !isUser)
          Padding(
            padding: const EdgeInsets.only(left: 42, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sources:",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                ...sources
                    .map(
                      (source) => Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          "- ${source['source']} (Page ${source['page']})",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
      ],
    );
  }

  String _formatTime(String isoTime) {
    final dateTime = DateTime.parse(isoTime);
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        title: const Text(
          'DiaChat',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
            onPressed: () {
              setState(() {
                messages.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: false,
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    keyboardType: TextInputType.text,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('images/blood.png'),
            radius: 18,
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(const Duration(milliseconds: 0)),
                const SizedBox(width: 4),
                _buildTypingDot(const Duration(milliseconds: 300)),
                const SizedBox(width: 4),
                _buildTypingDot(const Duration(milliseconds: 600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(Duration delay) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
