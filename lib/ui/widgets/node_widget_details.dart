import 'package:flutter/material.dart';
import 'package:mobility_one/blocs/hierarchy_cubit/hierarchy_cubit.dart';
import 'package:mobility_one/models/node_item.dart';
import 'package:mobility_one/models/org_unit.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:provider/provider.dart';

class NodeItemDetails extends StatefulWidget {
  const NodeItemDetails({Key? key, required this.nodeItem, this.orgUnits, required this.tenant}) : super(key: key);

  final NodeItem nodeItem;
  final List<OrgUnit>? orgUnits;
  final Tenant tenant;

  @override
  _NodeItemDetailsState createState() => _NodeItemDetailsState();
}

class _NodeItemDetailsState extends State<NodeItemDetails> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController(text: widget.nodeItem.value.name ?? '');
    _focusNode = FocusNode();
    var canDelete = widget.orgUnits?.isEmpty == true;

    return Container(
      constraints: BoxConstraints(maxWidth: 600),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                color: MyColors.dataTableBackgroundColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nodeItem.value is Tenant ? 'Tenant' : 'Organization',
                    style: TextStyle(fontSize: 22, color: MyColors.textTitleColor),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 14, color: MyColors.textTitleColor),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      _focusNode.requestFocus();
                    },
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _controller,
                          textAlign: TextAlign.start,
                          //onChanged: (input) => context.read<LoginCubit>().validateUsernameInput(input),
                          focusNode: _focusNode,
                          decoration: _getInputDecoration(hintText: ''),
                          style: TextStyle(fontSize: 16, color: MyColors.textTitleColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (widget.orgUnits?.isNotEmpty == true)
                    Text(
                      'Children',
                      style: TextStyle(fontSize: 14, color: MyColors.textTitleColor),
                    ),
                  const SizedBox(height: 16),
                  if (widget.orgUnits?.isNotEmpty == true)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(color: MyColors.backgroundColor, borderRadius: BorderRadius.circular(16.0)),
                        child: ListView.builder(
                            itemCount: widget.orgUnits!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(widget.orgUnits![index].name!, style: TextStyle(color: MyColors.dataTableHeadingTextColor)),
                              );
                            }),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      context.read<HierarchyCubit>().updateNodeItemName(nodeItem: widget.nodeItem, name: _controller.text, tenantId: widget.tenant.id);
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: MyColors.mobilityOneLightGreenColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Center(
                          child: Text(
                            'Update'.toUpperCase(),
                            style: TextStyle(color: MyColors.backgroundColor, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: MouseRegion(
                  cursor: canDelete ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.nodeItem.value is OrgUnit) {
                        context.read<HierarchyCubit>().deleteOrgUnit(orgUnitId: widget.nodeItem.id, tenantId: widget.tenant.id);
                      }
                    },
                    child: Container(
                      height: 40,
                      foregroundDecoration: canDelete
                          ? null
                          : BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.dataTableRowDividerColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Center(
                          child: Text(
                            'DELETE'.toUpperCase(),
                            style: TextStyle(color: MyColors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _getInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 16, color: MyColors.textTitleColor),
      filled: true,
      fillColor: MyColors.backgroundColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: MyColors.backgroundColor.withOpacity(0.5), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: MyColors.dataTableHeadingTextColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: MyColors.dangerColor, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: MyColors.dangerColor, width: 1.5)),
    );
  }
}