import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:flutter_student_manager/utils/color.dart';

class LoginPage extends ConsumerStatefulWidget {
  final String type;
  const LoginPage({required this.type, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  bool showPassword = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signInWithPassword() async {
    setState(() {
      loading = true;
    });
    await ref.read(authControllerProvider.notifier).signInWithPassword(
      context,
      emailController.text, 
      passwordController.text
    );
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => context.go('/you-are'),
          icon: const Icon(CupertinoIcons.xmark, color: Colors.black,)
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,),
          constraints: BoxConstraints(
            minHeight: size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                // const SizedBox(height: 50,),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // width: 300,
                          height: 200,
                          alignment: Alignment.center,
                          child: widget.type == "student" 
                            ? Image.asset("assets/img/parents_bg.png",)
                            : Image.asset("assets/img/teacher_bg.png",)
                        ),
                        // const SizedBox(height: 10),
                        const Text(
                          "Nhập tài khoản và mật khẩu của bạn",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Cẩn thận, bất kỳ ai có tài khoản của bạn đều có thể truy cập vào ứng dụng",
                          style: TextStyle(
                            color: Colors.grey
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Tài khoản',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(CupertinoIcons.mail),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                            labelText: 'Mặt khẩu',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() {showPassword = !showPassword;}),
                              icon: Icon(showPassword ? CupertinoIcons.lock_open : CupertinoIcons.lock)
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: loading ? null : signInWithPassword,
                    child: loading ? const CircularProgressIndicator() : const Text("Login"),
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: primary2,
                      minimumSize: const Size(double.infinity, 48),
                      elevation: 0.0,
                      shadowColor: Colors.transparent,
                    ),
                  )
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}