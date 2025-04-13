import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:movieappprj/Controllers/Login_Controller.dart';
import 'package:movieappprj/Utils/constants.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movieappprj/Controllers/Slide_Change_Login_Register_Controller.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Util.isDarkMode(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: Util.appBarHeight,
                bottom: Util.defaultSpace,
                left: Util.defaultSpace,
                right: Util.defaultSpace,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    color: dark ? Colors.white : Colors.black,
                    height: 150,
                    image: AssetImage(Util.LOGO_TITLE),
                  ),

                  Text(
                    "Welcome To Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Iconsax.direct_right),
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            obscureText: true, // Ẩn mật khẩu
                            decoration: InputDecoration(
                              prefixIcon: Icon(Iconsax.password_check),
                              suffixIcon: Icon(Iconsax.eye_slash),
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Stack(
                              children: [
                                //    SlideTransition(position: Slide_Change_Login_Register_Controller)
                              ],
                            ),
                          ),

                          const SizedBox(height: 36),
                          Row(
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
                          ),

                          const SizedBox(height: 16),

                          Row(
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
                          ),
                        ],
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
  }
}
