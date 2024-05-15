import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/chat_model.dart';
import 'package:graduation_project/models/message_model.dart';
import 'package:graduation_project/services/apis/chat_service.dart';

import '../services/cubits/auth/auth_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)!.settings.arguments) as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: FutureBuilder<ChatModel?>(
        future: ChatService().chatExists(
          sellerId: arguments['sellerId'],
          buyerId: arguments['buyerId'],
          bookId: arguments['bookId'],
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return Chat(
              chat: snapshot.data!,
            );
          }
          return const Text('Chat does not exist');
        },
      ),
    );
  }
}

class Chat extends StatefulWidget {
  const Chat({super.key, required this.chat});
  final ChatModel chat;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Future<List<MessageModel>>? messages;

  void getMessages() {
    setState(() {
      messages = ChatService().getMessages(
        chatId: widget.chat.id!,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<MessageModel>>(
            future: messages,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return MessagesList(
                  messages: snapshot.data!,
                );
              }
              return const Text('No messages');
            },
          ),
        ),
        MessageBar(
          messageBarColor: Theme.of(context).colorScheme.secondaryContainer,
          sendButtonColor: Theme.of(context).colorScheme.tertiary,
          messageBarHintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodySmall!.color,
          ),
          messageBarHintText: "Type a message...",
          onSend: (p0) async {
            await ChatService().sendMessage(
              message: p0,
              chatId: widget.chat.id!,
              token: BlocProvider.of<AuthCubit>(context).userData!.token!,
            );
            getMessages();
          },
        ),
      ],
    );
  }
}

class MessagesList extends StatelessWidget {
  const MessagesList({
    super.key,
    required this.messages,
  });
  final List<MessageModel> messages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        reverse: true,
        itemBuilder: (context, index) {
          return MessageWidget(
            message: messages[index],
          );
        },
        itemCount: messages.length,
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.message});
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return BubbleNormal(
      text: message.content!,
      isSender: message.senderId ==
          BlocProvider.of<AuthCubit>(context).userData!.data!.id!,
      color: message.senderId ==
              BlocProvider.of<AuthCubit>(context).userData!.data!.id!
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.secondaryContainer,
    );
  }
}
