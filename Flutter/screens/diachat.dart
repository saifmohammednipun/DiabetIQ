import 'package:flutter/material.dart';

class DiaChatScreen extends StatefulWidget {
  const DiaChatScreen({super.key});

  @override
  State<DiaChatScreen> createState() => _DiaChatScreenState();
}

class _DiaChatScreenState extends State<DiaChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = []; // Stores the list of messages
  bool isTyping = false; // Flag to show typing indicator

  // Simulate chatbot responses
  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      // Add the user's message to the chat
      messages.add({
        'sender': 'user',
        'message': _controller.text,
      });

      // Show typing indicator
      isTyping = true;

      // Simulate a delay before bot response
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          // Add bot's response after a delay
          messages.add({
            'sender': 'bot',
            'message': "DiaChat Response: I'm here to assist you with DiaCare.",
          });
          isTyping = false; // Hide typing indicator
        });
      });

      // Clear the input field
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F8), // Light background color
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
                messages.clear(); // Start new chat session
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Message List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && isTyping) {
                  // Show typing indicator
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage('images/blood.png'),
                          radius: 18,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "DiaChat is typing...",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final message = messages[index];
                final isUser = message['sender'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment:
                        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isUser)
                        const CircleAvatar(
                          backgroundImage: AssetImage('images/blood.png'),
                          radius: 18,
                        ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding:
                              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            message['message']!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      if (isUser)
                        const CircleAvatar(
                          backgroundImage: AssetImage('images/profile.png'),
                          radius: 18,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Message Input Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Input Field
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
                    ),
                    textInputAction: TextInputAction.send,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(width: 8),
                // Send Button
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
}
