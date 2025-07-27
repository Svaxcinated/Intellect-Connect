import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  // You can pass logo asset as a parameter for full editability
  final String logoAsset;

  const LoginPage({
    Key? key,
    this.logoAsset = 'assets/logo_green.png',
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _warningMessage;
  bool _isLoading = false;
  String? _infoMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> _isValidEmail(String email) async {
    // Simple regex for email validation
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');
    return emailRegex.hasMatch(email);
  }

  Future<bool> _emailExists(String email) async {
    try {
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void _login() async {
    setState(() {
      _isLoading = true;
      _warningMessage = null;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _warningMessage = 'Please enter both email and password.';
        _isLoading = false;
      });
      return;
    }
    if (!await _isValidEmail(email)) {
      setState(() {
        _warningMessage = 'Please enter a valid email address.';
        _isLoading = false;
      });
      return;
    }
    final exists = await _emailExists(email);
    if (!exists) {
      setState(() {
        _warningMessage = 'No account found for this email. Please sign up first.';
        _isLoading = false;
      });
      return;
    }
    // TODO: Add your actual authentication logic here
    setState(() {
      _isLoading = false;
    });
    Navigator.pushReplacementNamed(context, '/home');
  }

  // Remove broken GoogleSignIn code
  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: ['email'],
  // );
  Future<void> _handleGoogleSignIn() async {
    setState(() { _isLoading = true; _warningMessage = null; });
    try {
      final user = await GoogleSignInService.signInWithGoogle();
      if (user == null) {
        setState(() { _isLoading = false; _warningMessage = 'Google sign-in cancelled.'; });
        return;
      }
      // TODO: Check Firestore for user existence, navigate, etc.
      setState(() { _isLoading = false; });
    } catch (e) {
      setState(() { _warningMessage = 'Google sign-in error: \n${e.toString()}'; _isLoading = false; });
    }
  }
  

  Future<void> sendSignInLink(String email) async {
    final ActionCodeSettings acs = ActionCodeSettings(
      url: 'https://www.example.com/finishSignUp', // TODO: Replace with your actual redirect URL
      handleCodeInApp: true,
      androidPackageName: 'com.example.android', // TODO: Replace with your Android package name
      androidInstallApp: true,
      androidMinimumVersion: '12',
      iOSBundleId: 'com.example.ios', // TODO: Replace with your iOS bundle ID
    );
    try {
      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: acs,
      );
      setState(() {
        _infoMessage = 'Sign-in link sent to $email. Check your email to continue.';
      });
    } catch (e) {
      setState(() {
        _warningMessage = 'Failed to send sign-in link: \n${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFFF5F5F5),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFB5D8C6)),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Image.asset(
                  widget.logoAsset,
                  width: 120,
                  height: 120,
                  color: const Color(0xFF98CDB0),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to your Account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),
                if (_warningMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _warningMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Email field with asset icon
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Color(0xFF98CDB0)),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Color(0xFF98CDB0),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Password field with asset icon
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF98CDB0)),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Color(0xFF98CDB0),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Log in button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF98CDB0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Log in', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 16),
                // Google Sign-In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Image.asset(
                      'assets/logo_green.png', // You can use a Google logo asset if available
                      width: 24,
                      height: 24,
                    ),
                    label: const Text('Continue with Gmail', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Color(0xFF98CDB0)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    onPressed: _isLoading ? null : _handleGoogleSignIn,
                  ),
                ),
                const SizedBox(height: 16),
                // Email Link Sign-In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            final email = _emailController.text.trim();
                            if (email.isEmpty) {
                              setState(() {
                                _warningMessage = 'Please enter your email to receive a sign-in link.';
                              });
                              return;
                            }
                            setState(() { _isLoading = true; _warningMessage = null; _infoMessage = null; });
                            await sendSignInLink(email);
                            setState(() { _isLoading = false; });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Send Sign-In Link to Email', style: TextStyle(fontSize: 18)),
                  ),
                ),
                if (_infoMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _infoMessage!,
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an Account? ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        'Sign up here',
                        style: TextStyle(
                          color: Color(0xFF98CDB0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
