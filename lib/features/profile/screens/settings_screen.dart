import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _offlineMode = false;
  bool _dataSaver = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionLabel('Notifications'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Push notifications'),
            subtitle: const Text('Disease alerts, expert replies, community updates'),
            value: _pushNotifications,
            activeThumbColor: AppColors.primaryGreen,
            onChanged: (v) => setState(() => _pushNotifications = v),
          ),
          const Divider(height: 32),
          _SectionLabel('Data & storage'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Offline mode (Edge AI)'),
            subtitle: const Text('Run disease detection on-device without internet'),
            value: _offlineMode,
            activeThumbColor: AppColors.primaryGreen,
            onChanged: (v) => setState(() => _offlineMode = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Data saver'),
            subtitle: const Text('Reduce image quality on uploads'),
            value: _dataSaver,
            activeThumbColor: AppColors.primaryGreen,
            onChanged: (v) => setState(() => _dataSaver = v),
          ),
          const Divider(height: 32),
          _SectionLabel('About'),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('App version'),
            trailing: Text('0.1.0', style: TextStyle(color: AppColors.textSecondary)),
          ),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Privacy policy'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Terms of service'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 12.5),
      ),
    );
  }
}
