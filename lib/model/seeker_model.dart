class SeekerModel {
  String? id; // Optional ID field
  String? name;
  String? secondname;
  String? email;
  String? image; // Image field is required
  String? number;
  String? description; // Description field is required
  String? pdf; // PDF field is required
  String? category;

  SeekerModel({
    this.id, // Optional ID field
    this.name,
    this.secondname,
    this.email,
    this.category,
    required this.image, // Required field
    this.number,
    required this.description, // Required field
    required this.pdf, // Required field
  });

  factory SeekerModel.fromJson(Map<String, dynamic> json) {
    return SeekerModel(
      id: json['id'] as String?, // Optional ID field
      image: json['image'] as String?, // Required field
      name: json['name'] as String?,
      secondname: json['secondname'] as String?,
      email: json['email'] as String?,
      number: json['number'] as String?,
      description: json['description'] as String?, // Required field
      pdf: json['pdf'] as String?, // Required field
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Optional ID field
      'category': category,
      'pdf': pdf, // Required field
      'image': image, // Required field
      'name': name,
      'secondname': secondname,
      'email': email,
      'number': number,
      'description': description, // Required field
    };
  }
}
