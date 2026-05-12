import 'package:flutter/material.dart';

/// Credential Class
class Credentials {
  Credentials(this.username, this.password);
  final String username;
  final String password;
}

class LoginPage extends StatelessWidget {
  const LoginPage({required this.onLogIn, super.key});

  /// Called when users sign in with [Credentials].
  final ValueChanged<Credentials> onLogIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth > 700) {
                  // Display Desktop View
                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Center(
                            child: Hero(
                              tag: 'login-logo',
                              child: Image.asset(
                                'assets/yummy_logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Card(
                            margin: const EdgeInsets.all(32.0),
                            elevation: 8,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: LoginForm(onLogIn: onLogIn),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Display Mobile View
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'login-logo',
                            child: Image.asset(
                              'assets/yummy_logo.png',
                              height: 120,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: LoginForm(onLogIn: onLogIn),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final ValueChanged<Credentials> onLogIn;
  const LoginForm({required this.onLogIn, super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome Back',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          onPressed: () async {
            widget.onLogIn(Credentials(_usernameController.text, _passwordController.text));
          },
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: const Text('Forgot Password?'),
        ),
      ],
    );
  }
}
