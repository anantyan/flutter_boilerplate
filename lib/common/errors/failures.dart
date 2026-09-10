import 'package:equatable/equatable.dart';

/// Base class for all domain-level business and operational failures.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() =>
      '$runtimeType(message: $message, statusCode: $statusCode)';
}

/// Returned when a remote server / API returns an error response.
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Returned when there is no internet connection or socket error.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message =
        'Tidak ada koneksi internet. Silakan periksa jaringan Anda.',
  });
}

/// Returned when reading or writing to local/secure storage fails.
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Terjadi kesalahan saat mengakses penyimpanan lokal.',
  });
}

/// Returned when input validation fails in business logic.
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Fallback failure for unclassified exceptions.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message =
        'Terjadi kesalahan tak terduga. Silakan coba beberapa saat lagi.',
  });
}
