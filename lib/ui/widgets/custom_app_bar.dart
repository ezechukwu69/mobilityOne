import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobility_one/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:mobility_one/blocs/drawer_cubit/drawer_cubit.dart';
import 'package:mobility_one/util/mobility_one_app.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_images.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';
import 'search_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? pageName;

  CustomAppBar({this.scaffoldKey, this.pageName}) : super();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final isSmallScreen = maxWidth < 800;

      return FutureBuilder(
        future: MobilityOneApp.localStorage.getUserName(),
        builder: (context, state) {
          return AppBar(
            backgroundColor: MyColors.backgroundColor,
            toolbarHeight: 120,
            elevation: 0,
            title: maxWidth >= 700
                ? Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(color: MyColors.accentColor, shape: BoxShape.circle),
                ),
                SizedBox(
                  width: 12,
                ),
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${MyLocalization.of(context)!.welcomeMessageFirstPart} ${state.data}, ${MyLocalization.of(context)!.welcomeMessageSecondPart}',
                      style: MyTextStyles.appBarTitle,
                    ))
              ],
            )
                : Container(),
            leading: !BlocProvider.of<DrawerCubit>(context).isPinned
                ? IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () => scaffoldKey?.currentState!.openDrawer(),
            )
                : Container(),
            actions: [
              Row(
                children: [
                  SearchWidget(
                    showFixedTextField: maxWidth >= 1200,
                  ),
                  SizedBox(
                    width: isSmallScreen ? 20 : 120,
                  ),
                  !isSmallScreen ? SvgPicture.asset(MyImages.settingsButton) : Container(),
                  !isSmallScreen
                      ? SizedBox(
                    width: 24,
                  )
                      : Container(),
                  Stack(
                    children: [
                      SvgPicture.asset(MyImages.notificationButton),
                      Positioned(
                        top: 0,
                        right: 1,
                        child: Container(
                          width: 22,
                          height: 18,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                          child: Center(
                              child: Text(
                                '5',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('https://image.flaticon.com/icons/png/512/147/147144.png'),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  FittedBox(
                    child: Text(
                      '${state.data != null ? (state.data as String).split(' ')[0] : ' '}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  PopupMenuButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    itemBuilder: (context) {
                      return _populatePopUpMenuItems(isSmallScreen, context);
                    },
                    onSelected: (selection) => onOptionMenuSelected(selection, context),
                  ),
                ],
              )
            ],
          );
        }
        ,
      );
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(100);

  void onOptionMenuSelected(selection, BuildContext context) {
    switch (selection) {
      case 1:
        break;
      case 2:
        context.read<AuthenticationCubit>().logout();
        break;
      case 3:
        break;
      default:
        break;
    }
  }

  List<PopupMenuItem> _populatePopUpMenuItems(bool isSmallScreen, BuildContext context) {
    var menuItems = [
      PopupMenuItem(
        value: 1,
        child: Text(MyLocalization.of(context)!.changeUserText),
      ),
      PopupMenuItem(
        value: 2,
        child: Row(
          children: [
            Text(MyLocalization.of(context)!.logout),
            Spacer(),
            Icon(
              Icons.logout,
              color: Colors.green,
            ),
          ],
        ),
      ),
    ];

    if (isSmallScreen) {
      menuItems.insert(
        1,
        PopupMenuItem(
          value: 3,
          child: Text(MyLocalization.of(context)!.settingsText),
        ),
      );
    }

    return menuItems;
  }
}
