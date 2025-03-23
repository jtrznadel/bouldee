import 'package:bloc/bloc.dart';
import 'package:bouldee/app/constants/enums.dart';
import 'package:bouldee/features/auth/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

@injectable
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._authRepository) : super(SignUpState.initial()) {
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignUpPhoneNumberChanged>(_onPhoneNumberChanged);
    on<SignUpUsernameChanged>(_onUsernameChanged);
    on<SignUpSubmitted>(_onSubmitted);
    on<SignUpResetForm>(_onResetForm);
  }
  final IAuthRepository _authRepository;

  void _onEmailChanged(
    SignUpEmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  void _onConfirmPasswordChanged(
    SignUpConfirmPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  void _onPhoneNumberChanged(
    SignUpPhoneNumberChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
  }

  void _onUsernameChanged(
    SignUpUsernameChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(username: event.username));
  }

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      if (validatePassword() == false) {
        emit(
          state.copyWith(
            status: Status.error,
            errorMessage: 'Passwords do not match.',
          ),
        );
        return;
      }
      await _authRepository.signUpWithEmailAndPassword(
        email: state.email,
        password: state.password,
        username: state.username,
        phoneNumber: state.phoneNumber,
      );
      emit(state.copyWith(status: Status.success));
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          status: Status.error,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.error,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  void _onResetForm(
    SignUpResetForm event,
    Emitter<SignUpState> emit,
  ) {
    emit(SignUpState.initial());
  }

  bool validatePassword() {
    return state.password == state.confirmPassword;
  }
}
