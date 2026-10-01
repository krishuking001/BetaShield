/// Failure categories the UI knows how to explain. Repositories throw
/// [AppException]; controllers surface it through `AsyncValue.error`.
enum FailureKind {
  offline,
  unauthorized,
  notFound,
  invalidCode,
  locked,
  rateLimited,
  notPaired,
  server,
  unknown,
}

class AppException implements Exception {
  const AppException(this.kind, [this.debugMessage]);

  final FailureKind kind;

  /// Never contains user content — only technical hints safe for logs.
  final String? debugMessage;

  bool get isRetryable =>
      kind == FailureKind.offline || kind == FailureKind.server;

  @override
  String toString() =>
      'AppException($kind${debugMessage == null ? '' : ': $debugMessage'})';
}
