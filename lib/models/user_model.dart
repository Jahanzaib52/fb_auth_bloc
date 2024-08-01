import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CustomUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final int point;
  final String rank;
  const CustomUser({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.point,
    required this.rank,
  });
  factory CustomUser.fromDoc( {required DocumentSnapshot userDoc}) {
    final userData = userDoc.data() as Map<String, dynamic>?;
    return CustomUser(
      id: userDoc.id,
      name: userData!["name"],
      email: userData["email"],
      profileImage: userData["profileImage"],
      point: userData["point"],
      rank: userData["rank"],
    );
  }
  factory CustomUser.initial() {
    return const CustomUser(
      id: "",
      name: "",
      email: "",
      profileImage: "",
      point: -1,
      rank: "",
    );
  }
  @override
  List<Object> get props => [id, name, email, profileImage, point, rank];
  CustomUser copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    int? point,
    String? rank,
  }) {
    return CustomUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      point: point ?? this.point,
      rank: rank ?? this.rank,
    );
  }
}
