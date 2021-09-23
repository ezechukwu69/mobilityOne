import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobility_one/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';
import 'package:mobility_one/ui/widgets/my_text_form_field.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_fields_validations.dart';
import 'package:mobility_one/util/my_images.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class SignUpScreen extends StatefulWidget {
  final Function onSignInClick;
  const SignUpScreen({required this.onSignInClick});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _companyNameController.dispose();
    _accountNameController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: MyColors.backgroundColor,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        MyImages.mobilityOneLogo,
                        width: 252,
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      _buildSignUpForm(state)
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  Widget _buildSignUpForm(AuthenticationState state) {
    return Form(
        key: _formKey,
        child: Container(
          width: 552,
          height: 1080,
          child: Card(
            color: MyColors.backgroundCardColor,
            elevation: 10,
            child: state is AuthenticationSigningUp ? MyCircularProgressIndicator() : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    MyLocalization.of(context)!.signup,
                    style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Averta', fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    MyLocalization.of(context)!.signupInstructionMessage,
                    style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12, fontFamily: 'Averta'),
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
                  MyTextFormField(
                    controller: _confirmPasswordController,
                    label: MyLocalization.of(context)!.confirmPassword,
                    isPasswordField: true,
                    fieldValidator: (BuildContext context, String? passwordConfirmation) {
                      if (_passwordController.value.text != passwordConfirmation) {
                        return MyLocalization.of(context)!.passwordConfirmationError;
                      }
                      return null;
                    },
                    expanded: true,
                  ),
                  MyTextFormField(
                    controller: _nameController,
                    label: MyLocalization.of(context)!.name,
                    expanded: true,
                  ),
                  MyTextFormField(
                    controller: _companyNameController,
                    label: MyLocalization.of(context)!.companyName,
                    expanded: true,
                  ),
                  MyTextFormField(
                    controller: _accountNameController,
                    label: MyLocalization.of(context)!.accountName,
                    expanded: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ConfirmButton(
                    onPressed: () {
                      var error = MyFieldValidations.validateEmail(context, _emailController.value.text);
                      _formKey.currentState!.validate();
                      if (error == null) {
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        final name = _nameController.text;
                        final companyName = _companyNameController.text;
                        final accountName = _accountNameController.text;
                        context.read<AuthenticationCubit>().signup(email: email, password: password, name: name, companyName: companyName, accountName: accountName);
                      }
                    },
                    title: MyLocalization.of(context)!.signup,
                    expanded: true,
                    height: 60,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildLoginButton(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildAzureRegistrationButton(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildLoginButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onSignInClick();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF585876),
            borderRadius: BorderRadius.all(Radius.circular(20),),
          ),
          child: Center(
            child: Text(
              MyLocalization.of(context)!.login.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAzureRegistrationButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AZURE AD REGISTRATION',
                style: MyTextStyles.dataTableViewAll.copyWith(fontSize: 14),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                height: 1,
                width: 170,
                color: MyColors.mobilityOneLightGreenColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}