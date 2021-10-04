import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'listen_event.dart';
part 'listern_state.dart';

class ListenBloc extends Bloc<ListenEvent, ListenState>{

  ListenBloc() : super(ListenState.hidden());

  StreamController<bool> playingAudio = StreamController.broadcast();

}