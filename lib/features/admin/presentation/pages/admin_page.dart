import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../cubit/admin_cubit.dart';
import '../cubit/admin_state.dart';
import '../widgets/admin_reports_tab.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AdminCubit>().getReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppTopBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Admin Dashboard - Reports',
                style: AppTextStyles.headlineMd,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<AdminCubit, AdminState>(
              builder: (context, state) {
                if (state is AdminLoading || state is AdminInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AdminFailure) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () => context.read<AdminCubit>().getReports(),
                  );
                }
                if (state is! AdminLoaded) {
                  return const SizedBox.shrink();
                }

                final reports = state.reportsResponse.results;

                return AdminReportsTab(reports: reports);
              },
            ),
          ),
        ],
      ),
    );
  }
}
