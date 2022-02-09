class UserData {
  late String id;
  late String displayName;
  late String email;
  late String role;
  late List<String> projects;

  UserData(String i, String d, String e, String r, List<String> p) {
    id = i;
    displayName = d;
    email = e;
    role = r;
    projects = p;
  }

  static UserData fromMap(Map<String, dynamic> map, String projectId) {
    List<dynamic> projects = map['projects'];
    return UserData(
      projectId,
      map['displayName'],
      map['email'],
      map['role'],
      projects.map((p) => p as String).toList()
    );
  }
}