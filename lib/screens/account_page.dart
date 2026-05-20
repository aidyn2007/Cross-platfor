import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:books/constants.dart';
import 'package:books/models/models.dart';
import 'package:books/providers.dart';
import 'package:books/providers/profile_provider.dart';

class AccountPage extends ConsumerStatefulWidget {
  final User user;

  const AccountPage({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<AccountPage> createState() => AccountPageState();
}

class AccountPageState extends ConsumerState<AccountPage> {
  bool _loggingOut = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final profile = ref.watch(profileProvider);
    
    // Получаем количество сохраненных книг из репозитория
    final bookData = ref.watch(repositoryProvider);
    final points = bookData.currentBooks.length * 100;

    final displayName = (profile.firstName.isEmpty && profile.lastName.isEmpty)
        ? widget.user.firstName
        : '${profile.firstName} ${profile.lastName}';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.surface,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    displayName,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.user.role,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    color: colorScheme.secondaryContainer.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stars, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            '$points Points',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Settings'),
                  _buildMenuItem(
                    context,
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    onTap: () {
                      context.go('/${BooksTab.account.value}/personal-info');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.history,
                    title: 'Order History',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  _buildSectionHeader('Support'),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    onTap: () async {
                      await launchUrl(Uri.parse('https://www.kodeco.com/'));
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'About Books',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: colorScheme.error),
                        foregroundColor: colorScheme.error,
                      ),
                      icon: _loggingOut
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.logout),
                      label: Text(_loggingOut ? 'Logging out...' : 'Log Out'),
                      onPressed: _loggingOut ? null : _logOut,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logOut() async {
    setState(() => _loggingOut = true);
    try {
      await ref.read(userDaoProvider).logout();
      if (!mounted) return;
      context.go('/login');
    } catch (error) {
      if (!mounted) return;
      setState(() => _loggingOut = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not log out: $error')),
      );
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, top: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
