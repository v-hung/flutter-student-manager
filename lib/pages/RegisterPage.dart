import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';

class Register extends ConsumerStatefulWidget {
  final String type;
  const Register({required this.type, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  bool showPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signInWithPassword() async {
    setState(() {
      loading = true;
    });
    await ref.read(authControllerProvider.notifier).signInWithPassword(
      context,
      emailController.text, 
      passwordController.text,
      widget.type
    );
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xfff0f2f5),
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //   statusBarColor: Color(0xfff0f2f5),
        //   statusBarIconBrightness: Brightness.dark,
        //   statusBarBrightness: Brightness.light,
        // ),
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => context.go('/login?type=${widget.type}'),
          icon: const Icon(CupertinoIcons.back, color: Colors.black,)
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const Text(
                      "Đăng ký tài khoản giáo viên",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Tài khoản',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(CupertinoIcons.mail),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextField(
                              controller: passwordController,
                              obscureText: !showPassword,
                              decoration: InputDecoration(
                                labelText: 'Mặt khẩu',
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: IconButton(
                                  onPressed: () => setState(() {showPassword = !showPassword;}),
                                  icon: Icon(showPassword ? CupertinoIcons.lock_open : CupertinoIcons.lock)
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
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
          );
        }
      ),
    );
  }
}