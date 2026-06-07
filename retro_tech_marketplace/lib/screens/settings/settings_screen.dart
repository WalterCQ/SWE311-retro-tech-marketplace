import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/logo_mark.dart';
import '../../widgets/navigation.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool privacy = true;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      child: ListView(
        padding: EdgeInsets.fromLTRB(22, 18, 22, 32),
        children: [
          TopBar(
            title: 'Settings',
            trailing: Icons.info_outline_rounded,
            onTrailingTap: () => Navigator.pushNamed(context, '/about'),
          ),
          SizedBox(height: 22),
          GlassCard(
            padding: EdgeInsets.all(18),
            child: Row(
              children: [
                LogoMark(size: 58),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Retro Tech',
                        style: AppTheme.h2.copyWith(fontSize: 16),
                      ),
                      Text(
                        '@retrotech',
                        style: AppTheme.body.copyWith(fontSize: 12),
                      ),
                      Text(
                        'Manage your marketplace preferences',
                        style: AppTheme.body.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18),
          GlassListSection(
            children: [
              _SettingsRow(
                Icons.person_outline_rounded,
                'Account',
                onTap: () => Navigator.pushNamed(context, '/edit-profile'),
              ),
              _SettingsSwitch(
                Icons.notifications_outlined,
                'Notifications',
                notifications,
                (v) => setState(() => notifications = v),
              ),
              _SettingsSwitch(
                Icons.lock_outline_rounded,
                'Privacy',
                privacy,
                (v) => setState(() => privacy = v),
              ),
              _SettingsRow(
                Icons.language_rounded,
                'Language',
                value: 'English',
              ),
              _SettingsRow(Icons.paid_outlined, 'Currency', value: 'MYR'),
              _SettingsRow(
                Icons.brush_outlined,
                'Theme',
                value: 'Liquid Glass',
              ),
              _SettingsRow(
                Icons.shield_outlined,
                'Help Center',
                onTap: () => Navigator.pushNamed(context, '/help'),
              ),
            ],
          ),
          SizedBox(height: 28),
          GlassCard(
            radius: 24,
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: Icon(Icons.logout_rounded, color: AppTheme.red),
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: AppTheme.red,
                  fontWeight: FontWeight.w900,
                ),
              ),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow(this.icon, this.label, {this.value, this.onTap});

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassListRow(icon: icon, title: label, value: value, onTap: onTap);
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch(this.icon, this.label, this.value, this.onChanged);

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppTheme.blue,
      secondary: Icon(icon, color: AppTheme.blue),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

