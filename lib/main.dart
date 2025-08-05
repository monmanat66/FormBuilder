import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ข้อมูลนักศึกษา',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/form': (context) => const FormPage(),
        '/list': (context) => const ListPage(),
      },
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('th')],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ข้อมูลนักศึกษา')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/form'),
              child: const Text('กรอกข้อมูลนักศึกษา'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/list'),
              child: const Text('ดูข้อมูลนักศึกษา'),
            ),
          ],
        ),
      ),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> _saveStudentData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('students_json') ?? '[]';
    final List<dynamic> students = jsonDecode(jsonString);
    students.add(data);
    await prefs.setString('students_json', jsonEncode(students));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('กรอกข้อมูลนักศึกษา')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'name',
                initialValue: 'ชื่อ นามสกุลตัวอย่าง',
                decoration: const InputDecoration(labelText: 'ชื่อ-นามสกุล'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'กรุณากรอกชื่อ-นามสกุล'),
                  FormBuilderValidators.minLength(5, errorText: 'อย่างน้อย 5 ตัวอักษร'),
                ]),
              ),
              FormBuilderTextField(
                name: 'student_id',
                initialValue: '1234567890',
                decoration: const InputDecoration(labelText: 'รหัสนักศึกษา'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'กรุณากรอกรหัสนักศึกษา'),
                  FormBuilderValidators.numeric(errorText: 'ต้องเป็นตัวเลข'),
                  FormBuilderValidators.equalLength(10, errorText: 'ต้องเป็น 10 หลัก'),
                ]),
              ),
              FormBuilderTextField(
                name: 'email',
                initialValue: 'student@example.com',
                decoration: const InputDecoration(labelText: 'อีเมล'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'กรุณากรอกอีเมล'),
                  FormBuilderValidators.email(errorText: 'รูปแบบอีเมลไม่ถูกต้อง'),
                ]),
              ),
              FormBuilderTextField(
                name: 'phone',
                initialValue: '0812345678',
                decoration: const InputDecoration(labelText: 'เบอร์โทร'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'กรุณากรอกเบอร์โทร'),
                  FormBuilderValidators.numeric(errorText: 'ต้องเป็นตัวเลข'),
                  FormBuilderValidators.minLength(10, errorText: 'อย่างน้อย 10 หลัก'),
                ]),
              ),
              FormBuilderDateTimePicker(
                name: 'birthdate',
                initialValue: DateTime.now().subtract(const Duration(days: 365 * 20)),
                inputType: InputType.date,
                format: DateFormat('dd/MM/yyyy'),
                decoration: const InputDecoration(labelText: 'วันเกิด'),
                validator: FormBuilderValidators.required(errorText: 'กรุณาเลือกวันเกิด'),
              ),
              FormBuilderRadioGroup<String>(
                name: 'gender',
                initialValue: 'ชาย',
                decoration: const InputDecoration(labelText: 'เพศ'),
                options: const [
                  FormBuilderFieldOption(value: 'ชาย'),
                  FormBuilderFieldOption(value: 'หญิง'),
                  FormBuilderFieldOption(value: 'อื่นๆ'),
                ],
                validator: FormBuilderValidators.required(errorText: 'กรุณาเลือกเพศ'),
              ),
              FormBuilderCheckboxGroup<String>(
                name: 'interests',
                initialValue: const ['กีฬา', 'ดนตรี'],
                decoration: const InputDecoration(labelText: 'ความสนใจ'),
                options: const [
                  FormBuilderFieldOption(value: 'กีฬา'),
                  FormBuilderFieldOption(value: 'ดนตรี'),
                  FormBuilderFieldOption(value: 'อ่านหนังสือ'),
                  FormBuilderFieldOption(value: 'เทคโนโลยี'),
                ],
                validator: FormBuilderValidators.minLength(1, errorText: 'เลือกอย่างน้อย 1 รายการ'),
              ),
              FormBuilderDropdown<String>(
                name: 'major',
                initialValue: 'วิทยาการคอมพิวเตอร์',
                decoration: const InputDecoration(labelText: 'สาขาวิชา'),
                items: ['วิทยาการคอมพิวเตอร์', 'วิศวกรรมศาสตร์', 'บริหารธุรกิจ', 'ศิลปศาสตร์']
                    .map((major) => DropdownMenuItem(value: major, child: Text(major)))
                    .toList(),
                validator: FormBuilderValidators.required(errorText: 'กรุณาเลือกสาขาวิชา'),
              ),
              FormBuilderSlider(
                name: 'gpa',
                initialValue: 3.5,
                min: 0.0,
                max: 4.0,
                divisions: 40,
                decoration: const InputDecoration(
                  labelText: 'เกรดเฉลี่ย (GPA)',
                  labelStyle: TextStyle(color: Colors.red),
                ),
                activeColor: Colors.red,
                inactiveColor: Colors.red.withOpacity(0.3),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'กรุณาเลือก GPA'),
                  FormBuilderValidators.min(0.0, errorText: 'GPA ต้องไม่ต่ำกว่า 0'),
                  FormBuilderValidators.max(4.0, errorText: 'GPA ต้องไม่เกิน 4'),
                ]),
              ),
              FormBuilderRangeSlider(
                name: 'score_range',
                initialValue: const RangeValues(50, 80),
                min: 0,
                max: 100,
                divisions: 100,
                decoration: const InputDecoration(labelText: 'ช่วงคะแนนสอบ'),
                validator: FormBuilderValidators.required(errorText: 'กรุณาเลือกช่วงคะแนน'),
              ),
              FormBuilderSwitch(
                name: 'is_member',
                initialValue: true,
                title: const Text('สมัครสมาชิกชมรม'),
                validator: FormBuilderValidators.required(errorText: 'กรุณาเลือกสถานะสมาชิก'),
              ),
              FormBuilderDateRangePicker(
                name: 'study_period',
                initialValue: DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 1460))),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
                format: DateFormat('dd/MM/yyyy'),
                decoration: const InputDecoration(labelText: 'ช่วงเวลาศึกษา'),
                validator: FormBuilderValidators.required(errorText: 'กรุณาเลือกช่วงเวลาศึกษา'),
              ),
              FormBuilderField<List<String>>(
                name: 'skills',
                initialValue: const ['プログラミング', 'ออกแบบ'],
                validator: FormBuilderValidators.minLength(1, errorText: 'เลือกอย่างน้อย 1 ทักษะ'),
                builder: (FormFieldState<List<String>> field) {
                  return InputDecorator(
                    decoration: const InputDecoration(labelText: 'ทักษะ (Filter Chip)'),
                    child: Wrap(
                      spacing: 8.0,
                      children: [
                        ChoiceChip(
                          label: const Text('プログラミング'),
                          selected: field.value?.contains('プログラミング') ?? false,
                          onSelected: (selected) {
                            var newValue = List<String>.from(field.value ?? []);
                            if (selected) newValue.add('プログラミング');
                            else newValue.remove('プログラミング');
                            field.didChange(newValue);
                          },
                        ),
                        ChoiceChip(
                          label: const Text('ออกแบบ'),
                          selected: field.value?.contains('ออกแบบ') ?? false,
                          onSelected: (selected) {
                            var newValue = List<String>.from(field.value ?? []);
                            if (selected) newValue.add('ออกแบบ');
                            else newValue.remove('ออกแบบ');
                            field.didChange(newValue);
                          },
                        ),
                        ChoiceChip(
                          label: const Text('การตลาด'),
                          selected: field.value?.contains('การตลาด') ?? false,
                          onSelected: (selected) {
                            var newValue = List<String>.from(field.value ?? []);
                            if (selected) newValue.add('การตลาด');
                            else newValue.remove('การตลาด');
                            field.didChange(newValue);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        final data = Map<String, dynamic>.from(_formKey.currentState!.value);
                        data['birthdate'] = DateFormat('dd/MM/yyyy').format(data['birthdate']);
                        data['study_period'] = {
                          'start': DateFormat('dd/MM/yyyy').format(data['study_period'].start),
                          'end': DateFormat('dd/MM/yyyy').format(data['study_period'].end),
                        };
                        data['score_range'] = {
                          'start': data['score_range'].start,
                          'end': data['score_range'].end,
                        };
                        await _saveStudentData(data);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('บันทึกข้อมูล'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                    },
                    child: const Text('รีเซ็ต'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Map<String, dynamic>> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('students_json') ?? '[]';
    final List<dynamic> students = jsonDecode(jsonString);
    setState(() {
      _students = students.cast<Map<String, dynamic>>();
    });
  }

  void _showStudentDetails(BuildContext context, Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ข้อมูลนักศึกษา'),
          content: SingleChildScrollView(
            child: Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: student.entries.map((entry) {
                String valueStr = entry.value.toString();
                if (entry.value is Map) {
                  valueStr = jsonEncode(entry.value);
                } else if (entry.value is List) {
                  valueStr = (entry.value as List).join(', ');
                }
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('คีย์: ${entry.key}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('ค่า: $valueStr'),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ปิด'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายชื่อนักศึกษา')),
      body: _students.isEmpty
          ? const Center(child: Text('ไม่มีข้อมูลนักศึกษา'))
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return ListTile(
                  title: Text(student['name'] ?? 'ไม่ระบุชื่อ'),
                  subtitle: Text('รหัส: ${student['student_id'] ?? 'ไม่ระบุ'}'),
                  onTap: () => _showStudentDetails(context, student),
                );
              },
            ),
    );
  }
}