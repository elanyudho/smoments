import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smoments/data/remote/response/login_response.dart';
import 'package:smoments/domain/provider/auth_provider.dart';
import 'package:smoments/domain/provider/preferences_provider.dart';
import 'package:smoments/routes/router.dart';

import '../res/assets.dart';
import '../res/colors.dart';
import '../widgets/button_outline.dart';
import '../widgets/button_submit_form.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Scaffold(
      backgroundColor: ThemeColors.secondaryColor1,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
              child: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 64),
              AspectRatio(
                  aspectRatio: 7 / 1,
                  child: SvgPicture.asset(assetLogoBlue)),
              const SizedBox(height: 16),
              const Text(
                "Log in to SMoments",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: ThemeColors.whiteColor),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                  textFormType: TextFormType.email,
                  controller: emailController,
                  hintText: 'Email'),
              const SizedBox(height: 16),
              CustomTextField(
                  textFormType: TextFormType.password,
                  controller: passwordController,
                  hintText: 'Password '),
              const SizedBox(height: 32),
              ButtonSubmitForm(
                isLoading: context.watch<AuthProvider>().isLoadingLogin,
                text: 'Login',
                formKey: _formKey,
                onAction: () async {
                  final authRead = context.read<AuthProvider>();

                  final result = await authRead.postLogin(
                    emailController.text,
                    passwordController.text,
                  );
                  if (!result.error) {
                    if (mounted) {
                      var loginResponse = result as LoginResponse;

                      Provider.of<PreferencesProvider>(context, listen: false).setLoginStatus(true);
                      Provider.of<PreferencesProvider>(context, listen: false).setUser(loginResponse.loginResult);
                      context.go(pathHome);
                    }
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
                "Don't have an account?",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                    color: ThemeColors.whiteColor),
              ),
              const SizedBox(height: 16),
              ButtonOutline(
                isLoading: false,
                text: 'Register',
                onClick: () {
                  context.push(pathRegister);
                },
                maxWidth: MediaQuery.of(context).size.width * 0.65,
              ),
            ]),
          )),
        ),
      ),
    );
  }
}
