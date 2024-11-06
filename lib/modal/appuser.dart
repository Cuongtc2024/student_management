class AppUser {
  String id;
  String? teacherID;
  String? teacherName;
  String role;
  String uid;
  late String email;
  late String? mathpoint;
  late String? chemistpoint;
  late String name;
  

  AppUser( 
      {required this.id,
       this.teacherID,
       this.teacherName,
      required this.role,
      required this.uid,
      required this.email,
      required this.name,
      this.chemistpoint,
      this.mathpoint});
}
