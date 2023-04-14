import 'package:json_annotation/json_annotation.dart';

part 'household.g.dart';

@JsonSerializable()
class Household {
  final String name;
  final String uid;
  final String owner;
  final String inventory;
  final List<String> members;

  const Household({
    required this.name,
    required this.uid,
    required this.owner,
    required this.inventory,
    required this.members,
  });

  factory Household.fromJson(Map<String, dynamic> json) =>
      _$HouseholdFromJson(json);

  Map<String, dynamic> toJson() => _$HouseholdToJson(this);
}
