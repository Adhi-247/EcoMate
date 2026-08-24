import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'dashboards/resident_dashboard.dart';
import 'dashboards/collector_dashboard.dart';
import 'dashboards/recycling_dashboard.dart';
import 'dashboards/council_dashboard.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter email and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      final role = result['role'] as String;

      if (!mounted) return;

      Widget dashboard;

      switch (role) {
        case 'RESIDENT':
          dashboard = const ResidentDashboard();
          break;

        case 'COLLECTOR':
          dashboard = const CollectorDashboard();
          break;

        case 'RECYCLING_OFFICER':
          dashboard = const RecyclingDashboard();
          break;

        case 'COUNCIL_ADMIN':
          dashboard = const CouncilDashboard();
          break;

        default:
          throw Exception('Unknown user role: $role');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => dashboard,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: Column(
                children: [
                  // ===========================
                  // TOP IMAGE SECTION
                  // ===========================

                  SizedBox(
                    height: 320,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // CHANGE THIS IMAGE
                        Image.asset(
                          'assets/images/login_background.jpg',
                          fit: BoxFit.cover,
                        ),

                        // Dark transparent overlay
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x55000000),
                                Color(0x99000000),
                              ],
                            ),
                          ),
                        ),

                        // Welcome text
                        const Positioned(
                          left: 28,
                          bottom: 88,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Login to continue with EcoMate',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===========================
                  // LOGIN FORM CARD
                  // ===========================

                  Transform.translate(
                    offset: const Offset(0, -55),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        24,
                        30,
                        24,
                        28,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.12,
                            ),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          // EMAIL
                          TextField(
                            controller: _emailController,
                            keyboardType:
                                TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Color(0xFF003239),
                              ),
                              labelStyle: const TextStyle(
                                color: Color(0xFF69756D),
                              ),
                              enabledBorder:
                                  const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFD9E3DA),
                                ),
                              ),
                              focusedBorder:
                                  const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF003239),
                                  width: 1.7,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          // PASSWORD
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            onSubmitted: (_) => _login(),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF003239),
                              ),
                              labelStyle: const TextStyle(
                                color: Color(0xFF69756D),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword =
                                        !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons
                                          .visibility_off_outlined
                                      : Icons
                                          .visibility_outlined,
                                  color:
                                      const Color(0xFF6D8173),
                                ),
                              ),
                              enabledBorder:
                                  const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFD9E3DA),
                                ),
                              ),
                              focusedBorder:
                                  const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF003239),
                                  width: 1.7,
                                ),
                              ),
                            ),
                          ),

                          if (_errorMessage != null) ...[
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.redAccent,
                                    size: 19,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        color:
                                            Colors.redAccent,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 30),

                          // SIGN IN BUTTON
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed:
                                  _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF0A5A5F),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(25),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // CREATE ACCOUNT
                          SizedBox(
                            height: 52,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    const Color(0xFF003239),
                                side: const BorderSide(
                                  color: Color(0xFF9AC7A0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // BOTTOM REGISTER TEXT
                  Transform.translate(
                    offset: const Offset(0, -35),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            color: Color(0xFF777D78),
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Color(0xFF003239),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
}