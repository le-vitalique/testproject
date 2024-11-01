class Contact {
  int id;
  String name;
  String phone;

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

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name': name,
    'phone': phone,
  };
}
