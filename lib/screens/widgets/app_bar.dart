import 'package:flutter/material.dart';
import 'package:graduation_project/screens/widgets/profile_appbar_widget.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}
