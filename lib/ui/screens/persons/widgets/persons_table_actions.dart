import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/persons_cubit/persons_cubit.dart';
import 'package:mobility_one/services/excel_service.dart';
import 'package:mobility_one/ui/dialogs/person_dialog.dart';
import 'package:mobility_one/ui/screens/persons/widgets/show_side_sheet.dart';
import 'package:mobility_one/ui/widgets/bulk_import_dialog.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/util/filter_group.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_text_styles.dart';
import 'package:mobility_one/util/util.dart';

class PersonsTableActions extends StatelessWidget {
  PersonsTableActions({
    Key? key,
    required this.selectedFilters,
  }) : super(key: key);

  List<Filter> selectedFilters;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ConfirmButton(
        title: 'New person',
        //margin: const EdgeInsets.only(right: 16, bottom: 10),
        onPressed: () async {
          await Util.showMyDialog(
            barrierDismissible: false,
            barrierColorTransparent: false,
            context: context,
            child: BlocProvider.value(
              value: context.read<PersonsCubit>(),
              child: PersonDialog(
                personToBeUpdated: null,
                action: PersonAction.create,
              ),
            ),
          );
        },
        canClick: true,
      ),
      SizedBox(width: 10),
      TextButton(
        onPressed: () {
          Util.showMyDialog(
            context: context,
            child: BlocProvider.value(
              value: context.read<PersonsCubit>(),
              child: BlocBuilder<PersonsCubit, PersonsState>(
                builder: (context, state) {
                  return BulkImportDialog(
                    title: 'Import Persons',
                    importScreen: ImportScreen.Persons,
                    colHeadersList: personsHeaderFormat,
                    onUpload: (records) async {
                      await context.read<PersonsCubit>().importPersons(records);
                    },
                    isLoading: state is! PersonsLoaded,
                  );
                },
              ),
            ),
          );
        },
        child: Text(
          'Import persons',
          style: MyTextStyles.pStyle,
        ),
      ),
      Spacer(),
      IconButton(
        onPressed: () {
          showSideSheet(
            context,
            personsCubit: context.read<PersonsCubit>(),
            selectedFilters: selectedFilters,
          );
        },
        icon: Icon(
          Icons.filter_list,
          color: MyColors.cardTextColor,
        ),
      ),
    ]);
  }
}
