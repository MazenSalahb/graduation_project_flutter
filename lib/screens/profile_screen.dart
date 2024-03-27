import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';
import 'package:graduation_project/services/cubits/auth/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return AuthProfileWidget(
            name: state.user.data!.name!,
            profileImage: state.user.data!.profilePicture!,
          );
        } else if (state is NotAuthenticated) {
          return Scaffold(
            body: Center(
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
                  const Text('to view your profile.')
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class AuthProfileWidget extends StatelessWidget {
  const AuthProfileWidget({
    super.key,
    required this.name,
    required this.profileImage,
  });
  final String name;
  final String profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.network(profileImage, height: 100, width: 100),
              const SizedBox(height: 6),
              Text(
                name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Divider(
                // Add a horizontal line
                color: Colors.grey,
                thickness: 2,
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Edit Profile'),
                onTap: () {
                  // Navigate to the profile screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.book_outlined),
                title: const Text('Your Books'),
                onTap: () {
                  // Navigate to the Books screen
                  Navigator.of(context).pushNamed('/your-books');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Log Out'),
                onTap: () {
                  // Logout user
                  context.read<AuthCubit>().logout();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
