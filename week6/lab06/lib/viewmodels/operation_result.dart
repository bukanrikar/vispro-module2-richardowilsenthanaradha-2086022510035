class OperationResult {
  final bool isSuccess;
  final String message;

  OperationResult.success([this.message = 'Success']) : isSuccess = true;
  OperationResult.failure(this.message) : isSuccess = false;
}