class User {
  String? id;
  String name;
  int age;
  int educationalYears;

  User({required this.name, required this.age, required this.educationalYears});

  Map<String, dynamic> toJson() => {
        'id': '',
        'name': name,
        'age': age,
        'educationalYears': educationalYears,
      };

  static User fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'].toString(),
      age: int.parse(json['age'].toString()),
      educationalYears: int.parse(json['age'].toString()),
    );
  }
}
