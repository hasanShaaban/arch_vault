import 'package:arch_vault/core/errors/failure.dart';
import 'package:arch_vault/features/admin/domain/entities/get_reports_response_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AdminRepo {
  Future<Either<Failure, GetReportsResponseEntity>> getReports();
}
