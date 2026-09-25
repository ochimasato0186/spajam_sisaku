import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ============================================================
// デザイン設定
// ここを変更するだけで画面全体の色を調整できます
// ============================================================

const Color backgroundColor = Color(0xFFF5F5F5);

// 上部ヘッダー
const Color appBarColor = Colors.white;
const Color appBarTextColor = Color(0xFF222222);

// AIの吹き出し
const Color aiMessageColor = Colors.white;
const Color aiMessageTextColor = Color(0xFF222222);

// ユーザーの吹き出し
const Color userMessageColor = Color(0xFF4F6BED);
const Color userMessageTextColor = Colors.white;

// 入力欄
const Color textBoxColor = Colors.white;
const Color textBoxTextColor = Color(0xFF222222);
const Color hintTextColor = Color(0xFF999999);
const Color textBoxBorderColor = Color(0xFFE0E0E0);

// 送信ボタン
const Color sendButtonColor = Color(0xFF4F6BED);
const Color sendButtonIconColor = Colors.white;

// その他
const Color iconColor = Color(0xFF555555);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Chat',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const AiChatPage(),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'こんにちは！今日は何について話しますか？',
      isUser: false,
    ),
  ];

  void _sendMessage() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
        ),
      );
    });

    _controller.clear();

    _scrollToBottom();

    // ==========================================
    // TODO:
    // ここでFastAPI / LangChainなどに送信する
    // ==========================================

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _messages.add(
          ChatMessage(
            text: 'AIからの返信をここに表示します。',
            isUser: false,
          ),
        );
      });

      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // =========================
      // ヘッダー
      // =========================
      appBar: AppBar(
        backgroundColor: appBarColor,
        surfaceTintColor: appBarColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'AIと会話',
          style: TextStyle(
            color: appBarTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: メニューなど
            },
            icon: const Icon(
              Icons.more_vert,
              color: iconColor,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // =========================
            // チャット一覧
            // =========================
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];

                  return ChatBubble(
                    message: message,
                  );
                },
              ),
            ),

            // =========================
            // 入力エリア
            // =========================
            ChatInput(
              controller: _controller,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// チャット吹き出し
// ============================================================

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.only(
          bottom: 12,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? userMessageColor
              : aiMessageColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser
                ? userMessageTextColor
                : aiMessageTextColor,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// メッセージ入力欄
// ============================================================

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        12,
        10,
        12,
        12,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(
            color: textBoxBorderColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // =========================
          // テキスト入力
          // =========================
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: textBoxColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: textBoxBorderColor,
                ),
              ),
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                style: const TextStyle(
                  color: textBoxTextColor,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                  hintText: 'メッセージを入力...',
                  hintStyle: TextStyle(
                    color: hintTextColor,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // =========================
          // 送信ボタン
          // =========================
          Material(
            color: Color(0xFFFFC0CB),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onSend,
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.arrow_upward_rounded,
                  color: sendButtonIconColor,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}