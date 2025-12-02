import 'package:equatable/equatable.dart';

class GoogleEntities extends Equatable {
  final String userId;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? phoneNumber;
  const GoogleEntities(
      {required this.userId,
      required this.email,
      this.name,
      this.photoUrl,
      this.phoneNumber});

      GoogleEntities copyWith({
    String? userId,
    String? email,
    String? name,
    String? photoUrl,
    String? phoneNumber,
  }) {
    return GoogleEntities(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [userId, email, name, photoUrl, phoneNumber];
}
