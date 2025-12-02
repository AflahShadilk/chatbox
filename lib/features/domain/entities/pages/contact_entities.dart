import 'package:equatable/equatable.dart';

class ContactEntities extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final bool isRegistered;
  final String? userId;

  const ContactEntities(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      this.isRegistered = false,
      this.userId});

  @override
  List<Object?> get props => [id, name, phoneNumber, isRegistered, userId];
}
