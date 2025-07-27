import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // disable swiping
        children: [
          // 🔹 Page 1
          Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/welcome_page.png',
                fit: BoxFit.cover,
              ),
              Container(color: Colors.black.withOpacity(0.5)),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome to Intellect Connect',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Connect, learn, and grow with us!',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all(const Color(0xFF59A8B6)),
                          side: WidgetStateProperty.all(const BorderSide(
                            color: Color(0xFF77BDCC),
                            width: 2,
                          )),
                          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                          backgroundColor: WidgetStateProperty.all(Colors.transparent),
                          elevation: WidgetStateProperty.all(0),
                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return const Color(0xFF59A8B6).withOpacity(0.15);
                              }
                              return null;
                            },
                          ),
                        ),

                        child: const Text('Next', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),

          // 🔹 Page 2
          Stack(
            fit: StackFit.expand,
            children: [
              // 1. White base background
              Container(color: Colors.white),

              // 2. Your custom background with bottom rounded corners
              Align(
                alignment: Alignment.topCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: Image.asset(
                    'assets/get_bg.png', // your background
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.6,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 3. Content with logo, text, and button
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Positioned(
                            left: 4,
                            top: 4,
                            child: Opacity(
                              opacity: 0.3,
                              child: Image.asset(
                                'assets/logo_bg.png',
                                width: 300,
                                fit: BoxFit.contain,
                                color: Colors.black,
                                colorBlendMode: BlendMode.srcIn,
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/logo_bg.png',
                            width: 300,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 31),
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF59A8B6),
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'INTELLECT CONNECT',
                      style: TextStyle(
                        color: Color(0xFF59A8B6),
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'I See, I Connect',
                      style: TextStyle(
                        color: Color(0xFF59A8B6),
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all(const Color(0xFF59A8B6)),
                          side: WidgetStateProperty.all(const BorderSide(
                            color: Color(0xFF77BDCC),
                            width: 2,
                          )),
                          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                          backgroundColor: WidgetStateProperty.all(Colors.transparent),
                          elevation: WidgetStateProperty.all(0),
                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return const Color(0xFF59A8B6).withOpacity(0.15);
                              }
                              return null;
                            },
                          ),
                        ),

                        child: const Text(
                          'Get Started',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Example login function
Future<void> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Navigate to home or show success
  } on FirebaseAuthException catch (e) {
    // Handle error
  }
}