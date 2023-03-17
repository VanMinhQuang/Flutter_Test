class Student {
  final dynamic id;
  final String name;
  final double gpa;

  Student({required this.id, required this.name, required this.gpa});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as dynamic,
      name: json['name'] as String,
      gpa: json['gpa'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gpa': gpa,
    };
  }
}
