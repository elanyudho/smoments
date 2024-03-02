import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smoments/res/assets.dart';
import 'package:smoments/res/colors.dart';
import 'package:smoments/routes/router.dart';
import 'package:smoments/widgets/button_outline.dart';
import 'package:smoments/widgets/button_submit_form.dart';
import 'package:smoments/widgets/custom_text_field.dart';

import '../domain/provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeColors.secondaryColor1,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      const SizedBox(
                        height: 24,
                      ),
                      // Logo
                      Align(
                          alignment: Alignment.centerLeft,
                          child: BackButton(
                              color: ThemeColors.whiteColor,
                              onPressed: () {
                                context.pop();
                              })),
                      // Logo
                      AspectRatio(
                          aspectRatio: 7 / 1,
                          child: SvgPicture.asset(assetLogoBlue)),
                      const SizedBox(height: 16),
                      const Text(
                        "Join SMoments Today",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: ThemeColors.whiteColor),
                      ),
                      const SizedBox(height: 32),
                      CustomTextField(
                          textFormType: TextFormType.name,
                          controller: nameController,
                          hintText: 'Name'),
                      const SizedBox(height: 16),
                      CustomTextField(
                          textFormType: TextFormType.email,
                          controller: emailController,
                          hintText: 'Email'),
                      const SizedBox(height: 16),
                      CustomTextField(
                          textFormType: TextFormType.password,
                          controller: passwordController,
                          hintText: 'Password '),
                      const SizedBox(height: 16),
                      CustomTextField(
                          textFormType: TextFormType.confirmPassword,
                          controller: confirmPasswordController,
                          hintText: 'Confirm Password',
                          password: passwordController.text),
                      const SizedBox(height: 32),
      
                      ButtonSubmitForm(
                        isLoading: context.watch<AuthProvider>().isLoadingRegister,
                        text: 'Register',
                        formKey: _formKey,
                        onAction: () async {
                          final authRead = context.read<AuthProvider>();
                          final result = await authRead.postRegister(
                            nameController.text,
                            emailController.text,
                            passwordController.text,
                          );
                          if (!result.error) {
                            if (mounted) context.go(pathLogin);
                          }
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text(result.message),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 64),
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                            color: ThemeColors.whiteColor),
                      ),
                      const SizedBox(height: 16),
                      ButtonOutline(
                        isLoading: false,
                        text: 'Log in',
                        onClick: () {
                          context.pop();
                        },
                        maxWidth: MediaQuery.of(context).size.width * 0.65,
                      ),
                    ]))),
          ),
        ),
      ),
    );
  }
}
