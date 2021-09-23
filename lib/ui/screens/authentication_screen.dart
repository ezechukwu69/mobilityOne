import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:mobility_one/ui/screens/login_screen.dart';
import 'package:mobility_one/ui/screens/signup_screen.dart';
import 'package:mobility_one/util/my_colors.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: FlipCard(
        key: cardKey,
        flipOnTouch: false,
        front: LoginScreen(onSignUpClick: _toggleCardFlip,),
        back: SignUpScreen(onSignInClick: _toggleCardFlip,),
      ),
    );
  }

  void _toggleCardFlip() {
    cardKey.currentState!.toggleCard();
  }
}
