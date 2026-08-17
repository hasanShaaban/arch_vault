import 'package:equatable/equatable.dart';

import 'report_entity.dart';

class GetReportsResponseEntity extends Equatable {
  const GetReportsResponseEntity({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<ReportEntity> results;

  @override
  List<Object?> get props => [count, next, previous, results];
}
