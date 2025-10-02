import 'package:flutter/material.dart';
import 'package:galleria_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInSignUpScreen extends StatefulWidget {
  const SignInSignUpScreen({super.key});

  @override
  State<SignInSignUpScreen> createState() => _SignInSignUpScreenState();
}

class _SignInSignUpScreenState extends State<SignInSignUpScreen>
    with TickerProviderStateMixin {
  static const background = Color(0xFF181818);
  static const surface = Color(0xFF1F1F1F);
  static const textPrimary = Colors.white;
  static const textSecondary = Colors.white70;

  // เพิ่มสีโทนส้ม (เหมือน onboarding)
  static const buttonGradientStart = Color(0xFFFF8A3D);
  static const buttonGradientEnd   = Color(0xFFFF5A0A);

  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  // Sign In
  final _inEmailCtrl = TextEditingController();
  final _inPassCtrl = TextEditingController();
  bool _inObscure = true;

  // Sign Up
  final _upEmailCtrl = TextEditingController();
  final _upPassCtrl = TextEditingController();
  final _upConfirmCtrl = TextEditingController();
  bool _upObscure = true;
  bool _upConfirmObscure = true;

  // เพิ่ม controller สำหรับ Name และ Phone (ใช้กับ Sign Up)
  final _upNameCtrl = TextEditingController();
  final _upPhoneCtrl = TextEditingController();

  // Animation controllers
  late AnimationController _logoAnimationController;
  late AnimationController _cardAnimationController;
  late AnimationController _buttonScaleController;
  late AnimationController _rippleController;

  late Animation<double> _logoAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _rippleAnimation;

  // Loading states
  bool _isSignInLoading = false;
  bool _isSignUpLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _buttonScaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Initialize animations
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoAnimationController, curve: Curves.elasticOut),
    );
    
    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeOutBack),
    );
    
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonScaleController, curve: Curves.easeInOut),
    );
    
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    // Start animations
    _logoAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _inEmailCtrl.dispose();
    _inPassCtrl.dispose();
    _upEmailCtrl.dispose();
    _upPassCtrl.dispose();
    _upConfirmCtrl.dispose();
    _upNameCtrl.dispose();
    _upPhoneCtrl.dispose();
    
    _logoAnimationController.dispose();
    _cardAnimationController.dispose();
    _buttonScaleController.dispose();
    _rippleController.dispose();
    
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: textSecondary),
      labelStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: const Color(0xFF202020),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey[800]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white54, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return AnimatedBuilder(
      animation: _buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScaleAnimation.value,
          child: SizedBox(
            height: 52,
            child: Stack(
              children: [
                // ปรับ Glow ให้เป็นโทนส้ม
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: (isLoading ? buttonGradientStart : buttonGradientEnd)
                              .withOpacity(isLoading ? 0.50 : 0.35),
                          blurRadius: isLoading ? 30 : 22,
                          spreadRadius: isLoading ? 3 : 1.5,
                        ),
                      ],
                    ),
                  ),
                ),
                // Ripple (คงเดิมได้)
                AnimatedBuilder(
                  animation: _rippleAnimation,
                  builder: (context, child) {
                    return Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(
                              (1 - _rippleAnimation.value) * 0.4,
                            ),
                            width: 2 * _rippleAnimation.value,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // ปุ่มหลัก (เปลี่ยน gradient เป็นส้ม)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTapDown: (_) {
                      _buttonScaleController.forward();
                      _rippleController.forward();
                    },
                    onTapUp: (_) => _buttonScaleController.reverse(),
                    onTapCancel: () => _buttonScaleController.reverse(),
                    onTap: isLoading ? null : onPressed,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isLoading
                              ? [
                                  buttonGradientStart.withOpacity(0.65),
                                  buttonGradientEnd.withOpacity(0.65),
                                ]
                              : [
                                  buttonGradientStart,
                                  buttonGradientEnd,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.05,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _outlinedButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 200),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: SizedBox(
            height: 52,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: onPressed,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]!),
                    borderRadius: BorderRadius.circular(18),
                    color: surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: Colors.white70, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (ctx) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Dialog(
                backgroundColor: const Color(0xFF1F1F1F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 800),
                        builder: (context, rotation, child) {
                          return Transform.rotate(
                            angle: rotation * 2 * 3.14159,
                            child: Container(
                              height: 72,
                              width: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.redAccent.withOpacity(0.45),
                                    blurRadius: 18,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 22),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        builder: (context, opacity, child) {
                          return Opacity(
                            opacity: opacity,
                            child: const Column(
                              children: [
                                Text(
                                  'Success',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Account created successfully.\nYou can now sign in.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white70, height: 1.3),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => Navigator.of(ctx).pop(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Dialog แจ้ง Error สั้นๆ
  Future<void> _showError(String msg) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Error', style: TextStyle(color: Colors.white)),
        content: Text(msg, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  // Sign In ด้วย Firebase Email/Password
  Future<void> _emailSignIn() async {
    if (!(_signInFormKey.currentState?.validate() ?? false)) return;
    setState(() => _isSignInLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _inEmailCtrl.text.trim(),
        password: _inPassCtrl.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const HomeScreen(),
          transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } on FirebaseAuthException catch (e) {
      final code = e.code.toLowerCase();
      String msg = e.message ?? e.code;
      if (code == 'invalid-email') msg = 'Invalid email.';
      if (code == 'user-not-found') msg = 'No user found for that email.';
      if (code == 'wrong-password' || code == 'invalid-credential' || code == 'invalid-login-credentials') {
        msg = 'Wrong password.';
      }
      await _showError(msg);
    } catch (e) {
      await _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSignInLoading = false);
    }
  }

  // Sign Up + บันทึกโปรไฟล์ลง Firestore
  Future<void> _emailSignUp() async {
    if (!(_signUpFormKey.currentState?.validate() ?? false)) return;
    setState(() => _isSignUpLoading = true);
    try {
      final email = _upEmailCtrl.text.trim();
      final pass = _upPassCtrl.text;
      final name = _upNameCtrl.text.trim();
      final phone = _upPhoneCtrl.text.trim();

      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // อัปเดต displayName (ถ้ากรอกชื่อ)
      if (name.isNotEmpty) {
        await cred.user?.updateDisplayName(name);
      }

      // สร้างเอกสารผู้ใช้ใน Firestore
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'email': email,
        'name': name,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // เคลียร์ฟอร์ม และกลับไปแท็บ Sign In
      _inEmailCtrl.text = email;
      _upEmailCtrl.clear();
      _upPassCtrl.clear();
      _upConfirmCtrl.clear();
      _upNameCtrl.clear();
      _upPhoneCtrl.clear();

      DefaultTabController.of(context)?.animateTo(0);
      _showSuccessDialog();
    } on FirebaseAuthException catch (e) {
      final code = e.code.toLowerCase();
      String msg = e.message ?? e.code;
      if (code == 'weak-password') msg = 'The password provided is too weak.';
      if (code == 'email-already-in-use') msg = 'The account already exists for that email.';
      if (code == 'invalid-email') msg = 'Invalid email.';
      await _showError(msg);
    } catch (e) {
      await _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSignUpLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                // Animated Logo
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoAnimation.value,
                      child: Transform.rotate(
                        angle: (1 - _logoAnimation.value) * 0.5,
                        child: Image.network(
                          'https://static.vecteezy.com/system/resources/thumbnails/027/385/442/small_2x/car-stainless-logo-png.png',
                          height: 110,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                // Animated Card
                AnimatedBuilder(
                  animation: _cardAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - _cardAnimation.value)),
                      child: Opacity(
                        opacity: _cardAnimation.value.clamp(0.0, 1.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: DefaultTabController(
                              length: 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Welcome',
                                    style: TextStyle(
                                      color: textPrimary,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Sign in or create a new account',
                                    style: TextStyle(color: textSecondary),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 54,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF232323),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(color: Colors.white24, width: 1),
                                      ),
                                      child: TabBar(
                                        padding: const EdgeInsets.all(6),
                                        labelPadding: EdgeInsets.zero,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        dividerColor: Colors.transparent,
                                        indicator: BoxDecoration(
                                          color: Colors.grey[900],
                                          borderRadius: BorderRadius.circular(14),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.5),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        labelColor: Colors.white,
                                        unselectedLabelColor: Colors.white60,
                                        labelStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                        tabs: const [
                                          Tab(child: SizedBox.expand(child: Center(child: Text('Sign In')))),
                                          Tab(child: SizedBox.expand(child: Center(child: Text('Sign Up')))),
                                        ],
                                        onTap: (index) {
                                          _rippleController.reset();
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  SizedBox(
                                    height: 420,
                                    child: TabBarView(
                                      children: [
                                        // Sign In Form
                                        Form(
                                          key: _signInFormKey,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: _inEmailCtrl,
                                                keyboardType: TextInputType.emailAddress,
                                                style: const TextStyle(color: textPrimary),
                                                decoration: _inputDecoration('Email', Icons.email_outlined),
                                                validator: (v) {
                                                  if (v == null || v.trim().isEmpty) return 'Enter email';
                                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'Invalid email';
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 14),
                                              TextFormField(
                                                controller: _inPassCtrl,
                                                obscureText: _inObscure,
                                                style: const TextStyle(color: textPrimary),
                                                decoration: _inputDecoration('Password', Icons.lock_outline).copyWith(
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _inObscure ? Icons.visibility_off : Icons.visibility,
                                                      color: Colors.white70,
                                                    ),
                                                    onPressed: () => setState(() => _inObscure = !_inObscure),
                                                  ),
                                                ),
                                                validator: (v) {
                                                  if (v == null || v.isEmpty) return 'Enter password';
                                                  if (v.length < 6) return 'At least 6 characters';
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 10),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    'Forgot password?',
                                                    style: TextStyle(color: Colors.white70),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              _primaryButton(
                                                label: 'Sign In',
                                                isLoading: _isSignInLoading,
                                                onPressed: _emailSignIn,
                                              ),
                                              const SizedBox(height: 14),
                                              Row(
                                                children: [
                                                  Expanded(child: Divider(color: Colors.white12)),
                                                  const Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: Text('or', style: TextStyle(color: Colors.white54)),
                                                  ),
                                                  Expanded(child: Divider(color: Colors.white12)),
                                                ],
                                              ),
                                              const SizedBox(height: 14),
                                              _outlinedButton(
                                                label: 'Continue with Google',
                                                icon: Icons.g_mobiledata_rounded,
                                                onPressed: () {
                                                  // TODO: integrate Google Sign-In
                                                },
                                              ),
                                              const SizedBox(height: 12),
                                              _outlinedButton(
                                                label: 'Continue with Facebook',
                                                icon: Icons.facebook,
                                                onPressed: () {
                                                  // TODO: integrate Facebook Login
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Sign Up Form
                                        Form(
                                          key: _signUpFormKey,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: _upEmailCtrl,
                                                keyboardType: TextInputType.emailAddress,
                                                style: const TextStyle(color: textPrimary),
                                                decoration: _inputDecoration('Email', Icons.email_outlined),
                                                validator: (v) {
                                                  if (v == null || v.trim().isEmpty) return 'Enter email';
                                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'Invalid email';
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 14),
                                              TextFormField(
                                                controller: _upPassCtrl,
                                                obscureText: _upObscure,
                                                style: const TextStyle(color: textPrimary),
                                                decoration: _inputDecoration('Password', Icons.lock_outline).copyWith(
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _upObscure ? Icons.visibility_off : Icons.visibility,
                                                      color: Colors.white70,
                                                    ),
                                                    onPressed: () => setState(() => _upObscure = !_upObscure),
                                                  ),
                                                ),
                                                validator: (v) {
                                                  if (v == null || v.isEmpty) return 'Enter password';
                                                  if (v.length < 6) return 'At least 6 characters';
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 14),
                                              TextFormField(
                                                controller: _upConfirmCtrl,
                                                obscureText: _upConfirmObscure,
                                                style: const TextStyle(color: textPrimary),
                                                decoration: _inputDecoration('Confirm Password', Icons.verified_user_outlined).copyWith(
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _upConfirmObscure ? Icons.visibility_off : Icons.visibility,
                                                      color: Colors.white70,
                                                    ),
                                                    onPressed: () => setState(() => _upConfirmObscure = !_upConfirmObscure),
                                                  ),
                                                ),
                                                validator: (v) {
                                                  if (v == null || v.isEmpty) return 'Confirm password';
                                                  if (v != _upPassCtrl.text) return 'Passwords do not match';
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 14),
                                              TextFormField(
                                                controller: _upNameCtrl,
                                                style: const TextStyle(color: textPrimary),
                                                decoration: _inputDecoration('Full Name', Icons.person_outline),
                                                validator: (v) {
                                                  if (v == null || v.trim().isEmpty) return 'Enter your name';
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 14),
                                              TextFormField(
                                                controller: _upPhoneCtrl,
                                                keyboardType: TextInputType.phone,
                                                style: const TextStyle(color: textPrimary),
                                                decoration: _inputDecoration('Phone Number', Icons.phone_android),
                                                validator: (v) {
                                                  if (v == null || v.trim().isEmpty) return 'Enter your phone number';
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              _primaryButton(
                                                label: 'Create Account',
                                                isLoading: _isSignUpLoading,
                                                onPressed: _emailSignUp,
                                              ),
                                            ],
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}