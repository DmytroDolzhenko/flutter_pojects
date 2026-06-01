import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'succes_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _staggeredController;
  late Animation<Offset> _emailOffset;
  late Animation<Offset> _passwordOffset;
  late Animation<Offset> _buttonOffset;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _logoVisible = false;
  bool _formContainerVisible = false;
  bool _isLoading = false;
  bool _isSuccess = false;
  bool _isError = false;

  double _buttonScale = 1.0;

  static const _customSlideCurve = Cubic(0.25, 1.0, 0.5, 1.0);

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = Tween<double>(begin: -10, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    _staggeredController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _emailOffset = Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _staggeredController,
        curve: const Interval(0.4, 0.7, curve: _customSlideCurve),
      ),
    );

    _passwordOffset = Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _staggeredController,
        curve: const Interval(0.55, 0.85, curve: _customSlideCurve),
      ),
    );

    _buttonOffset = Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _staggeredController,
        curve: const Interval(0.7, 1.0, curve: _customSlideCurve),
      ),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _logoVisible = true);
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _formContainerVisible = true);
        _staggeredController.forward();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _shakeController.dispose();
    _staggeredController.dispose();
    super.dispose();
  }

  void _shake() {
    _shakeController.reset();
    _shakeController.forward();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isError = false;
      _isSuccess = false;
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _isError = true);
      _shake();
      _showError('Please fill all fields');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (_emailController.text == 'test@test.com' && _passwordController.text == '123456') {
      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });

      await Future.delayed(const Duration(milliseconds: 2000));
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      _shake();
      _showError('Invalid credentials');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
        actions: [
          if (_isError)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _isError = false;
                  _isSuccess = false;
                  _isLoading = false;
                  _emailController.clear();
                  _passwordController.clear();
                });
                _staggeredController.reset();
                _staggeredController.forward();
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                AnimatedOpacity(
                  opacity: _logoVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: Hero(
                    tag: 'logo_hero',
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock, size: 80, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            bottom: _formContainerVisible ? 0 : -450,
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            child: Container(
              height: 450,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2, offset: Offset(0, -3)),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isSuccess
                    ? Center(
                        key: const ValueKey('success'),
                        child: Lottie.network(
                          'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/LottieLogo1.json',
                          width: 150,
                          height: 150,
                          repeat: false,
                        ),
                      )
                    : _isLoading
                        ? const Center(
                            key: ValueKey('loading'),
                            child: CircularProgressIndicator(),
                          )
                        : AnimatedBuilder(
                            key: const ValueKey('form'),
                            animation: _shakeAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(_shakeAnimation.value, 0),
                                child: child,
                              );
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  SlideTransition(
                                    position: _emailOffset,
                                    child: TextField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Email',
                                        prefixIcon: Icon(Icons.email),
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SlideTransition(
                                    position: _passwordOffset,
                                    child: TextField(
                                      controller: _passwordController,
                                      decoration: const InputDecoration(
                                        labelText: 'Password',
                                        prefixIcon: Icon(Icons.lock),
                                        border: OutlineInputBorder(),
                                      ),
                                      obscureText: true,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  SlideTransition(
                                    position: _buttonOffset,
                                    child: GestureDetector(
                                      onTapDown: (details) => setState(() => _buttonScale = 0.95),
                                      onTapUp: (details) => setState(() => _buttonScale = 1.0),
                                      onTapCancel: () => setState(() => _buttonScale = 1.0),
                                      child: AnimatedScale(
                                        scale: _buttonScale,
                                        duration: const Duration(milliseconds: 100),
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: _login,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                            child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                    ),
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
    );
  }
}