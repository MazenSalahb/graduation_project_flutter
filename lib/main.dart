import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/screens/add_book_form_screen.dart';
import 'package:graduation_project/screens/book_details_screen.dart';
import 'package:graduation_project/screens/books_screen.dart';
import 'package:graduation_project/screens/categories_screen.dart';
import 'package:graduation_project/screens/chat_screen.dart';
import 'package:graduation_project/screens/edit_book_screen.dart';
import 'package:graduation_project/screens/login_screen.dart';
import 'package:graduation_project/screens/main_screens/main_screen.dart';
import 'package:graduation_project/screens/main_screens/notifications_screen.dart';
import 'package:graduation_project/screens/profile_screen.dart';
import 'package:graduation_project/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:graduation_project/screens/start_screen.dart';
import 'package:graduation_project/screens/user_books_screen.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';
import 'package:graduation_project/services/cubits/auth/auth_state.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationSettings =
      await FirebaseMessaging.instance.requestPermission(provisional: true);
  log('User granted permission: ${notificationSettings.authorizationStatus}');
  // String? token = await FirebaseMessaging.instance.getToken();
  // log('Token: $token');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit()..checkAuth(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.brown,
                brightness: Brightness.light,
              ),
              textTheme: GoogleFonts.rubikTextTheme(),
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
            routes: {
              '/start': (context) => const StartScreen(),
              '/main': (context) => const MainScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/book-details': (context) => const BookDetailsScreen(),
              '/your-books': (context) => const UserBooksScreen(),
              '/books': (context) => const BooksScreen(),
              '/add-book': (context) => const AddBookFormScreen(),
              '/edit-book': (context) => const EditBookScreen(),
              '/chat': (context) => const ChatScreen(),
              '/notifications': (context) => const NotificationsScreens(),
              '/profile': (context) => const ProfileScreen(),
              '/categories': (context) => const CategoriesScreen(),
            },
            home: BlocProvider.of<AuthCubit>(context).state is Authenticated
                ? const MainScreen()
                : const StartScreen(),
          );
        },
      ),
    );
  }
}
