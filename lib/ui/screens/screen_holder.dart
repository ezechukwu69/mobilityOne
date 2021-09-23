import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/drawer_cubit/drawer_cubit.dart';
import 'package:mobility_one/blocs/drawer_cubit/drawer_state.dart';
import 'package:mobility_one/blocs/general_search_cubit/general_search_cubit.dart';
import 'package:mobility_one/ui/widgets/app_drawer.dart';
import 'package:mobility_one/ui/widgets/custom_app_bar.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_localization.dart';

class ScreenHolder extends StatelessWidget {
  final Widget child;
  ScreenHolder({required this.child});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GeneralSearchCubit(context: context),
      child: BlocBuilder<DrawerCubit, DrawerState>(
        builder: (context, drawerState) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: MyColors.backgroundColor,
              drawer: drawerState is NotPinnedDrawer
                  ? AppDrawer(
                      onDrawerOptionSelected: (option) {
                        Beamer.of(context).beamToNamed(option.route);
                      },
                    )
                  : null,
              appBar: CustomAppBar(
                scaffoldKey: _scaffoldKey,
                pageName: MyLocalization.of(context)!.dashboard,
              ),
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  drawerState is PinnedDrawer
                      ? AppDrawer(
                          onDrawerOptionSelected: (option) {
                            Beamer.of(context).beamToNamed(option.route);
                          },
                        )
                      : Container(),
                  Expanded(
                    child: child,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
