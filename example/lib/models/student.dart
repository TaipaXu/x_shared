class Student {
  String name;
  int age;

  Student({required this.name, required this.age});

  @override
  String toString() {
    return 'Student: {name: $name, age: $age}';
  }
}
