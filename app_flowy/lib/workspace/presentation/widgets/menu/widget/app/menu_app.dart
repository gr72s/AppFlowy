import 'package:app_flowy/workspace/presentation/widgets/menu/widget/app/header.dart';
import 'package:expandable/expandable.dart';
import 'package:flowy_infra_ui/widget/error_page.dart';
import 'package:flowy_sdk/protobuf/flowy-workspace/app_create.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_flowy/startup/startup.dart';
import 'package:app_flowy/workspace/application/app/app_bloc.dart';
import 'package:app_flowy/workspace/application/app/app_listen_bloc.dart';
import 'package:app_flowy/workspace/presentation/widgets/menu/menu.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'section/section.dart';

class MenuAppSizes {
  static double expandedIconSize = 16;
  static double expandedIconPadding = 6;
  static double scale = 1;
  static double get expandedPadding => expandedIconSize * scale + expandedIconPadding;
}

class MenuAppContext {
  final App app;
  final viewList = ViewListNotifier();

  MenuAppContext(this.app);

  Key valueKey() => ValueKey("${app.id}${app.version}");
}

// [[diagram: MenuApp]]
//                     ┌────────┐
//               ┌────▶│AppBloc │────────────────┐
//               │     └────────┘                │
//               │                               │
//               │ 1.1 fetch views               │
//               │ 1.2 update the MenuAppContext │
//               │ with the views                │
//               │                               ▼      3.render sections
// ┌────────┐    │                       ┌──────────────┐     ┌──────────────┐
// │MenuApp │────┤                       │MenuAppContext│─┬──▶│ ViewSection  │────────────────┐
// └────────┘    │                       └──────────────┘ │   └──────────────┘                │
//               │                               ▲        │                                   │
//               │                               │        │                                   │
//               │                               │   hold │                                   │
//               │                               │        │                     bind          ▼
//               │                               │        │  ┌─────────────────┐   ┌────────────────────┐
//               │    ┌──────────────┐           │        └─▶│ViewListNotifier │──▶│ViewSectionNotifier │
//               └───▶│AppListenBloc │───────────┘           └─────────────────┘   └────────────────────┘
//                    └──────────────┘
//                                                                    4.notifier binding. So The ViewSection
//                 2.1 listen on the app                              will be re rebuild if the the number of
//                 2.2 notify if the number of the app's view         the views in MenuAppContext was changed.
//                 was changed
//                 2.3 update MenuAppContext with the new
//                 views

class MenuApp extends MenuItem {
  final MenuAppContext appCtx;
  MenuApp(this.appCtx, {Key? key}) : super(key: appCtx.valueKey());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(create: (context) {
          final appBloc = getIt<AppBloc>(param1: appCtx.app.id);
          appBloc.add(const AppEvent.initial());
          return appBloc;
        }),
        BlocProvider<AppListenBloc>(create: (context) {
          final listener = getIt<AppListenBloc>(param1: appCtx.app.id);
          listener.add(const AppListenEvent.started());
          return listener;
        }),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppListenBloc, AppListenState>(
            listenWhen: (p, c) => p != c,
            listener: (context, state) => state.map(
              initial: (_) => {},
              didReceiveViews: (state) => appCtx.viewList.items = state.views,
              loadFail: (s) => appCtx.viewList.items = [],
            ),
          ),
        ],
        child: BlocBuilder<AppListenBloc, AppListenState>(
          builder: (context, state) {
            final child = state.map(
              initial: (_) => BlocBuilder<AppBloc, AppState>(builder: (context, state) {
                appCtx.viewList.items = state.views ?? List.empty(growable: false);
                return _renderViewSection(appCtx.viewList);
              }),
              didReceiveViews: (state) => _renderViewSection(appCtx.viewList),
              loadFail: (s) => FlowyErrorPage(s.error.toString()),
            );
            return expandableWrapper(context, child);
          },
        ),
      ),
    );
  }

  ExpandableNotifier expandableWrapper(BuildContext context, Widget child) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnExpand: true,
        scrollOnCollapse: false,
        child: Column(
          children: <Widget>[
            ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToExpand: false,
                tapBodyToCollapse: false,
                tapHeaderToExpand: false,
                iconPadding: EdgeInsets.zero,
                hasIcon: false,
              ),
              header: MenuAppHeader(appCtx.app),
              expanded: child,
              collapsed: const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderViewSection(ViewListNotifier viewListNotifier) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: viewListNotifier),
      ],
      child: Consumer(builder: (context, ViewListNotifier notifier, child) {
        return ViewSection(notifier.items).padding(vertical: 8);
      }),
    );
  }

  @override
  MenuItemType get type => MenuItemType.app;
}