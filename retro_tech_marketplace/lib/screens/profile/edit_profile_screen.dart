import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../models/user_profile.dart';
import '../../store/listing_store.dart';
import '../../widgets/glass_input.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/logo_mark.dart';
import '../../widgets/navigation.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.store});

  final ListingStore store;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final _displayName = TextEditingController(
    text: widget.store.profile.displayName,
  );
  late final _username = TextEditingController(
    text: widget.store.profile.username,
  );
  late final _email = TextEditingController(text: widget.store.profile.email);
  late final _bio = TextEditingController(text: widget.store.profile.bio);
  late final _location = TextEditingController(
    text: widget.store.profile.location,
  );
  late final _seller = TextEditingController(
    text: widget.store.profile.sellerName,
  );
  late final _contact = TextEditingController(
    text: widget.store.profile.preferredContact,
  );

  @override
  void dispose() {
    _displayName.dispose();
    _username.dispose();
    _email.dispose();
    _bio.dispose();
    _location.dispose();
    _seller.dispose();
    _contact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormShell(
      title: 'Edit Profile',
      action: 'Save Profile',
      onSave: () {
        _save();
      },
      children: [
        Center(child: LogoMark(size: 110, heroTag: accountLogoHeroTag)),
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

  Future<void> _save() async {
    await widget.store.saveProfile(
      UserProfile(
        displayName: _displayName.text.trim().isEmpty
            ? UserProfile.defaults.displayName
            : _displayName.text.trim(),
        username: _username.text.trim().isEmpty
            ? UserProfile.defaults.username
            : _username.text.trim(),
        email: _email.text.trim().isEmpty
            ? UserProfile.defaults.email
            : _email.text.trim(),
        bio: _bio.text.trim().isEmpty
            ? UserProfile.defaults.bio
            : _bio.text.trim(),
        location: _location.text.trim().isEmpty
            ? UserProfile.defaults.location
            : _location.text.trim(),
        sellerName: _seller.text.trim().isEmpty
            ? UserProfile.defaults.sellerName
            : _seller.text.trim(),
        preferredContact: _contact.text.trim().isEmpty
            ? UserProfile.defaults.preferredContact
            : _contact.text.trim(),
      ),
    );
    if (mounted) Navigator.pop(context);
  }
}
