import 'package:app_salon_projek/API/auth.dart';
import 'package:app_salon_projek/Extension/navigator.dart';
import 'package:app_salon_projek/Model/login_model.dart';
import 'package:app_salon_projek/Share_Preferences/share_preferences.dart';
import 'package:app_salon_projek/view/layanan/salon_home_page.dart';
import 'package:app_salon_projek/view/register.dart';
import 'package:flutter/material.dart';

class LoginAPIScreen extends StatefulWidget {
  const LoginAPIScreen({super.key});
  static const id = "/login_api";
  @override
  State<LoginAPIScreen> createState() => _LoginAPIScreenState();
}

class _LoginAPIScreenState extends State<LoginAPIScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginModel? user;
  String? errorMessage;
  bool isLoading = false;
  bool isVisibility = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground(), buildLayer()]));
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email, Password, dan Nama tidak boleh kosong"),
        ),
      );
      isLoading = false;

      return;
    }
    try {
      final result = await AuthenticationAPI.loginUser(
        email: email,
        password: password,
      );
      setState(() {
        user = result;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Berhasil Masuk!!")));
      PreferenceHandler.saveToken(user?.data.token.toString() ?? "");
      print(user?.toJson());

      Future.delayed(Duration(milliseconds: 1500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SalonHomePage()),
        );
      });
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage.toString())));
    } finally {
      setState(() {});
      isLoading = false;
    }
  }

  SafeArea buildLayer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 90),
                Text(
                  "Hai! Ayo Masuk",
                  style: TextStyle(fontSize: 48, fontFamily: 'Allura'),
                ),
                
                Text(
                  "Masuk untuk menikmati perawatan diri",
                  // style: TextStyle(fontSize: 14, color: AppColor.gray88),
                ),
                height(24),
                buildTitle("Email Address"),
                height(12),
                buildTextField(
                  hintText: "Enter your email",
                  controller: emailController,
                ),
          
                height(16),
                buildTitle("Password"),
                height(12),
                buildTextField(
                  hintText: "Enter your password",
                  isPassword: true,
                  controller: passwordController,
                ),
                height(12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => MeetSebelas()),
                      // );
                    },
                    child: Text(
                      "Lupa Password?",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                height(24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      loginUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 245, 209, 200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      "Masuk",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 26, 25, 25),
                      ),
                    ),
                  ),
                ),
          
                height(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun?",
                     
                    ),
                    TextButton(
                      onPressed: () {
                        context.push(PostApiScreen());
                      },
                      child: Text(
                        "Daftar",
                        style: TextStyle(
                         
                          fontSize: 12,
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
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/backgroundLogin.jpg"),
          fit: BoxFit.cover,
        ),
       
      ),
    );
  }

  TextField buildTextField({
    String? hintText,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? isVisibility : false,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility_off : Icons.visibility,
                  // color: AppColor.gray88,
                ),
              )
            : null,
      ),
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);

  Widget buildTitle(String text) {
    return Row(
      children: [
        // Text(text, style: TextStyle(fontSize: 12, color: AppColor.gray88)),
      ],
    );
  }
}
