import 'package:flutter/material.dart';

import '../controllers/user_controller.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserController _userController = UserController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _validate({bool isRegister = false}) {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      return 'Vui lòng nhập đầy đủ Email và Password';
    }
    final emailRegex = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Email không hợp lệ';
    }
    if (isRegister && password.length < 6) {
      return 'Password phải có ít nhất 6 ký tự';
    }
    return null;
  }

  void _showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _signIn() async {
    final error = _validate();
    if (error != null) {
      _showMessage('Lỗi', error);
      return;
    }

    final user = await _userController.login(
      emailController.text.trim(),
      passwordController.text,
    );
    if (!mounted) return;

    if (user != null) {
      _showMessage(
        'Thành công',
        'Đăng nhập thành công!\nXin chào ${user.email}',
      );
    } else {
      _showMessage('Thất bại', 'Email hoặc Password không đúng');
    }
  }

  Future<void> _register() async {
    final error = _validate(isRegister: true);
    if (error != null) {
      _showMessage('Lỗi', error);
      return;
    }

    final ok = await _userController.register(
      User(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );
    if (!mounted) return;

    if (ok) {
      passwordController.clear();
      _showMessage('Thành công', 'Đăng ký thành công! Bạn có thể đăng nhập.');
    } else {
      _showMessage('Thất bại', 'Email này đã được đăng ký');
    }
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: 'Value',
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0B6FD8),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildField(
                  'Email',
                  emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildField('Password', passwordController, obscure: true),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('Sign in', _signIn),
                    _buildButton('Register', _register),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
