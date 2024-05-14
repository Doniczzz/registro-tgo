import 'error.dart';

class Result {
    final bool? isSuccess;
    final ErrorModel? error;

    Result.success() : isSuccess = true, error = null;
    Result.failure(this.error) : isSuccess = false;
}