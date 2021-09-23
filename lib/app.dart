import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobility_one/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:mobility_one/blocs/drawer_cubit/drawer_cubit.dart';
import 'package:mobility_one/repositories/accounts_repository.dart';
import 'package:mobility_one/repositories/authentication_repository.dart';
import 'package:mobility_one/repositories/availabilities_repository.dart';
import 'package:mobility_one/repositories/cases_repository.dart';
import 'package:mobility_one/repositories/cases_type_repository.dart';
import 'package:mobility_one/repositories/general_statuses_repository.dart';
import 'package:mobility_one/repositories/mileage_reports_repository.dart';
import 'package:mobility_one/repositories/org_units_repository.dart';
import 'package:mobility_one/repositories/persons_repository.dart';
import 'package:mobility_one/repositories/pools_repository.dart';
import 'package:mobility_one/repositories/roles_repository.dart';
import 'package:mobility_one/repositories/teams_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'package:mobility_one/repositories/assignments_repository.dart';
import 'package:mobility_one/repositories/vehicle_stats_repository.dart';
import 'package:mobility_one/repositories/vehicle_types_repository.dart';
import 'package:mobility_one/repositories/vehicles_repository.dart';
import 'package:mobility_one/ui/screens/authentication_screen.dart';
import 'package:mobility_one/ui/screens/case_types/case_types_screen.dart';
import 'package:mobility_one/ui/screens/dashboard_screen.dart';
import 'package:mobility_one/repositories/tenants_user_repository.dart';
import 'package:mobility_one/ui/screens/hierarchy_screen.dart';
import 'package:mobility_one/ui/screens/pools_screen.dart';
import 'package:mobility_one/ui/screens/not_found_screen.dart';
import 'package:mobility_one/ui/screens/persons/persons_screen.dart';
import 'package:mobility_one/ui/screens/splash_screen.dart';
import 'package:mobility_one/ui/screens/vehicle_status_screen.dart';
import 'package:mobility_one/ui/screens/vehicle_types_screen.dart';
import 'package:mobility_one/ui/screens/vehicles_gantt_screen.dart';
import 'package:mobility_one/ui/screens/vehicles_list/vehicles_list_screen.dart';
import 'package:mobility_one/util/app_routes.dart';
import 'package:mobility_one/util/mobility_one_app.dart';
import 'package:mobility_one/util/my_beam_page.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_localization_delegate.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class MyApp extends StatefulWidget {
  final Uri currentUrl;

  const MyApp({required this.currentUrl});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BeamerDelegate routerDelegate;

  @override
  void initState() {
    super.initState();
    routerDelegate = BeamerDelegate(
      notFoundRedirectNamed: AppRoutes.notFound,
      locationBuilder: SimpleLocationBuilder(
        routes: {
          AppRoutes.root: (context, state) => MyBeamPage(title: MyLocalization.of(context)!.unauthenticated, child: const AuthenticationScreen(), showHeaderNavbarAndSidebar: false),
          AppRoutes.home: (context, state) => MyBeamPage(
                title: MyLocalization.of(context)!.home,
                child: DashboardScreen(),
              ),
          AppRoutes.vehicles: (context, state) => MyBeamPage(
                title: MyLocalization.of(context)!.vehiclesText,
                child: const VehiclesGanttScreen(),
              ),
          AppRoutes.vehicles_list: (context, state) => MyBeamPage(
                title: MyLocalization.of(context)!.vehiclesListText,
                child: const VehiclesListScreen(),
              ),
          AppRoutes.vehicle_types: (context, state) => MyBeamPage(
                title: MyLocalization.of(context)!.vehiclesTypesText,
                child: const VehicleTypesScreen(),
              ),
          AppRoutes.case_types: (context, state) => MyBeamPage(
            title: MyLocalization.of(context)!.caseTypesText,
            child: const CaseTypesScreen(),
          ),
          AppRoutes.notFound: (context, state) => MyBeamPage(
                title: MyLocalization.of(context)!.notFound,
                child: const NotFoundScreen(),
              ),
          AppRoutes.persons: (context, state) => MyBeamPage(
                title: MyLocalization.of(context)!.persons,
                child: const PersonsScreen(),
              ),
          AppRoutes.hierarchy: (context, state) => MyBeamPage(
                title: MyLocalization.of(context)!.myCompany,
                child: const HierarchyScreen(),
              ),
          AppRoutes.pools: (context, state) => MyBeamPage(
                title: 'Pools',
                child: const PoolsScreen(),
              ),
          AppRoutes.vehicle_status: (context, state) => MyBeamPage(
                title: 'Vehicle-Status',
                child: const VehicleStatusScreen(),
              ),
        },
      ),
      guards: [
        BeamGuard(
          pathBlueprints: [AppRoutes.root],
          check: (context, state) => context.select((AuthenticationCubit authenticationCubit) {
            return authenticationCubit.state is AuthenticationUnauthenticated || authenticationCubit.state is AuthenticationInitial || authenticationCubit.state is AuthenticationAuthenticating || authenticationCubit.state is AuthenticationSigningUp || authenticationCubit.state is AuthenticationFailed || authenticationCubit.state is AuthenticationSignUpFailed || authenticationCubit.state is AuthenticationSigningUpCompleted;
          }),
          beamToNamed: AppRoutes.home,
        ),
        BeamGuard(pathBlueprints: [AppRoutes.home, AppRoutes.persons], check: (context, state) => context.select((AuthenticationCubit authenticationCubit) => authenticationCubit.state is AuthenticationAuthenticated), beamToNamed: AppRoutes.root)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data as Widget;
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return SplashScreen();
      },
    );
  }

  Future<Widget> _initializeApp() async {
    // await Future.delayed(const Duration(seconds: 3), () {});
    await Future.delayed(const Duration(milliseconds: 1), () {});
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(localStorage: MobilityOneApp.localStorage, api: MobilityOneApp.api),
        ),
        RepositoryProvider<PersonsRepository>(
          create: (context) => PersonsRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<TenantsRepository>(
          create: (context) => TenantsRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<OrgUnitsRepository>(
          create: (context) => OrgUnitsRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<AccountsRepository>(
          create: (context) => AccountsRepository(api: MobilityOneApp.api, localStorage: MobilityOneApp.localStorage),
        ),
        RepositoryProvider<RolesRepository>(
          create: (context) => RolesRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<TenantsUserRepository>(
          create: (context) => TenantsUserRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<PoolsRepository>(
          create: (context) => PoolsRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<VehiclesRepository>(
          create: (context) => VehiclesRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<VehicleTypesRepository>(
          create: (context) => VehicleTypesRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<GeneralStatusesRepository>(
          create: (context) => GeneralStatusesRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<AvailabilitiesRepository>(
          create: (context) => AvailabilitiesRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<VehiclesCalendarRepository>(
          create: (context) => VehiclesCalendarRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<VehicleStatsRepository>(
          create: (context) => VehicleStatsRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<CasesTypeRepository>(
          create: (context) => CasesTypeRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<CasesRepository>(
          create: (context) => CasesRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<TeamsRepository>(
          create: (context) => TeamsRepository(api: MobilityOneApp.api),
        ),
        RepositoryProvider<MileageReportsRepository>(
          create: (context) => MileageReportsRepository(api: MobilityOneApp.api),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationCubit>(
            lazy: false,
            create: (context) => AuthenticationCubit(authenticationRepository: context.read<AuthenticationRepository>(), accountsRepository: context.read<AccountsRepository>())..onAppStart(currentUrl: widget.currentUrl),
          ),
          BlocProvider<DrawerCubit>(
            create: (context) => DrawerCubit(),
          ),
        ],
        child: BeamerProvider(
          routerDelegate: routerDelegate,
          child: MaterialApp.router(
            routeInformationParser: BeamerParser(),
            routerDelegate: routerDelegate,
            debugShowCheckedModeBanner: false,
            title: 'MobilityOne',
            locale: Locale('en', 'US'),
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              MyLocalizationDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              const FallbackCupertinoLocalisationsDelegate(),
            ],
            theme: ThemeData(
              dividerColor: MyColors.dataTableRowDividerColor,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              dataTableTheme: DataTableThemeData(
                // headingRowHeight: 100,
                decoration: BoxDecoration(
                  color: MyColors.dataTableBackgroundColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                headingTextStyle: MyTextStyles.dataTableHeading,
                dataTextStyle: MyTextStyles.dataTableText,
              ),
            ),
            supportedLocales: supportedLocales,
          ),
        ),
      ),
    );
  }
}

// added because of issue with textfields long click if this is missing
class FallbackCupertinoLocalisationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) => DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
