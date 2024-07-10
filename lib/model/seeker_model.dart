class SeekerModel {
  String? id; // Add this line
  String? name;
  String? secondname;
  String? email;
  String? image;
  String? number;
  String? description;
  String? pdf;
  String? category;

  SeekerModel({
    this.id, // Add this line
    this.name,
    this.secondname,
    this.email,
    this.category,
    required this.image,
    this.number,
    required this.description,
    required this.pdf,
  });

  factory SeekerModel.fromJson(Map<String, dynamic> json) {
    return SeekerModel(
      id: json['id'] as String?, // Add this line
      image: json['image'],
      name: json['name'] as String?,
      secondname: json['secondname'] as String?,
      email: json['email'] as String?,
      number: json['number'] as String?,
      description: json['description'] as String?,
      pdf: json['pdf'] as String?,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Add this line
      'category': category,
      'pdf': pdf,
      'image': image,
      'name': name,
      'secondname': secondname,
      'email': email,
      'number': number,
      'description': description,
    };
  }
}