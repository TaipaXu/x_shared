# x_shared

A tool of Storing data.

## Installation

```yaml
dependencies:
  x_shared: ^1.0.0
```

## Usage

### Import

```dart
import 'package:x_shared/x_shared.dart';

XShared xShared = await XShared.getInstance();
```

### Basic usage

```dart
// bool
await xShared!.set('A', true);
bool? a = xShared!.get<bool>('A');
print('a $a');

// double
await xShared!.set('B', 0.0);
double? b = xShared!.get<double>('B');
print('b $b');

// int
await xShared!.set('C', 0);
int? c = xShared!.get<int>('C');
print('c $c');

// string
await xShared!.set('D', 'string');
String? d = xShared!.get<String>('D');
print('d $d');

// string list
await xShared!.set('E', <String>['a', 'b']);
List<String>? e = xShared!.get<List<String>>('E');
print('e $e');
```

### Store a class
```dart
String _encodeStudent(Student student) {
  return jsonEncode({
    'name': student.name,
    'age': student.age,
  });
}

Student _decodeStudent(String str) {
  Map<String, dynamic> jsonData = jsonDecode(str);
  return Student(name: jsonData['name'], age: jsonData['age']);
}

XShared.registerType<Student>(_encodeStudent, _decodeStudent);
XShared.registerType<Teacher>((Teacher teacher) => jsonEncode(teacher),
    (String str) => Teacher.fromJson(jsonDecode(str)));

Student studentA = Student(name: 'A', age: 0);
await xShared!.set<Student>('student_a', studentA);
Student? studentB = xShared!.get<Student>('student_a');
print(studentB);

Teacher teacherA = Teacher(name: 'A', age: 0);
await xShared!.set('teacher_a', teacherA);
Teacher? teacherB = xShared!.get('teacher_a');
print(teacherB);
```

### List of classes
```dart
XShared.registerType<List<Teacher>>(
    (List<Teacher> students) => jsonEncode(students), (String str) {
  Iterable l = json.decode(str);
  List<Teacher> teachers = l.map((item) => Teacher.fromJson(item)).toList();
  return teachers;
});

List<Teacher> studentsA = [
  Teacher(name: 'A', age: 0),
  Teacher(name: 'B', age: 1),
  Teacher(name: 'B', age: 2),
];
await xShared!.set<List<Teacher>>('students_a', studentsA);
List<Teacher>? studentsB = xShared!.get<List<Teacher>>('students_a');
print(studentsB);
```

### Group
```dart
String? name;
XShared xShared = await XShared.getInstance();
await XShared.clear();

xShared.set<String>('name', 'before global');
name = xShared.get<String>('name');
print('name $name'); // before global

XShared.setGlobalGroup('global_group');
name = xShared.get<String>('name');
print('name $name'); // null

xShared.set<String>('name', 'after global');
name = xShared.get<String>('name');
print('name $name'); // after global

xShared.startGroup('school');
xShared.set<String>('name', 'school');
name = xShared.get<String>('name');
print('name $name'); // school

xShared.startGroup('department');
xShared.set<String>('name', 'department');
name = xShared.get('name');
print('name $name'); // department

xShared.startGroup('office');
xShared.set<String>('name', 'office');
name = xShared.get('name');
print('name $name'); // office

xShared.startGroup('team');
xShared.set<String>('name', 'team');
name = xShared.get('name');
print('name $name'); // team

xShared.startGroup('teacher');
xShared.set<String>('name', 'teacher');
name = xShared.get('name');
print('name $name'); // teacher

xShared.endGroup();
name = xShared.get('name');
print('name $name'); // team

xShared.endGroup('office');
name = xShared.get('name');
print('name $name'); // department

xShared.clearGroup();
name = xShared.get('name');
print('name $name'); // after global

XShared.clearGlobalGroup();
name = xShared.get('name');
print('name $name'); // before global
```

### Remove
```dart
await xShared.set('A', true);
bool? a = xShared.get<bool>('A');
print('a $a');

xShared.remove('A');
a = xShared.get<bool>('A');
print('a $a');

xShared.startGroup('group');
await xShared.set('A', false);
a = xShared.get<bool>('A');
print('a $a');

xShared.remove('A');
a = xShared.get<bool>('A');
print('a $a');
```

### Clear
```dart
await XShared.clear();
```

## License

[BSD 3-Clause](LICENSE)
