import 'package:cartridge/main.dart';
import 'package:cartridge/providers/setting_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart' as material;
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpDialog extends ConsumerStatefulWidget {
  const SignUpDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpDialogState();
}

class _SignUpDialogState extends ConsumerState<SignUpDialog> {
  bool _isChanged = false;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nicknameController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nicknameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  Future<void> onSignUp() async {
    final supabase = Supabase.instance.client;

    final email = _emailController.text;
    final password = _passwordController.text;
    final nickname = _nicknameController.text;

    await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'display_name': nickname,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('회원가입'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: '이메일',
              child: TextFormBox(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해주세요.';
                  }

                  return null;
                },
                controller: _emailController,
              ),
            ),
            const SizedBox(height: 16.0),
            InfoLabel(
              label: '비밀번호',
              child: PasswordFormBox(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요.';
                  }

                  return null;
                },
                controller: _passwordController,
              ),
            ),
            const SizedBox(height: 16.0),
            InfoLabel(
              label: '닉네임',
              child: TextFormBox(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '닉네임을 입력해주세요.';
                  }

                  return null;
                },
                controller: _nicknameController,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Button(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            onSignUp();
            Navigator.pop(context);
          },
          child: const Text('회원가입'),
        ),
      ],
    );
  }
}