import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobility_one/blocs/cases_type_cubit/cases_type_cubit.dart';
import 'package:mobility_one/ui/dialogs/case_type_dialog.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/util/filter_group.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/util.dart';

class CaseTypesTableActions extends StatelessWidget {
  CaseTypesTableActions({
    Key? key,
    required this.selectedFilters,
  }) : super(key: key);

  final List<Filter> selectedFilters;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ConfirmButton(
          title: MyLocalization.of(context)!.newCaseType,
          onPressed: () async {
            await Util.showMyDialog(
              barrierDismissible: false,
              barrierColorTransparent: false,
              context: context,
              child: BlocProvider.value(
                value: context.read<CasesTypeCubit>(),
                child: CaseTypeDialog(action: CaseTypeDialogAction.create,),
              ),
            );
          },
          canClick: true,
        ),
      ],
    );
  }
}
