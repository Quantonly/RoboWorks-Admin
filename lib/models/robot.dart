class Robot {
  late String id;
  late String name;
  late String project;

  Robot(String i, String n, String p) {
    id = i;
    name = n;
    project = p;
  }

  static Robot fromMap(Map<String, dynamic> map, String projectId) {
    return Robot(
      projectId,
      map['name'],
      map['project'],
    );
  }
} 