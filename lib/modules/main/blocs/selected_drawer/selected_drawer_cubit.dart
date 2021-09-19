import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'selected_drawer_state.dart';

class SelectedDrawerCubit extends Cubit<int> {
  SelectedDrawerCubit() : super(0);

  selectDrawer(int index) => emit(index);
}
