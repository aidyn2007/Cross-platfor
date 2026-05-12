import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';

typedef LogoutCallback = void Function(bool didLogout);

class AccountPage extends StatefulWidget {
  final User user;
  final LogoutCallback onLogOut;

  const AccountPage({
    super.key,
    required this.onLogOut,
    required this.user,
  });

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: colorScheme.primary,
                        child: CircleAvatar(
                          radius: 47.0,
                          backgroundImage: AssetImage(widget.user.profileImageUrl),
                        ),
                      ),
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
                    '${widget.user.firstName} ${widget.user.lastName}',
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.user.role,
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.secondary),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    color: colorScheme.secondaryContainer.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stars, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.user.points} Points',
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
                    onTap: () {},
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
                    title: 'About Yummy',
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
                      icon: const Icon(Icons.logout),
                      label: const Text('Log Out'),
                      onPressed: () => widget.onLogOut(true),
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

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
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
