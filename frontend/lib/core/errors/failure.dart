import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NoDataFailure extends Failure {
  const NoDataFailure(super.message);
}

class MessageFailure extends Failure {
  const MessageFailure(super.message);
}
