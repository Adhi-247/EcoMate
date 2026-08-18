import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  String _selectedRole = 'RESIDENT';
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  final List<String> _roles = [
    'RESIDENT',
    'COLLECTOR',
    'RECYCLING_OFFICER',
  ];

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.register(
        name: name,
        email: email,
        password: password,
        role: _selectedRole,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registration successful. Please login.',
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage =
            'Registration failed. Email may already exist.';
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(
        color: Color(0xFF9CB8B3),
      ),
      hintStyle: const TextStyle(
        color: Color(0xFF66827E),
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF6FE3C1),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFF102D2F),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF1E4849),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF1E4849),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF68E1BF),
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071D20),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 480,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B2528),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFF163D3F),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.25,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xFFB7D4D0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF12383A),
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.eco_rounded,
                        color: Color(0xFF65E0BD),
                        size: 30,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'EcoMate Registration',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Create your account and become part of a cleaner, greener community.',
                      style: TextStyle(
                        color: Color(0xFF9AB5B1),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Select Account Type',
                      style: TextStyle(
                        color: Color(0xFFC9DEDA),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: _roleButton(
                            role: 'RESIDENT',
                            label: 'Resident',
                            icon: Icons.groups_rounded,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _roleButton(
                            role: 'COLLECTOR',
                            label: 'Collector',
                            icon:
                                Icons.local_shipping_rounded,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _roleButton(
                            role: 'RECYCLING_OFFICER',
                            label: 'Recycling',
                            icon:
                                Icons.recycling_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    TextField(
                      controller: _nameController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: _inputDecoration(
                        label: 'Full Name',
                        hint: 'Enter your name',
                        icon: Icons.person_outline,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _emailController,
                      keyboardType:
                          TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: _inputDecoration(
                        label: 'Email Address',
                        hint: 'name@example.com',
                        icon: Icons.email_outlined,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: _inputDecoration(
                        label: 'Secure Password',
                        hint: 'Enter password',
                        icon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF789B96),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Use a secure password for your EcoMate account.',
                      style: TextStyle(
                        color: Color(0xFF708F8B),
                        fontSize: 11,
                      ),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius:
                              BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.redAccent
                                .withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed:
                            _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF66DDBA),
                          foregroundColor:
                              const Color(0xFF07302C),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color:
                                      Color(0xFF07302C),
                                ),
                              )
                            : const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Color(0xFF91AAA7),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Login here',
                            style: TextStyle(
                              color: Color(0xFF68E1BF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleButton({
    required String role,
    required String label,
    required IconData icon,
  }) {
    final bool selected = _selectedRole == role;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF55D8B4)
              : const Color(0xFF102D2F),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? const Color(0xFF55D8B4)
                : const Color(0xFF1C4445),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: selected
                  ? const Color(0xFF06352F)
                  : const Color(0xFFA1BDB8),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected
                    ? const Color(0xFF06352F)
                    : const Color(0xFFA1BDB8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}