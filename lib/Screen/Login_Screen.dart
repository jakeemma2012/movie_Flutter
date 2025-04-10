import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  bool _isLoginSelected = true;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  final _formKey = GlobalKey<FormState>();  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  Color _backgroundColor = Colors.white;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(1, 0),
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        color: _backgroundColor,
        child: Scaffold(
          backgroundColor: _backgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: FadeTransition(
                opacity: _animation,
                child: Stack(
                  children: [
                    appBarMethod(),
                    Column(
                      children: [
                        const SizedBox(height: 130),
                        _logo_load(),
                        _button_login_register(context),
                        const SizedBox(height: 20),
                        _userNameTextField(),
                        const SizedBox(height: 20),
                        _passwordTextField(),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: _isLoginSelected ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              _emailTextField(),
                              const SizedBox(height: 20),
                              _confirmPasswordTextField(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      top:
                          _isLoginSelected
                              ? screenHeight * 0.55
                              : screenHeight * 0.7,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Thực hiện hành động đăng nhập
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(50, 60),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 30),
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
    );
  }

  AppBar appBarMethod() {
    return AppBar(
      backgroundColor: _backgroundColor,
      title: Text(
        'Welcome to Movie App',
        style: TextStyle(
          color: _backgroundColor == Colors.white ? Colors.black : Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFFF7F8F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.arrow_back),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            setState(() {
              _backgroundColor =
                  _backgroundColor == Colors.white
                      ? Color(0xFF121212)
                      : Colors.white;
            });
          },
          child: Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.sunny),
          ),
        ),
      ],
    );
  }

  Container _passwordTextField() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'PassWord',
          border: InputBorder.none,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          floatingLabelStyle: TextStyle(fontSize: 20, color: Colors.blue),
          contentPadding: EdgeInsets.only(left: 20),
        ),
        obscureText: true,
      ),
    );
  }

  Container _userNameTextField() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _usernameController,
        decoration: InputDecoration(
          labelText: 'User  Name',
          border: InputBorder.none,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          floatingLabelStyle: TextStyle(fontSize: 20, color: Colors.blue),
          contentPadding: EdgeInsets.only(left: 20),
        ),
      ),
    );
  }

  Container _emailTextField() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          border: InputBorder.none,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          floatingLabelStyle: TextStyle(fontSize: 20, color: Colors.blue),
          contentPadding: EdgeInsets.only(left: 20),
        ),
      ),
    );
  }

  Container _confirmPasswordTextField() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _confirmPasswordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          border: InputBorder.none,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          floatingLabelStyle: TextStyle(fontSize: 20, color: Colors.blue),
          contentPadding: EdgeInsets.only(left: 20),
        ),
      ),
    );
  }

  Container _button_login_register(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue),
      ),
      child: Stack(
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: MediaQuery.of(context).size.width / 2 - 20,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLoginSelected = true;
                      _slideController.reverse();
                    });
                  },
                  child: Center(
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: _isLoginSelected ? Colors.white : Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLoginSelected = false;
                      _slideController.forward();
                    });
                  },
                  child: Center(
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(
                        color: !_isLoginSelected ? Colors.white : Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _logo_load() {
    return Container(
      width: 250,
      height: 100,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(60),
      ),
      child: Image.asset('assets/images/logo_title.png', fit: BoxFit.contain),
    );
  }
}
