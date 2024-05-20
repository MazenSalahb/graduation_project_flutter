import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/chat_model.dart';
import 'package:graduation_project/screens/widgets/please_login_widget.dart';
import 'package:graduation_project/screens/widgets/profile_appbar_widget.dart';
import 'package:graduation_project/services/apis/chat_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_state.dart';

import '../../services/cubits/auth/auth_cubit.dart';

class UserChatsScreen extends StatelessWidget {
  const UserChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 100,
                centerTitle: true,
                title: Image.asset(
                  "assets/images/logo1.png",
                  height: 100,
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/categories");
                  },
                  icon: const Icon(Icons.grid_view_rounded),
                ),
                actions: const [
                  ProfileAppBarWidget(),
                ],
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      text: 'Book you are buying',
                    ),
                    Tab(
                      text: 'Book you are selling',
                    ),
                  ],
                ),
              ),
              body: const TabBarView(
                children: [
                  UserBuyingChats(),
                  UserSellingChats(),
                ],
              ),
            ),
          );
        } else {
          return const PleaseLoginWidget(
            message: 'view your chats',
          );
        }
      },
    );
  }
}

class UserBuyingChats extends StatelessWidget {
  const UserBuyingChats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: FutureBuilder<List<ChatModel>>(
        future: ChatService().getUserBuyingChats(
          userId: BlocProvider.of<AuthCubit>(context).userData!.data!.id!,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching chats'),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No chats'),
              );
            } else {
              return BuyingChatsList(
                chats: snapshot.data!,
              );
            }
          } else {
            return const Center(
              child: Text('No chats'),
            );
          }
        },
      ),
    );
  }
}

class UserSellingChats extends StatelessWidget {
  const UserSellingChats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: FutureBuilder<List<ChatModel>>(
        future: ChatService().getUserSellingChats(
          userId: BlocProvider.of<AuthCubit>(context).userData!.data!.id!,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching chats'),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No chats'),
              );
            } else {
              return SellingChatsList(
                chats: snapshot.data!,
              );
            }
          } else {
            return const Center(
              child: Text('No chats'),
            );
          }
        },
      ),
    );
  }
}

class BuyingChatsList extends StatelessWidget {
  const BuyingChatsList({
    super.key,
    required this.chats,
  });
  final List<ChatModel> chats;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return ChatWidget(chat: chats[index], isBuying: true);
      },
    );
  }
}

class SellingChatsList extends StatelessWidget {
  const SellingChatsList({
    super.key,
    required this.chats,
  });
  final List<ChatModel> chats;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return ChatWidget(chat: chats[index], isBuying: false);
      },
    );
  }
}

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.chat,
    required this.isBuying,
  });

  final ChatModel chat;
  final bool isBuying;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/chat', arguments: {
          'sellerId': chat.seller!.id!,
          'buyerId': BlocProvider.of<AuthCubit>(context).userData!.data!.id,
          'bookId': chat.book!.id!,
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        height: 200,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                chat.book!.image!,
                // height: 180,
                width: 100,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            chat.book!.title!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(chat.createdAt!),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(chat.book!.author!),
                    const SizedBox(height: 10),
                    Text(chat.book!.availability == 'sale'
                        ? '${chat.book!.price!}EGP'
                        : '🤝'),
                    const SizedBox(height: 10),
                    Text(
                        'with: ${isBuying ? chat.seller!.name! : chat.buyer!.name!}'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
