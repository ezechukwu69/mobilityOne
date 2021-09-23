import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobility_one/blocs/drawer_cubit/drawer_cubit.dart';
import 'package:mobility_one/util/app_routes.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_images.dart';
import 'package:mobility_one/util/util.dart';

class DrawerMenuOption {
  String title;
  String route;
  DrawerMenuOption({required this.title, required this.route});
}

typedef DrawerCallback = Function(DrawerMenuOption option);

class AppDrawer extends StatefulWidget {
  final DrawerCallback onDrawerOptionSelected;

  const AppDrawer({Key? key, required this.onDrawerOptionSelected}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  List<DrawerMenuOption> items = [
    DrawerMenuOption(title: 'Dashboard', route: AppRoutes.home),
     DrawerMenuOption(title: 'My Company', route: '/hierarchy'),
     DrawerMenuOption(title: 'Persons', route: AppRoutes.persons),
    //DrawerMenuOption(title: 'Calendar', route: '/calendar'),
    DrawerMenuOption(title: 'Pools', route: '/pools'),
    DrawerMenuOption(title: 'Vehicles', route: '/vehicles'),
    DrawerMenuOption(title: 'Vehicle types', route: '/vehicletypes'),
    DrawerMenuOption(title: 'Case Types', route: '/casetypes'),
    DrawerMenuOption(title: 'Vehicle list', route: '/vehicleslist'),
    DrawerMenuOption(title: 'Vehicle Status', route: '/vehiclestatus'),
    //DrawerMenuOption(title: 'Notification', route: '/notification'),
    //DrawerMenuOption(title: 'Profile', route: '/profile'),
    //DrawerMenuOption(title: 'Settings', route: '/settings')
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double menuWidth;
      bool showPinButton;
      if (constraints.maxWidth > Util.smallScreenWidth) {
        menuWidth = MediaQuery.of(context).size.width * 0.14;
        showPinButton = true;
      } else {
        menuWidth = MediaQuery.of(context).size.width * 0.5;
        showPinButton = false;
      }
      return Container(
        width: menuWidth,
        child: Stack(
          children: [
            Container(
              color: MyColors.backgroundColor,
            ),
            MobilityOneDrawerWaterMark(
              width: menuWidth,
            ),
            Column(
              children: [
                showPinButton
                    ? Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            final drawerCubit = BlocProvider.of<DrawerCubit>(context);
                            if (drawerCubit.isPinned) {
                              drawerCubit.unPinDrawer();
                            } else {
                              Navigator.of(context).pop();
                              drawerCubit.pinDrawer();
                            }
                          },
                          icon: Icon(
                            BlocProvider.of<DrawerCubit>(context).isPinned
                                ? Icons.close
                                : Icons.push_pin_outlined,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onDrawerOptionSelected(items[index]);
                        },
                        title: Text(
                          items[index].title,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      );
                    },
                    itemCount: items.length,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class MobilityOneDrawerWaterMark extends StatelessWidget {
  final width;
  MobilityOneDrawerWaterMark({this.width});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: -60,
      width: width,
      child: Opacity(
        opacity: 0.14,
        child: RotatedBox(
          quarterTurns: 3,
          child: Container(
            child: SvgPicture.asset(
              MyImages.mobilityOneLogo,
              width: 400,
            ),
          ),
        ),
      ),
    );
  }
}
