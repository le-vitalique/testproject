class Contact {
  final int id;
  final String name;
  final String phone;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
  });

  Contact.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          name: json['name'],
          phone: json['phone'],
        );
}
