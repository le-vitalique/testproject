import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  @JsonKey(includeIfNull: false)
  int? id;
  String name;
  String phone;

  Contact({
    this.id,
    required this.name,
    required this.phone,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
