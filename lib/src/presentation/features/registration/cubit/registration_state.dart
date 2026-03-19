part of 'registration_cubit.dart';

class RegistrationState extends Equatable {
  const RegistrationState({
    this.gender = 'female',
    this.name = '',
    this.email = '',
    this.birthDate,
    this.code = '',
    this.step = 0,
    this.isLoading = false,
    this.error,
  });

  final String gender;
  final String name;
  final String email;
  final DateTime? birthDate;
  final String code;
  final int step;
  final bool isLoading;
  final String? error;

  bool get canContinueCode => code.trim().isNotEmpty;
  bool get isAdult => birthDate != null && AgeValidator.isAdult(birthDate!);

  bool get isFormValid =>
      NameValidator.isValid(name) &&
      EmailValidator.isValid(email) &&
      isAdult;

  RegistrationState copyWith({
    String? gender,
    String? name,
    String? email,
    DateTime? birthDate,
    String? code,
    int? step,
    bool? isLoading,
    String? error,
  }) {
    return RegistrationState(
      gender: gender ?? this.gender,
      name: name ?? this.name,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      code: code ?? this.code,
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => <Object?>[gender, name, email, birthDate, code, step, isLoading, error];
}
