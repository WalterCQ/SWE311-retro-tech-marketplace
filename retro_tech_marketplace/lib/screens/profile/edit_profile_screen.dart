import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../widgets/glass_input.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/logo_mark.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final _displayName = TextEditingController(text: 'Retro Tech');
  final _username = TextEditingController(text: '@retrotech');
  final _email = TextEditingController(text: 'retro@tech.market');
  final _bio = TextEditingController(text: 'Collect rare. Live timeless.');
  final _location = TextEditingController(text: 'Kuala Lumpur');
  final _seller = TextEditingController(text: 'RetroTech Collector');
  final _contact = TextEditingController(text: 'In-app message');

  @override
  Widget build(BuildContext context) {
    return FormShell(
      title: 'Edit Profile',
      action: 'Save Profile',
      onSave: () => Navigator.pop(context),
      children: [
        Center(child: LogoMark(size: 110)),
        SizedBox(height: 20),
        GlassInput(
          controller: _displayName,
          hint: 'Display Name',
          icon: Icons.person_outline_rounded,
        ),
        SizedBox(height: 12),
        GlassInput(
          controller: _username,
          hint: 'Username',
          icon: Icons.alternate_email_rounded,
        ),
        SizedBox(height: 12),
        GlassInput(
          controller: _email,
          hint: 'Email',
          icon: Icons.email_outlined,
        ),
        SizedBox(height: 12),
        GlassInput(
          controller: _bio,
          hint: 'Bio',
          icon: Icons.edit_outlined,
          maxLines: 2,
        ),
        SizedBox(height: 12),
        GlassInput(
          controller: _location,
          hint: 'Location',
          icon: Icons.location_on_outlined,
        ),
        SizedBox(height: 24),
        Text('Marketplace Identity', style: AppTheme.h2.copyWith(fontSize: 16)),
        SizedBox(height: 12),
        GlassInput(
          controller: _seller,
          hint: 'Seller Name',
          icon: Icons.storefront_outlined,
        ),
        SizedBox(height: 12),
        GlassInput(
          controller: _contact,
          hint: 'Preferred Contact',
          icon: Icons.chat_bubble_outline_rounded,
        ),
      ],
    );
  }
}
