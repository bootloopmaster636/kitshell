import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kitshell/etc/utitity/dart_extension.dart';
import 'package:kitshell/etc/utitity/gap.dart';
import 'package:kitshell/injectable.dart';
import 'package:kitshell/logic/panel_components/launchbar/workspaces_bloc.dart';
import 'package:kitshell/src/rust/api/wm_interface/base.dart';

class WorkspaceIndicator extends HookWidget {
  const WorkspaceIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      get<WorkspacesBloc>().add(const WorkspacesEventStarted());
      return () {};
    }, []);

    return Container(
      width: 120,
      padding: const EdgeInsets.all(4),
      child: BlocBuilder<WorkspacesBloc, WorkspacesState>(
        bloc: get<WorkspacesBloc>(),
        builder: (context, state) {
          switch (state) {
            case WorkspacesStateInitial():
              return const SizedBox.shrink();
            case WorkspacesStateLoaded():
              return WorkspaceDataProvider(
                data: state.workspace,
              );
          }
        },
      ),
    );
  }
}

class WorkspaceDataProvider extends HookWidget {
  const WorkspaceDataProvider({required this.data, super.key});
  final List<WorkspaceState> data;

  @override
  Widget build(BuildContext context) {
    final focusedOutputIdx = useMemoized(() {
      return data.indexWhere(
        (e) => e.hasWorkspaceFocused,
      );
    }, [data]);

    return Row(
      spacing: Gaps.xs.value,
      children: [
        SizedBox(
          width: 12,
          child: OutputIndicator(
            workspaceData: data,
            currentOutputIdx: focusedOutputIdx,
          ),
        ),
        Expanded(
          child: WorkspacesItemIndicator(
            workspaceItemsData: data[focusedOutputIdx].items,
          ),
        ),
      ],
    );
  }
}

class WorkspacesItemIndicator extends HookWidget {
  const WorkspacesItemIndicator({
    required this.workspaceItemsData,
    super.key,
  });

  final List<WorkspaceItemState> workspaceItemsData;

  @override
  Widget build(BuildContext context) {
    final carouselCtl = useState(CarouselController());
    final focusedWorkspaceIdx = useMemoized(() {
      // Get focused item index
      final result = workspaceItemsData.indexWhere(
        (e) => e.isFocused,
      );

      return result != -1 ? result : 0;
    }, [workspaceItemsData]);

    // Change view based on currently selected output index
    useEffect(() {
      final ctlVal = carouselCtl.value;

      // Animate pill
      if (ctlVal.hasClients && focusedWorkspaceIdx != -1) {
        ctlVal.animateToItem(
          focusedWorkspaceIdx,
          duration: Durations.medium3,
          curve: Easing.standard,
        );
      }

      return () {};
    }, [focusedWorkspaceIdx]);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Workspace name
        Text(
          workspaceItemsData[focusedWorkspaceIdx].name ??
              'Workspace ${workspaceItemsData[focusedWorkspaceIdx].idx}',
          style: context.textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        // Workspace pill
        SizedBox(
          height: 12,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: CarouselView.weighted(
              controller: carouselCtl.value,
              flexWeights: const [1, 2, 3, 2, 1],
              children: workspaceItemsData
                  .map(
                    (e) => ColoredBox(
                      color: e.id == workspaceItemsData[focusedWorkspaceIdx].id
                          ? context.colorScheme.primary
                          : context.colorScheme.secondary,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class OutputIndicator extends HookWidget {
  const OutputIndicator({
    required this.workspaceData,
    required this.currentOutputIdx,
    super.key,
  });

  final List<WorkspaceState> workspaceData;
  final int currentOutputIdx;

  @override
  Widget build(BuildContext context) {
    final carouselCtl = useState(CarouselController());
    useEffect(() {
      final ctlVal = carouselCtl.value;
      if (ctlVal.hasClients) {
        ctlVal.animateToItem(
          currentOutputIdx,
          duration: Durations.medium4,
          curve: Easing.standard,
        );
      }
      return () {};
    }, [currentOutputIdx]);

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: CarouselView.weighted(
        controller: carouselCtl.value,
        flexWeights: const [1, 2, 1],
        scrollDirection: Axis.vertical,
        children: workspaceData
            .map(
              (e) => ColoredBox(
                color: e.hasWorkspaceFocused
                    ? context.colorScheme.tertiary
                    : context.colorScheme.secondary,
              ),
            )
            .toList(),
      ),
    );
  }
}
