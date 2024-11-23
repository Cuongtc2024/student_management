class AppUser {
  String id;
  String? teacherID;
  String? teacherName;
  String? role;
  String uid;
  String email;
  String? mathpoint;
  String? chemistpoint;
  String name;

  AppUser(
      {required this.id,
      required this.uid,
      required this.email,
      required this.name,
      this.teacherID,
      this.teacherName,
      this.role,
      this.chemistpoint,
      this.mathpoint});
}
