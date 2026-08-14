import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../cubit/admin_cubit.dart';
import '../cubit/admin_state.dart';
import '../widgets/admin_labels_tab.dart';
import '../widgets/admin_overview_tab.dart';
import '../widgets/admin_reports_tab.dart';
import '../widgets/admin_users_tab.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AdminCubit>().loadDashboard();
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppTopBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Admin Dashboard',
                style: AppTextStyles.headlineMd,
              ),
            ),
          ),
          TabBar(
            controller: _tabs,
            isScrollable: true,
            labelColor: AppColors.brandAccentPrimary,
            unselectedLabelColor: AppColors.onSurfaceVariant,
            indicatorColor: AppColors.brandAccentPrimary,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Reports'),
              Tab(text: 'Users'),
              Tab(text: 'Labels'),
            ],
          ),
          Expanded(
            child: BlocConsumer<AdminCubit, AdminState>(
              listenWhen: (previous, current) {
                return current is AdminLoaded &&
                    current.actionError != null &&
                    (previous is! AdminLoaded ||
                        previous.actionError != current.actionError);
              },
              listener: (context, state) {
                if (state is! AdminLoaded || state.actionError == null) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.actionError!)),
                );
              },
              builder: (context, state) {
                if (state is AdminLoading || state is AdminInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AdminFailure) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () =>
                        context.read<AdminCubit>().loadDashboard(),
                  );
                }
                if (state is! AdminLoaded) {
                  return const SizedBox.shrink();
                }

                final cubit = context.read<AdminCubit>();
                final dashboard = state.dashboard;
                final busy = state.actionInProgress;

                return TabBarView(
                  controller: _tabs,
                  children: [
                    AdminOverviewTab(stats: dashboard.stats),
                    AdminReportsTab(
                      reports: dashboard.reports,
                      busy: busy,
                      onResolve: cubit.resolveReport,
                      onDismiss: cubit.dismissReport,
                    ),
                    AdminUsersTab(
                      users: dashboard.users,
                      busy: busy,
                      onSetRole: cubit.setUserRole,
                    ),
                    AdminLabelsTab(
                      items: dashboard.labelReviews,
                      busy: busy,
                      onUpdateLabel: cubit.updateModelLabel,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
