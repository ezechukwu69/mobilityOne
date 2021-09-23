import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobility_one/util/i18n/strings_messages_all.dart';

const List<Locale> supportedLocales = <Locale>[Locale('en', 'US')];

class MyLocalization extends DefaultMaterialLocalizations {
  MyLocalization();

  

  

  static Future<MaterialLocalizations> load(Locale locale) async {
    final name = locale.countryCode!.isEmpty ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);

    // await initializeDateFormatting('hr_HR', null);
    return initializeMessages(localeName).then((bool value) {
      Intl.defaultLocale = localeName;
      return MyLocalization();
    });
  }

  static MyLocalization? of(BuildContext context) {
    return Localizations.of<MaterialLocalizations>(context, MaterialLocalizations)
        as MyLocalization?;
  }

  //because of intl generator package, make sure that the getter name is the same as name parameter of Intl.message

  String get noConnection => Intl.message('No Internet connection', name: 'noConnection');
  String get serverError => Intl.message('Server error, please try again', name: 'serverError');
  String get genericErrorMessage => Intl.message('Error', name: 'genericErrorMessage');
  String get genericSuccessMessage => Intl.message('Success', name: 'genericSuccessMessage');
  String get login => Intl.message('Login', name: 'login');
  String get createAnAccountText => Intl.message('Create an Account', name: 'createAnAccountText');
  String get loginWelcomeMessage => Intl.message('Welcomes back!', name: 'loginWelcomeMessage');
  String get rememberLoginText => Intl.message('Remember My Login', name: 'rememberLoginText');
  String get loginInstructionMessage => Intl.message('Please login using your account', name: 'loginInstructionMessage');
  String get signup => Intl.message('Sign Up', name: 'signup');
  String get signupInstructionMessage => Intl.message('Create New Account', name: 'signupInstructionMessage');
  String get logout => Intl.message('Logout', name: 'logout');
  String get tokenExpiredError =>
      Intl.message('Token expired, please login', name: 'tokenExpiredError');
  String get projectName => Intl.message('MobilityOne', name: 'projectName');
  String get unauthenticated => Intl.message('Unauthenticated', name: 'unauthenticated');
  String get home => Intl.message('Home', name: 'home');
  String get dashboard => Intl.message('Dashboard', name: 'dashboard');
  String get notFound => Intl.message('Not found', name: 'notFound');
  String get persons => Intl.message('Persons', name: 'persons');
  String get myCompany => Intl.message('My Company', name: 'myCompany');
  String get viewAll => Intl.message('view all', name: 'viewAll');
  String get resetHereText => Intl.message('Reset Here', name: 'resetHereText');
  String get updatePerson => Intl.message('Update Person', name: 'updatePerson');
  String get deletePerson => Intl.message('Delete Person', name: 'deletePerson');
  String get createPerson => Intl.message('Create Person', name: 'createPerson');
  String get create => Intl.message('Create', name: 'create');
  String get update => Intl.message('Update', name: 'update');
  String get cancel => Intl.message('Cancel', name: 'cancel');
  String get confirm => Intl.message('Confirm', name: 'confirm');
  String get firstName => Intl.message('First Name', name: 'firstName');
  String get name => Intl.message('Name', name: 'name');
  String get companyName => Intl.message('Company Name', name: 'companyName');
  String get accountName => Intl.message('Account Name', name: 'accountName');
  String get lastName => Intl.message('Last Name', name: 'lastName');
  String get email => Intl.message('Email', name: 'email');
  String get comment => Intl.message('Comment', name: 'comment');
  String get description => Intl.message('Description', name: 'description');
  String get mileage => Intl.message('Mileage', name: 'mileage');
  String get mileageUnit => Intl.message('Mileage Unit', name: 'mileageUnit');
  String get measuringUnit => Intl.message('Measuring Unit', name: 'measuringUnit');
  String get teamText => Intl.message('Team', name: 'teamText');
  String get emailEmptyError => Intl.message('E-mail can not be empty', name: 'emailEmptyError');
  String get emailNotValidFormat => Intl.message('This is not a valid e-mail', name: 'emailNotValidFormat');
  String get password => Intl.message('Password', name: 'password');
  String get confirmPassword => Intl.message('Confirm Password', name: 'confirmPassword');
  String get passwordEmptyError => Intl.message('Password can not be empty', name: 'passwordEmptyError');
  String get shouldBeNumberError => Intl.message('This value should be a number', name: 'shouldBeNumberError');
  String get requiredFieldError => Intl.message('This field can not be empty', name: 'requiredFieldError');
  String get wrongCredentials => Intl.message('E-mail or password is incorrect', name: 'wrongCredentials');
  String get passwordConfirmationError => Intl.message('Password and Confirmation Password are not equal', name: 'passwordConfirmationError');
  String get pleaseSelect => Intl.message('Please Select', name: 'pleaseSelect');
  String get orgUnit => Intl.message('Org. Unit', name: 'orgUnit');
  String get roles => Intl.message('Roles', name: 'roles');

  String get expand => Intl.message('Expand', name: 'expand');
  String get noAvailableOrgUnits =>
      Intl.message('No available org units!', name: 'noAvailableOrgUnits');
  String get personTenant => Intl.message('Person Tenant', name: 'personTenant');
  String get tenant => Intl.message('Tenant', name: 'tenant');
  String get searchFieldLabelText =>
      Intl.message('Search people, vehicles, more...', name: 'searchDialogLabelText');
  String get changeUserText => Intl.message('Change user', name: 'changeUserText');
  String get settingsText => Intl.message('Settings', name: 'settings');
  String get welcomeMessageFirstPart => Intl.message('Hi', name: 'welcomeMessageFirstPart');
  String get welcomeMessageSecondPart => Intl.message('Welcome to the MobilityONE');
  String get deletePersonConfirm =>
      Intl.message('Are you sure you want to delete this person?', name: 'deletePersonConfirm');
  String get createOrgUnit => Intl.message('Create Organization Unit', name: 'createOrgUnit');
  String get orgName => Intl.message('Organization name', name: 'orgName');
  String get parentOrgUnit => Intl.message('Parent Organization', name: 'parentOrgUnit');
  String get emptyOrganizationNameError => Intl.message('Organization name can not be empty', name: 'emptyOrganizationNameError');
  String get emptyOrganizationNameErrorDescription => Intl.message('Provide a name for the organization', name: 'emptyOrganizationNameErrorDescription');
  String get vehiclesText => Intl.message('Vehicles', name: 'vehiclesText');
  String get vehiclesListText => Intl.message('Vehicles List', name: 'vehiclesListText');
  String get vehiclesTypesText => Intl.message('Vehicles Types', name: 'vehiclesTypesText');
  String get caseTypesText => Intl.message('Case Types', name: 'caseTypesText');
  String get createCaseType => Intl.message('Create Case Type', name: 'createCaseType');
  String get updateCaseType => Intl.message('Update Case Type', name: 'updateCaseType');
  String get deleteCaseType => Intl.message('Delete Case Type', name: 'deleteCaseType');
  String get deleteCaseTypeConfirmation => Intl.message('If you click on confirm the Case TYpe will be deleted from the system.', name: 'deleteCaseTypeConfirmation');
  String get newAssignment => Intl.message('New Assignment', name: 'newAssignment');
  String get editAssignment => Intl.message('Edit Assignment', name: 'editAssignment');
  String get deleteVehicle => Intl.message('Delete vehicle', name: 'vehicleDelete');
  String get createVehicle => Intl.message('Create vehicle', name: 'vehicleCreate');
  String get updateVehicle => Intl.message('Update vehicle', name: 'vehicleUpdate');
  String get availability => Intl.message('Availability', name: 'availability');
  String get noAvailableAvailabilities => Intl.message('No Available Availabilities', name: 'noAvailableAvailabilities');
  String get noAvailableGeneralStatuses => Intl.message('Available General Statuses', name: 'availableGeneralStatuses');
  String get generalStatus => Intl.message('General Status', name: 'generalStatus');
  String get noAvailablePools => Intl.message('Update vehicle', name: 'vehicleUpdate');
  String get pool => Intl.message('Pool', name: 'pool');
  String get vehicleType => Intl.message('Vehicle Type', name: 'vehicleType');
  String get noAvailableVehicleTypes => Intl.message('Available Vehicle Types', name: 'availableVehicleTypes');
  // Labels for search field
  String get searchFieldDashboardLabel => Intl.message('card, analytics, calendar event...', name: 'searchFieldDashboardLabel');
  String get searchFieldHierarchyLabel => Intl.message('organization, person...', name: 'searchFieldHierarchyLabel');
  String get searchFieldPersonsLabel => Intl.message('name, email, organization...', name: 'searchFieldPersonsLabel');
  String get searchFieldPoolsLabel => Intl.message('pool name', name: 'searchFieldPoolsLabel');
  String get searchFieldVehiclesLabel => Intl.message('person, vehicle, organization...', name: 'searchFieldVehiclesLabel');
  String get searchFieldVehicleTypesLabel => Intl.message('vehicle type...', name: 'searchFieldVehicleTypesLabel');
  String get searchFieldVehicleListLabel => Intl.message('name, vehicle type...', name: 'searchFieldVehicleListLabel');
  String get filterLabel => Intl.message('Filter', name: 'filterLabel');
  String get createNewAssignmentText => Intl.message('Create new Assignment', name: 'createNewAssignmentText');
  String get createCaseText => Intl.message('Create new Case', name: 'createCaseText');
  String get createMileageReportText => Intl.message('Insert Mileage Report', name: 'createMileageReportText');
  String get editCase => Intl.message('Edit Case', name: 'editCase');
  String get editMileageReport => Intl.message('Edit Mileage Report', name: 'editMileageReport');
  String get deleteCase => Intl.message('Delete Case', name: 'deleteCase');
  String get deleteMileageReport => Intl.message('Delete Mileage Report', name: 'deleteMileageReport');
  String get newCase => Intl.message('New Case', name: 'newCase');
  String get newCaseType => Intl.message('New Case Type', name: 'newCaseType');
  String get newMileageReport => Intl.message('New Mileage Report', name: 'newMileageReport');
  String get caseType => Intl.message('Case Type', name: 'caseType');
  String get assigneeTo => Intl.message('Assignee To', name: 'assigneeTo');
  String get deleteCaseConfirmation => Intl.message('If you click on confirm the Case will be deleted from the system.', name: 'deleteCaseConfirmation');
  String get deleteMileageReportConfirmation => Intl.message('If you click on confirm the Mileage Report will be deleted from the system.', name: 'deleteMileageReportConfirmation');
}
