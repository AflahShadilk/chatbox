import 'package:equatable/equatable.dart';

class GoogleEntities extends Equatable{
  final String userId;
  final String email;
  final String? name;
  final String? photoUrl;
  const GoogleEntities({required this.userId,required this.email,this.name,this.photoUrl});
  
  @override
  List<Object?> get props => [userId,email,name,photoUrl];
}