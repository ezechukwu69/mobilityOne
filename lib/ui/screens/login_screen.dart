import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobility_one/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';
import 'package:mobility_one/ui/widgets/my_text_form_field.dart';
import 'package:mobility_one/util/app_routes.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_fields_validations.dart';
import 'package:mobility_one/util/my_images.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class LoginScreen extends StatefulWidget {
  final Function onSignUpClick;
  const LoginScreen({required this.onSignUpClick});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool rememberLogin = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationAuthenticated) {
          Beamer.of(context).beamToNamed(AppRoutes.home);
        } else {
          Beamer.of(context).beamToNamed(AppRoutes.root);
        }
        if (state is AuthenticationFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(MyLocalization.of(context)!.wrongCredentials)));
        }
      },
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: MyColors.backgroundColor,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [_buildLoginForm(state)],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(AuthenticationState state) {
    return Form(
      key: _formKey,
      child: Container(
        height: 810,
        width: 552,
        child: Card(
          color: MyColors.backgroundCardColor,
          elevation: 10,
          child: state is AuthenticationAuthenticating
              ? MyCircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        MyImages.mobilityOneLogo,
                        width: 252,
                      ),
                      Text(
                        MyLocalization.of(context)!.loginWelcomeMessage,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Averta',
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        MyLocalization.of(context)!.loginInstructionMessage,
                        style: TextStyle(
                            color: Colors.white.withOpacity(.6),
                            fontSize: 12,
                            fontFamily: 'Averta'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyTextFormField(
                        controller: _emailController,
                        label: MyLocalization.of(context)!.email,
                        fieldValidator: MyFieldValidations.validateEmail,
                        expanded: true,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      MyTextFormField(
                        controller: _passwordController,
                        label: MyLocalization.of(context)!.password,
                        isPasswordField: true,
                        fieldValidator: MyFieldValidations.validatePassword,
                        expanded: true,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ConfirmButton(
                        onPressed: () {
                          var error = MyFieldValidations.validateEmail(
                              context, _emailController.value.text);
                          _formKey.currentState!.validate();
                          if (error == null) {
                            // context.read<AuthenticationCubit>().redirectToLoginPage();
                            context.read<AuthenticationCubit>().makeLogin(
                                email: _emailController.value.text,
                                password: _passwordController.value.text);
                          }
                        },
                        title: MyLocalization.of(context)!.login,
                        expanded: true,
                        height: 60,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          ..._buildRememberLoginButton(),
                          Spacer(),
                          _buildResetHereButton()
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      _buildCreateAnAccountButton(),
                      SizedBox(
                        height: 40,
                      ),
                      _buildAzureAdLoginButton()
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  List<Widget> _buildRememberLoginButton() {
    return [
      Checkbox(
        value: rememberLogin,
        onChanged: (selected) {
          setState(
            () {
              rememberLogin = selected!;
            },
          );
        },
      ),
      TextButton(
        onPressed: () {
          setState(() {
            rememberLogin = !rememberLogin;
          });
        },
        child: Text(
          MyLocalization.of(context)!.rememberLoginText,
          style: MyTextStyles.dataTableText
              .copyWith(color: MyColors.cardTextColor),
        ),
      )
    ];
  }

  Widget _buildResetHereButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                MyLocalization.of(context)!.resetHereText.toUpperCase(),
                style: MyTextStyles.dataTableViewAll.copyWith(fontSize: 14),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                height: 1,
                width: 84,
                color: MyColors.mobilityOneLightGreenColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAnAccountButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onSignUpClick();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF585876),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              MyLocalization.of(context)!.createAnAccountText.toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAzureAdLoginButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AZURE AD LOGIN',
                style: MyTextStyles.dataTableViewAll.copyWith(fontSize: 14),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                height: 1,
                width: 110,
                color: MyColors.mobilityOneLightGreenColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
