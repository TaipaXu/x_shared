// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:x_shared/x_shared.dart';
import 'package:x_shared_example/models/student.dart';
import 'package:x_shared_example/models/teacher.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XShared Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XShared? _xShared;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    _xShared = await XShared.getInstance();
    XShared.registerType<Student>(_encodeStudent, _decodeStudent);
    XShared.registerType<Teacher>((Teacher teacher) => jsonEncode(teacher),
        (String str) => Teacher.fromJson(jsonDecode(str)));

    XShared.registerType<List<Teacher>>(
        (List<Teacher> students) => jsonEncode(students), (String str) {
      Iterable l = json.decode(str);
      List<Teacher> teachers = l.map((item) => Teacher.fromJson(item)).toList();
      return teachers;
    });
  }

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

  // Basic
  void _basic() async {
    // Bool
    await _xShared!.set('A', true);
    bool? a = _xShared!.get<bool>('A');
    print('a $a');

    // Double
    await _xShared!.set('B', 0.0);
    double? b = _xShared!.get<double>('B');
    print('b $b');

    // Int
    await _xShared!.set('C', 0);
    int? c = _xShared!.get<int>('C');
    print('c $c');

    // String
    await _xShared!.set('D', 'string');
    String? d = _xShared!.get<String>('D');
    print('d $d');

    // String list
    await _xShared!.set('E', <String>['a', 'b']);
    List<String>? e = _xShared!.get<List<String>>('E');
    print('e $e');
  }

  // Class
  void _class() async {
    Student studentA = Student(name: 'A', age: 0);
    await _xShared!.set<Student>('student_a', studentA);
    Student? studentB = _xShared!.get<Student>('student_a');
    print(studentB);

    Teacher teacherA = Teacher(name: 'A', age: 0);
    await _xShared!.set('teacher_a', teacherA);
    Teacher? teacherB = _xShared!.get('teacher_a');
    print(teacherB);
  }

  // List of classes
  void _listOfClasses() async {
    List<Teacher> studentsA = [
      Teacher(name: 'A', age: 0),
      Teacher(name: 'B', age: 1),
      Teacher(name: 'B', age: 2),
    ];
    await _xShared!.set<List<Teacher>>('students_a', studentsA);
    List<Teacher>? studentsB = _xShared!.get<List<Teacher>>('students_a');
    print(studentsB);
  }

  // Group
  void _group() async {
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
  }

  // Remove
  void _remove() async {
    XShared xShared = await XShared.getInstance();

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
  }

  // Clear
  void _clear() async {
    await XShared.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('XShared'),
        actions: [
          TextButton(
              onPressed: () {
                // xShared.clear();
              },
              child: Text('Clear'))
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 10),
        children: <Widget>[
          MaterialButton(
            color: Colors.blue,
            onPressed: _basic,
            child: Text(
              'Basic',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          MaterialButton(
            color: Colors.blue,
            onPressed: _class,
            child: Text(
              'Class',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          MaterialButton(
            color: Colors.blue,
            onPressed: _listOfClasses,
            child: Text(
              'List of class',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          MaterialButton(
            color: Colors.blue,
            onPressed: _group,
            child: Text(
              'Group',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          MaterialButton(
            color: Colors.blue,
            onPressed: _remove,
            child: Text(
              'Remove',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          MaterialButton(
            color: Colors.blue,
            onPressed: _clear,
            child: Text(
              'Clear',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
