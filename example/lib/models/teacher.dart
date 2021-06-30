class Teacher {
  String name;
  int age;

  Teacher({required this.name, required this.age});

  @override
  String toString() {
    return 'Teacher: {name: $name, age: $age}';
  }

  Teacher.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        age = json['age'];

  Map<String, dynamic> toJson() => {'name': name, 'age': age};
}
