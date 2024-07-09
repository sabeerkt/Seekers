// student_model.dart

class SeekerModel {
  String? name;
  String? secondname;
  String? email;
  String? image;
   String? number;
  String? description;

  SeekerModel({this.name, this.secondname, this.email, 
  required this.image,this.number, required this.description
  
  });

  factory SeekerModel.fromJson(Map<String, dynamic> json) {
    return SeekerModel(
      image: json['image'],
      name: json['name'] as String?,
      secondname: json['secondname'] as String?,
      email: json['email'] as String?,
       number: json['number'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'secondname': secondname,
      'email': email,
       'number': number,
      'description': description,
    };
  }
}
