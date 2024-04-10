import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/models/chat_model.dart';
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
                title: const Text('Chats'),
                actions: const [ProfileAppBarWidget()],
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      text: 'Buying',
                    ),
                    Tab(
                      text: 'Selling',
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
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Please'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: const Text('Login'),
                ),
                const Text('to view your chats.')
              ],
            ),
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
        return ListTile(
          title: Text(
            chats[index].book!.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text('with: ${chats[index].seller!.name}'),
          leading: SvgPicture.network(
            '${chats[index].seller!.profilePicture}',
            width: 45,
          ),
          onTap: () {
            Navigator.of(context).pushNamed('/chat', arguments: {
              'sellerId': chats[index].seller!.id!,
              'buyerId': BlocProvider.of<AuthCubit>(context).userData!.data!.id,
              'bookId': chats[index].book!.id!,
            });
          },
        );
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
        return ListTile(
          title: Text(
            chats[index].book!.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text('with: ${chats[index].buyer!.name}'),
          leading: SvgPicture.network(
            '${chats[index].buyer!.profilePicture}',
            width: 45,
          ),
          onTap: () {
            Navigator.of(context).pushNamed('/chat', arguments: {
              'sellerId':
                  BlocProvider.of<AuthCubit>(context).userData!.data!.id,
              'buyerId': chats[index].buyer!.id!,
              'bookId': chats[index].book!.id!,
            });
          },
        );
      },
    );
  }
}
