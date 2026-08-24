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
  final _confirmPasswordController = TextEditingController();

  // Resident-only demo fields
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _occupationController = TextEditingController();

  final AuthService _authService = AuthService();

  String _selectedRole = 'RESIDENT';

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _errorMessage;

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Basic validation
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill all fields';
      });
      return;
    }

    // Resident-only demo validation
    if (_selectedRole == 'RESIDENT') {
      final phone = _phoneController.text.trim();
      final address = _addressController.text.trim();
      final occupation = _occupationController.text.trim();

      if (phone.isEmpty ||
          address.isEmpty ||
          occupation.isEmpty) {
        setState(() {
          _errorMessage =
              'Please complete all resident information';
        });
        return;
      }
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    if (password.length < 8) {
      setState(() {
        _errorMessage =
            'Password must be at least 8 characters';
      });
      return;
    }

    final emailRegex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w+$',
    );

    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _errorMessage =
            'Please enter a valid email address';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Only these fields go to backend
      await _authService.register(
        name: name,
        email: email,
        password: password,
        role: _selectedRole,
      );

      if (!mounted) return;

      final overlay = Overlay.of(context);

      final overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 30,
          left: 20,
          right: 20,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xCC0E6B6D),
                      Color(0xFF0A5A5F),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.20,
                      ),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Successfully registered!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      overlay.insert(overlayEntry);

      await Future.delayed(
        const Duration(seconds: 2),
      );

      overlayEntry.remove();

      if (!mounted) return;

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
    _confirmPasswordController.dispose();

    _phoneController.dispose();
    _addressController.dispose();
    _occupationController.dispose();

    super.dispose();
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF0A5A5F),
      ),
      suffixIcon: suffixIcon,
      labelStyle: const TextStyle(
        color: Color(0xFF737A74),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFD9E3DA),
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF0A5A5F),
          width: 1.7,
        ),
      ),
    );
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
                  // ==========================
                  // TOP IMAGE SECTION
                  // ==========================

                  SizedBox(
                    height: 290,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // CHANGE REGISTER IMAGE HERE
                        Image.asset(
                          'assets/images/register_background.jpg',
                          fit: BoxFit.cover,
                        ),

                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x44000000),
                                Color(0x99000000),
                              ],
                            ),
                          ),
                        ),

                        const Positioned(
                          left: 28,
                          bottom: 75,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Create your EcoMate account',
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

                  // ==========================
                  // REGISTER CARD
                  // ==========================

                  Transform.translate(
                    offset: const Offset(0, -55),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        24,
                        28,
                        24,
                        28,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withValues(
                              alpha: 0.12,
                            ),
                            blurRadius: 24,
                            offset:
                                const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Select Account Type',
                            style: TextStyle(
                              color: Color(0xFF505A52),
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ==========================
                          // ROLE SELECTOR
                          // ==========================

                          Row(
                            children: [
                              Expanded(
                                child: _roleButton(
                                  role: 'RESIDENT',
                                  label: 'Resident',
                                  icon:
                                      Icons.person_rounded,
                                ),
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: _roleButton(
                                  role: 'COLLECTOR',
                                  label: 'Collector',
                                  icon: Icons
                                      .local_shipping_rounded,
                                ),
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: _roleButton(
                                  role:
                                      'RECYCLING_OFFICER',
                                  label: 'Recycling',
                                  icon:
                                      Icons.recycling_rounded,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 26),

                          // ==========================
                          // COMMON FIELDS
                          // ==========================

                          TextField(
                            controller: _nameController,
                            decoration:
                                _fieldDecoration(
                              label: 'Full name',
                              icon:
                                  Icons.person_outline,
                            ),
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            controller:
                                _emailController,
                            keyboardType:
                                TextInputType
                                    .emailAddress,
                            decoration:
                                _fieldDecoration(
                              label:
                                  'Your email address',
                              icon:
                                  Icons.email_outlined,
                            ),
                          ),

                          // ==========================
                          // RESIDENT-ONLY DEMO FIELDS
                          // ==========================

                          if (_selectedRole ==
                              'RESIDENT') ...[
                            const SizedBox(height: 22),

                            Container(
                              padding:
                                  const EdgeInsets.all(
                                12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF1F7F5,
                                ),
                                borderRadius:
                                    BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons
                                        .home_work_outlined,
                                    size: 19,
                                    color: Color(
                                      0xFF0A5A5F,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Resident Information',
                                    style: TextStyle(
                                      color: Color(
                                        0xFF0A5A5F,
                                      ),
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            TextField(
                              controller:
                                  _phoneController,
                              keyboardType:
                                  TextInputType.phone,
                              decoration:
                                  _fieldDecoration(
                                label: 'Phone number',
                                icon:
                                    Icons.phone_outlined,
                              ),
                            ),

                            const SizedBox(height: 18),

                            TextField(
                              controller:
                                  _addressController,
                              decoration:
                                  _fieldDecoration(
                                label:
                                    'Residential address',
                                icon:
                                    Icons.home_outlined,
                              ),
                            ),

                            const SizedBox(height: 18),

                            TextField(
                              controller:
                                  _occupationController,
                              decoration:
                                  _fieldDecoration(
                                label: 'Occupation',
                                icon: Icons
                                    .work_outline_rounded,
                              ),
                            ),
                          ],

                          const SizedBox(height: 18),

                          // ==========================
                          // PASSWORD
                          // ==========================

                          TextField(
                            controller:
                                _passwordController,
                            obscureText:
                                _obscurePassword,
                            decoration:
                                _fieldDecoration(
                              label: 'Password',
                              icon:
                                  Icons.lock_outline,
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
                                  color: const Color(
                                    0xFF6E7970,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            controller:
                                _confirmPasswordController,
                            obscureText:
                                _obscureConfirmPassword,
                            decoration:
                                _fieldDecoration(
                              label:
                                  'Confirm password',
                              icon: Icons
                                  .lock_reset_outlined,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons
                                          .visibility_off_outlined
                                      : Icons
                                          .visibility_outlined,
                                  color: const Color(
                                    0xFF6E7970,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          if (_errorMessage !=
                              null) ...[
                            const SizedBox(height: 18),

                            Container(
                              padding:
                                  const EdgeInsets.all(
                                12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red
                                    .withValues(
                                  alpha: 0.07,
                                ),
                                borderRadius:
                                    BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color:
                                        Colors.redAccent,
                                    size: 19,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style:
                                          const TextStyle(
                                        color: Colors
                                            .redAccent,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 30),

                          // ==========================
                          // SIGN UP BUTTON
                          // ==========================

                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : _register,
                              style: ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                    const Color(
                                  0xFF0A5A5F,
                                ),
                                foregroundColor:
                                    Colors.white,
                                elevation: 0,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    24,
                                  ),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth:
                                            2.5,
                                        color:
                                            Colors.white,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        Text(
                                          'Sign up',
                                          style:
                                              TextStyle(
                                            fontSize:
                                                16,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          Icons
                                              .arrow_forward_rounded,
                                          size: 19,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ==========================
                  // LOGIN LINK
                  // ==========================

                  Transform.translate(
                    offset: const Offset(0, -35),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Color(0xFF777D78),
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator
                                .pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              color:
                                  Color(0xFF0A5A5F),
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
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
    final selected = _selectedRole == role;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRole = role;
          _errorMessage = null;
        });
      },
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF0A5A5F)
              : const Color(0xFFEAF3E9),
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? const Color(0xFF0A5A5F)
                : const Color(0xFFC8DEC9),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 23,
              color: selected
                  ? Colors.white
                  : const Color(0xFF0A5A5F),
            ),

            const SizedBox(height: 5),

            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : const Color(0xFF0A5A5F),
                fontSize: 11,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}