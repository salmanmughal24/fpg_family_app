part of 'listen_bloc.dart';

enum ListenStatus{
  playing, paused, stopped, hidden
}

class ListenState extends Equatable {

  @override
  List<Object?> get props => [status];

  final ListenStatus status;

  const ListenState._({this.status = ListenStatus.hidden});

  const ListenState.hidden() : this._(status: ListenStatus.hidden);
}