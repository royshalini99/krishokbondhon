import 'package:flutter/material.dart';
import '../../../services/auth_serivce.dart';
import '../../../services/storage_service.dart';
import '../../../core/constants/app_colors.dart';

/// Admin-only screen listing experts awaiting approval. Only reachable
/// if the logged-in user's role is 'admin' (see profile_screen.dart's
/// conditional menu entry).
class AdminPendingExpertsScreen extends StatefulWidget {
  const AdminPendingExpertsScreen({super.key});

  @override
  State<AdminPendingExpertsScreen> createState() => _AdminPendingExpertsScreenState();
}

class _AdminPendingExpertsScreenState extends State<AdminPendingExpertsScreen> {
  final _authService = AuthService();
  bool _loading = true;
  String? _errorMessage;
  List<dynamic> _experts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final token = await StorageService.instance.getAuthToken();
    if (token == null) {
      setState(() {
        _loading = false;
        _errorMessage = 'Not logged in.';
      });
      return;
    }

    final result = await _authService.getPendingExperts(token);
    setState(() {
      _loading = false;
      if (result.error != null) {
        _errorMessage = result.error;
      } else {
        _experts = result.experts ?? [];
      }
    });
  }

  Future<void> _approve(String expertId) async {
    final token = await StorageService.instance.getAuthToken();
    if (token == null) return;

    final error = await _authService.approveExpert(expertId: expertId, token: token);
    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Expert approved.')));
      _load(); // refresh the list so the approved one disappears
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending expert approvals')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
              : _experts.isEmpty
                  ? const Center(child: Text('No pending experts right now.'))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _experts.length,
                        itemBuilder: (context, i) {
                          final expert = _experts[i] as Map<String, dynamic>;
                          final user = expert['User'] as Map<String, dynamic>?;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user?['name'] ?? 'Unknown', style: Theme.of(context).textTheme.titleMedium),
                                Text(user?['phone'] ?? '', style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 8),
                                Text('Institution: ${expert['institution'] ?? '-'}'),
                                Text('Specialty: ${expert['specialty'] ?? '-'}'),
                                if ((expert['credentialsDocUrl'] as String?)?.isNotEmpty ?? false)
                                  Text('Credentials: ${expert['credentialsDocUrl']}'),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () => _approve(expert['id'] as String),
                                    child: const Text('Approve'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}