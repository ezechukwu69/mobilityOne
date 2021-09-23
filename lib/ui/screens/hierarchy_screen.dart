import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:mobility_one/blocs/general_search_cubit/general_search_cubit.dart';
import 'package:mobility_one/blocs/general_search_cubit/general_search_state.dart';
import 'package:mobility_one/blocs/hierarchy_cubit/hierarchy_cubit.dart';
import 'package:mobility_one/models/node_item.dart';
import 'package:mobility_one/models/org_unit.dart';
import 'package:mobility_one/models/tenant.dart';
import 'package:mobility_one/repositories/accounts_repository.dart';
import 'package:mobility_one/repositories/org_units_repository.dart';
import 'package:mobility_one/repositories/persons_repository.dart';
import 'package:mobility_one/repositories/tenants_repository.dart';
import 'package:mobility_one/ui/dialogs/org_unit_dialog.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';
import 'package:mobility_one/ui/widgets/node_widget.dart';
import 'package:mobility_one/ui/widgets/node_widget_details.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/util.dart';

class HierarchyScreen extends StatefulWidget {
  const HierarchyScreen({Key? key}) : super(key: key);

  @override
  _HierarchyScreenState createState() => _HierarchyScreenState();
}

class _HierarchyScreenState extends State<HierarchyScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HierarchyCubit>(
      create: (context) => HierarchyCubit(
        personsRepository: context.read<PersonsRepository>(),
        tenantsRepository: context.read<TenantsRepository>(),
        orgUnitsRepository: context.read<OrgUnitsRepository>(),
        accountsRepository: context.read<AccountsRepository>(),
      )..getDataFromApi(),
      child: SizedBox(
        width: 800,
        child: HierarchyTree(),
      ),
    );
  }
}

class HierarchyTree extends StatefulWidget {
  const HierarchyTree({Key? key}) : super(key: key);

  @override
  _HierarchyTreeState createState() => _HierarchyTreeState();
}

class _HierarchyTreeState extends State<HierarchyTree> {
  final treeController = TreeController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HierarchyCubit, HierarchyState>(
      builder: (context, state) {
        if (state is HierarchyLoaded) {
          return LayoutBuilder(
            builder: (context, constraints) {
              var isSmallScreen = constraints.maxWidth <= 600;
              return isSmallScreen
                  ? Column(
                      children: [
                        // _buildTreeComponent(state, isSmallScreen),
                        SizedBox(
                          height: 30,
                        ),
                        _showDetailsPage(state)
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTreeComponent(state, isSmallScreen),
                        const SizedBox(
                          width: 30,
                        ),
                        _showDetailsPage(state)
                      ],
                    );
            },
          );
        }

        if (state is HierarchyLoading) {
          return Center(
            child: MyCircularProgressIndicator(),
          );
        }

        return Container();
      },
    );
  }

  Widget _buildTreeComponent(HierarchyLoaded state, bool isSmallScreen) {
    var rootNodes = state.hierarchy!.keys.toList();
    var rootNode = NodeItem(value: null, name: 'root', id: 'root');
    return BlocBuilder<GeneralSearchCubit, GeneralSearchState>(
      builder: (context, generalSearchState) {
        if (generalSearchState is GeneralSearchMakeSearch) {
          var hierarchyCubit = context.read<HierarchyCubit>();
          if (generalSearchState.searchText.isEmpty) {
            hierarchyCubit.getDataFromApi();
          } else {
            hierarchyCubit.searchItems(generalSearchState.searchText);
          }
          context.read<GeneralSearchCubit>().searchExecuted();
        }

        return SingleChildScrollView(
          child: Container(
            width:
                MediaQuery.of(context).size.width * (isSmallScreen ? 1 : 0.2),
            height: state.numberOfNodes * 150,
            child: Column(
              children: [
                MouseRegion(
                  cursor: state.selectedTenant != null
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.forbidden,
                  child: GestureDetector(
                    onTap: () async {
                      if (state.selectedTenant != null) {
                        await Util.showMyDialog(
                          context: context,
                          child: BlocProvider.value(
                              value: context.read<HierarchyCubit>(),
                              child: OrgUnitDialog(
                                tenant: state.selectedTenant!.value,
                                parentOrgUnit: state.selectedNode?.value,
                              )),
                        );
                      }
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MyColors.mobilityOneLightGreenColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Center(
                          child: Text(
                            'Create'.toUpperCase(),
                            style: TextStyle(
                                color: MyColors.backgroundColor,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: MyColors.backgroundCardColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Theme(
                        data: ThemeData(
                            iconTheme:
                                IconThemeData(color: MyColors.textTitleColor)),
                        child: TreeView(
                            treeController: treeController,
                            indent: 16,
                            nodes: [
                              TreeNode(
                                content: InkWell(
                                  onTap: () =>
                                      context.read<HierarchyCubit>().goToRoot(),
                                  child: NodeWidget(
                                    nodeItem: NodeItem(
                                        value: rootNode,
                                        name: rootNode.name,
                                        id: rootNode.id),
                                    textColor: state.selectedNode == null
                                        ? MyColors.textTitleColor
                                        : MyColors.dataTableHeadingTextColor,
                                  ),
                                ),
                                children: rootNodes.map((tenant) {
                                  var childNodes = state.hierarchy![tenant];
                                  return TreeNode(
                                    content: DragTarget<NodeItem>(
                                      onAccept: (childNode) {
                                        print('.....inserting 1st level......');
                                        // todo: context.read<HierarchyCubit>().updateChildNode(parentOrgUnit: state.hierarchy![tenant.id]!.first, childOrgUnit: childOrgUnit, tenantId: tenant.id);
                                      },
                                      builder: (_, __, ___) {
                                        return InkWell(
                                          onTap: () => context
                                              .read<HierarchyCubit>()
                                              .selectTenantItem(tenant),
                                          child: LongPressDraggable<NodeItem>(
                                            data:
                                                state.hierarchy?[tenant]?.first,
                                            feedback: NodeWidget(
                                                nodeItem: NodeItem(
                                                    value: tenant,
                                                    name: tenant.name,
                                                    id: tenant.id),
                                                textColor: MyColors
                                                    .dataTableHeadingTextColor
                                                    .withOpacity(0.7),
                                                fontSize: 18),
                                            child: NodeWidget(
                                              nodeItem: NodeItem(
                                                  value: tenant,
                                                  name: tenant.name,
                                                  id: tenant.id),
                                              textColor: state
                                                          .hierarchy![tenant]!
                                                          .first
                                                          .id ==
                                                      state.selectedNode?.id
                                                  ? MyColors.textTitleColor
                                                  : MyColors
                                                      .dataTableHeadingTextColor,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    children: childNodes!.isEmpty
                                        ? null
                                        : generateSubNodes(childNodes, state,
                                            context.read<HierarchyCubit>()),
                                  );
                                }).toList(),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _showDetailsPage(HierarchyLoaded state) {
    if (state.selectedNode != null || state.selectedTenant != null)
      return showNodeDetails(
          state: state,
          selectedTenant: state.selectedTenant,
          selectedNode: state.selectedNode);
    return Container();
  }

  Widget showNodeDetails(
      {NodeItem? selectedNode,
      NodeItem? selectedTenant,
      required HierarchyLoaded state}) {
    var nodeItem = selectedNode ?? selectedTenant;
    var isTenant = nodeItem!.value is Tenant;
    var tenant = isTenant
        ? nodeItem.value
        : state.hierarchy!.keys
            .firstWhere((element) => element.id == nodeItem.value.tenantId)
            .value;
    return NodeItemDetails(
      nodeItem: nodeItem,
      orgUnits: isTenant
          ? state.hierarchy![selectedTenant]!
              .map((e) => e.value as OrgUnit)
              .toList()
          : nodeItem.value.children,
      tenant: tenant,
    );
  }

  List<TreeNode>? generateSubNodes(
      List<NodeItem>? nodeItems, HierarchyLoaded state, HierarchyCubit cubit) {
    if (nodeItems == null) {
      return null;
    }
    return nodeItems.map((e) {
      var nodeKey = ValueKey(e);
      return TreeNode(
        key: nodeKey,
        content: DragTarget<NodeItem>(
          onAccept: (nodeItem) {
            if (nodeItem.id != e.id) {
              context.read<HierarchyCubit>().updateChildNode(
                  parentNodeItem: e,
                  childNodeItem: nodeItem,
                  tenantId: e.value.tenantId);
            }
          },
          builder: (_, __, ___) {
            return InkWell(
              onTap: () => cubit.selectNodeItem(e),
              child: LongPressDraggable<NodeItem>(
                data: e,
                feedback: NodeWidget(
                    nodeItem: NodeItem(value: e, name: e.name, id: e.id),
                    textColor:
                        MyColors.dataTableHeadingTextColor.withOpacity(0.7),
                    fontSize: 18),
                child: NodeWidget(
                  nodeItem: NodeItem(value: e, name: e.name, id: e.id),
                  textColor: e.id == state.selectedNode?.id
                      ? MyColors.textTitleColor
                      : MyColors.dataTableHeadingTextColor,
                ),
              ),
            );
          },
        ),
        children: generateSubNodes(e.children, state, cubit),
      );
    }).toList();
  }
}
