import 'admin_stats_entity.dart';
import 'admin_user_entity.dart';
import 'label_review_entity.dart';
import 'report_entity.dart';

class AdminDashboardEntity {
  const AdminDashboardEntity({
    required this.stats,
    required this.reports,
    required this.users,
    required this.labelReviews,
  });

  final AdminStatsEntity stats;
  final List<ReportEntity> reports;
  final List<AdminUserEntity> users;
  final List<LabelReviewEntity> labelReviews;
}
