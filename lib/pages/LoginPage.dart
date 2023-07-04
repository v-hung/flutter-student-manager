import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_student_manager/repositories/AuthRepository.dart';
import 'package:flutter_student_manager/repositories/TeacherRepository.dart';
import 'package:flutter_student_manager/utils/color.dart';
import 'package:flutter_student_manager/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_student_manager/controllers/AuthController.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
      extendBodyBehindAppBar: true,
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xfff0f2f5),
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => context.pop(),
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
                        Text(
                          "Cẩn thận, bất kỳ ai có tài khoản của bạn đều có thể truy cập vào ứng dụng",
                          style: TextStyle(
                            color: Colors.grey[800]!
                          ),
                          textAlign: TextAlign.left,
                        ),
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
                        const SizedBox(height: 15,),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              final value = await showCupertinoModalBottomSheet(
                                context: context,
                                builder: (context) => RegisterWidget(type: widget.type,),
                              );

                              if (value != null) {
                                if (value['email'] != null) {
                                  emailController.text = value['email'];
                                }
                                if (value['password'] != null) {
                                  passwordController.text = value['password'];
                                }
                                // setState(() {});
                              }
                            }, 
                            child: const Text("Đăng ký tài khoản")
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
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: primary2,
                      minimumSize: const Size(double.infinity, 48),
                      elevation: 0.0,
                      shadowColor: Colors.transparent,
                    ),
                    child: loading ? const CircularProgressIndicator() : const Text("Login"),
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

class RegisterWidget extends ConsumerStatefulWidget {
  final String type;
  const RegisterWidget({required this.type, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends ConsumerState<RegisterWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void signInWithPassword() async {
    if (loading) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    final bool check = await ref.read(authRepositoryProvider).register(
      _emailController.text, 
      _passwordController.text,
      _nameController.text,
      widget.type
    );

    setState(() {
      loading = false;
    });

    if (context.mounted && check) {
      Navigator.pop(context, {
        "email": _emailController.text,
        "password": _passwordController.text
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            child: Form(
              key: _formKey,
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: Text("Tạo tài khoản", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600), textAlign: TextAlign.center,)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Nếu bạn đã có tài khoản? "),
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Đăng nhập"))
                      ],
                    ),

                    const SizedBox(height: 20,),
                    Text("Họ tên", style: TextStyle(color: Colors.grey[700]!, fontWeight: FontWeight.w500),),
                    const SizedBox(height: 5,),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey)
                        ),
                        hintText: 'Nhập tên',
                        hintStyle: const TextStyle(fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12)
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Tên không được để trống';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20,),
                    Text("Tên tài khoản", style: TextStyle(color: Colors.grey[700]!, fontWeight: FontWeight.w500),),
                    const SizedBox(height: 5,),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey)
                        ),
                        hintText: 'Nhập tên tài khoản',
                        hintStyle: const TextStyle(fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12)
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tên tài khoản không được để trống';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20,),
                    Text("Mật khẩu", style: TextStyle(color: Colors.grey[700]!, fontWeight: FontWeight.w500),),
                    const SizedBox(height: 5,),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey)
                        ),
                        hintText: 'Nhập mật khẩu',
                        hintStyle: const TextStyle(fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12)
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mật khẩu không được để trống';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20,),
                    Text("Nhập lại mật khẩu", style: TextStyle(color: Colors.grey[700]!, fontWeight: FontWeight.w500),),
                    const SizedBox(height: 5,),
                    TextFormField(
                      controller: _rePasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey)
                        ),
                        hintText: 'Nhập lại mật khẩu',
                        hintStyle: const TextStyle(fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12)
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Nhập lại mật khẩu phải giống mật khẩu';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 30,),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: loading ? null : signInWithPassword,
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: primary2,
                          minimumSize: const Size(double.infinity, 48),
                          elevation: 0.0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                        ),
                        child: loading ? const CircularProgressIndicator() : const Text("Login"),
                      )
                    ),
                  ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}