import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Hero(
              tag: 'login_logo_hero',
              child: Icon(Icons.lock_open_rounded, size: 100, color: Colors.blue),
            ),
            const SizedBox(height: 24),
            Text('Welcome Back!', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class CustomBouncyCurve extends Curve {
  const CustomBouncyCurve();

  @override
  double transformInternal(double t) {
    // Кубічна Безьє (Cubic Bezier) для ефекту "гумового" відскоку форми
    return const Cubic(0.68, -0.6, 0.32, 1.6).transform(t);
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  // Контролери полів введення (TODO 8)
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  bool _logoVisible = false;
  bool _formVisible = false;
  bool _isLoading = false;
  bool _isSuccess = false;

  bool _emailFieldVisible = false;
  bool _passwordFieldVisible = false;
  bool _buttonVisible = false;

  double _buttonScale = 1.0;    
  double _checkmarkScale = 0.0;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    _runAnimationTimeline();
  }

  void _runAnimationTimeline() {
    // 1. Поява логотипу (TODO 2)
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _logoVisible = true);
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _formVisible = true);
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _emailFieldVisible = true);
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _passwordFieldVisible = true);
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _buttonVisible = true);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShakeAnimation() {
    _shakeController.reset();
    _shakeController.forward().then((_) => _shakeController.reverse());
  }

  Future<void> _handleLogin() async {
    if (_isLoading || _isSuccess) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _triggerShakeAnimation();
      _showSnackBar('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (email == 'test@test.com' && password == '123456') {
      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });

      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) setState(() => _checkmarkScale = 1.0);

      await Future.delayed(const Duration(milliseconds: 2000));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      setState(() => _isLoading = false);
      _triggerShakeAnimation();
      _showSnackBar('Invalid email or password');
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade900, Colors.purple.shade900],
                  ),
                ),
              ),
            ),

            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _logoVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                child: const Center(
                  child: Hero(
                    tag: 'login_logo_hero', // Варіант A
                    child: Icon(Icons.lock_rounded, size: 85, color: Colors.white),
                  ),
                ),
              ),
            ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 700),
              curve: const CustomBouncyCurve(), // Варіант D
              bottom: _formVisible ? 0 : -size.height * 0.6,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: Container(
                  height: size.height * 0.6,
                  padding: EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 32 + bottomInset),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300), 
                    child: _isSuccess
                        ? _buildSuccessState() 
                        : _isLoading
                            ? _buildLoadingState() 
                            : _buildFormFields(),  
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      key: const ValueKey('form_fields_key'), 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sign In', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),

        AnimatedOpacity(
          opacity: _emailFieldVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            transform: Matrix4.translationValues(0, _emailFieldVisible ? 0 : 20, 0), // Підйом знизу вгору
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        AnimatedOpacity(
          opacity: _passwordFieldVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            transform: Matrix4.translationValues(0, _passwordFieldVisible ? 0 : 20, 0),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),

        AnimatedOpacity(
          opacity: _buttonVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _buttonScale = 0.93),
            onTapUp: (_) => setState(() => _buttonScale = 1.0),
            onTapCancel: () => setState(() => _buttonScale = 1.0),
            onTap: _handleLogin,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              transform: Matrix4.identity()..scale(_buttonScale),
              transformAlignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      key: ValueKey('loading_state_key'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 4),
          SizedBox(height: 20),
          Text('Connecting to Midas CRM...', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Center(
      key: const ValueKey('success_state_key'),
      child: AnimatedScale(
        scale: _checkmarkScale,
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://fonts.gstatic.com/s/a/bca7b189/8/data.json',
              width: 130,
              height: 130,
              repeat: false,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.check_circle, color: Colors.green, size: 100);
              },
            ),
            const SizedBox(height: 16),
            const Text('Authorized!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}