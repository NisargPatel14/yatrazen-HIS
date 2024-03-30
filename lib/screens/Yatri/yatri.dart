import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Yatri extends StatefulWidget {
  const Yatri({super.key});

  @override
  _YatriState createState() => _YatriState();
}

class _YatriState extends State<Yatri> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late final GenerativeModel _model;
  late final ChatSession _chat;

  @override
  void initState() {
    super.initState();
    // Initialize the model and make api requests
  }

  Future<void> sendMessage(String? text) async {
    // Add user message to the chat and clear the text field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yatri AI", style: Theme.of(context).textTheme.bodySmall),
        backgroundColor: const Color(0xff0E1219),
        iconTheme: const IconThemeData(color: Color(0xffffffff)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: _messages[index]);
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Ask Anything to Yatri 😃',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (text) => sendMessage(text),
                    ),
                  ),
                ),
                IconButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(255, 41, 105, 214)),
                  ),
                  icon: SvgPicture.asset(
                    'assets/SVG/tick.svg',
                    width: 24,
                    height: 24,
                  ), // Removed 'const' here
                  onPressed: () => sendMessage(_controller.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: message.isUser ? Colors.blue : Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  radius: 20,
                  child: SvgPicture.asset('assets/SVG/messages.svg'),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: message.isMarkdown
                    ? MarkdownBody(
                        data: message.text,
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(color: Colors.white),
                        ),
                      )
                    : Text(
                        message.text,
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
              if (message.isUser) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  radius: 20,
                  child: SvgPicture.asset('assets/SVG/user.svg'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isMarkdown;

  const ChatMessage(
      {required this.text, required this.isUser, this.isMarkdown = false});
}
