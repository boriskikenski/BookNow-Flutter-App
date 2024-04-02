import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? leadingOnPressed;

  const CustomAppBar({
    required this.title,
    this.leadingOnPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.amberAccent,
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: leadingOnPressed,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
