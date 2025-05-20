import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movieappprj/Models/User.dart';
import 'package:movieappprj/Screen_New/_HomePage.dart';
import 'package:movieappprj/Services/UserService.dart';
import '../Utils/constants.dart';
import 'package:movieappprj/Controllers/Slide_Change_Login_Register_Controller.dart';

class ScreenRsgLogin extends StatefulWidget {
  const ScreenRsgLogin({super.key});

  @override
  State<ScreenRsgLogin> createState() => _ScreenRsgLoginState();
}

class _ScreenRsgLoginState extends State<ScreenRsgLogin>
    with TickerProviderStateMixin {
  late SlideChangeLoginRegisterController controller;
  bool _isLoginSelected = true;
  bool _isHiddenPassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _passWord = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = SlideChangeLoginRegisterController(vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Util.isDarkMode(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.blue,
          padding: EdgeInsets.all(0),

          child: Stack(
            children: [
              Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: Util.appBarHeight - 30,
                      bottom: Util.defaultSpace,
                      left: Util.defaultSpace,
                      right: Util.defaultSpace,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          color: dark ? Colors.white : Colors.black,
                          height: 100,
                          image: AssetImage(Util.LOGO_TITLE),
                        ),

                        Text(
                          "Welcome To Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Center(
                          child: Text(
                            "Please enter your credentials to continue",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: Column(
                              children: [
                                _button_SLide_Change(context),

                                const SizedBox(height: 32),

                                _textField_Email(email: _email),

                                const SizedBox(height: 16),

                                _textField_Pasword(),

                                _Animation_UserName_Name(
                                  isLoginSelected: _isLoginSelected,
                                  userName: _userName,
                                  name: _name,
                                ),

                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        //handler
                                        if (!_isLoginSelected) {
                                          // register
                                          final regis =
                                              await UserService.HandlerRegister(
                                                _userName.text,
                                                _name.text,
                                                _email.text,
                                                _passWord.text,
                                              );

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                regis['success']
                                                    ? 'Đăng ký thành công!'
                                                    : regis['message'] ??
                                                        'Đăng ký thất bại!',
                                              ),
                                            ),
                                          );
                                        } else {
                                          //login
                                          try {
                                            final log =
                                                await UserService.HandlerLogin(
                                                  _email.text,
                                                  _passWord.text,
                                                );

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  log['success']
                                                      ? "Đăng nhập thành công"
                                                      : "Đăng nhập thất bại",
                                                ),
                                              ),
                                            );

                                            if (log['success']) {
                                              final user = User.fromJson(
                                                jsonDecode(log['message']),
                                              );
                                              User.setUser(user);
                                              if (User.user != null) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            const HomePageScreen(),
                                                  ),
                                                );
                                              } else {
                                                // Hiển thị thông báo lỗi
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      log['message'] ??
                                                          "Đăng nhập thất bại",
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          } catch (e) {
                                            print(e);
                                          }
                                        }
                                      }
                                    },
                                    child: Text(
                                      _isLoginSelected ? "Login" : "Register",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                const _divider(),

                                const SizedBox(height: 16),
                                //Footer
                                const _Footer(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _textField_Pasword() {
    return TextFormField(
      controller: _passWord,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Vui lòng nhập mật khẩu !";
        }
        return null;
      },
      obscureText: _isHiddenPassword, // Ẩn mật khẩu
      decoration: InputDecoration(
        prefixIcon: Icon(Iconsax.password_check),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _isHiddenPassword = !_isHiddenPassword;
            });
          },
          child: Icon(
            _isHiddenPassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
        labelText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Container _button_SLide_Change(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.blue),
      ),
      child: Stack(
        children: [
          SlideTransition(
            position: controller.slideAnimation,
            child: Container(
              width: MediaQuery.of(context).size.width / 2 - 25,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
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
                      controller.stopAnimation();
                    });
                  },
                  child: Center(
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: _isLoginSelected ? Colors.white : Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                      controller.startAnimation();
                    });
                  },
                  child: Center(
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(
                        color: !_isLoginSelected ? Colors.white : Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
}

class _Animation_UserName_Name extends StatelessWidget {
  const _Animation_UserName_Name({
    super.key,
    required bool isLoginSelected,
    required TextEditingController userName,
    required TextEditingController name,
  }) : _isLoginSelected = isLoginSelected,
       _userName = userName,
       _name = name;

  final bool _isLoginSelected;
  final TextEditingController _userName;
  final TextEditingController _name;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isLoginSelected ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          if (!_isLoginSelected) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _userName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên người dùng !';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.user_add),
                labelText: "UserName",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên !';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.user_search),
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],

          const SizedBox(height: 36),
        ],
      ),
    );
  }
}

class _textField_Email extends StatelessWidget {
  const _textField_Email({super.key, required TextEditingController email})
    : _email = email;

  final TextEditingController _email;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _email,
      decoration: InputDecoration(
        prefixIcon: Icon(Iconsax.direct_right),
        labelText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập tên đăng nhập !';
        }
        return null;
      },
    );
  }
}

class _divider extends StatelessWidget {
  const _divider({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = Util.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            color: dark ? Colors.black12 : Colors.grey,
            thickness: 0.5,
            indent: 60,
            endIndent: 5,
          ),
        ),
        Text("or Sign in With"),
        Flexible(
          child: Divider(
            color: dark ? Colors.black12 : Colors.grey,
            thickness: 0.5,
            indent: 5,
            endIndent: 60,
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(30),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              height: Util.iconSize,
              width: Util.iconSize,
              image: AssetImage(Util.google),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(30),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              height: Util.iconSize,
              width: Util.iconSize,
              image: AssetImage(Util.facebook),
            ),
          ),
        ),
      ],
    );
  }
}
