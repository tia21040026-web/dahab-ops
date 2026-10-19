import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/api/api_error.dart';
import '../data/booking_repository.dart';

enum BookingDetailStatus { initial, loading, ready, failure }

class BookingDetailState extends Equatable {
  const BookingDetailState({this.status = BookingDetailStatus.initial, this.detail, this.error});

  final BookingDetailStatus status;
  final BookingDetail? detail;
  final Object? error;

  BookingDetailState copyWith({BookingDetailStatus? status, BookingDetail? detail, Object? error}) =>
      BookingDetailState(status: status ?? this.status, detail: detail ?? this.detail, error: error);

  @override
  List<Object?> get props => [status, detail, error?.toString()];
}

@injectable
class BookingDetailCubit extends Cubit<BookingDetailState> {
  BookingDetailCubit(this._repo) : super(const BookingDetailState());

  final BookingRepository _repo;

  Future<void> load(String ref) async {
    emit(state.copyWith(status: BookingDetailStatus.loading, error: null));
    try {
      final detail = await _repo.byRef(ref);
      if (isClosed) return;
      emit(state.copyWith(status: BookingDetailStatus.ready, detail: detail));
    } on BookingNotFound catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: BookingDetailStatus.failure, error: e));
    } on ApiError catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: BookingDetailStatus.failure, error: e));
    }
  }
}
