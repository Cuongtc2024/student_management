class AppUser {
  String id;
  String? techerId;
  String? techerName;
  String role;
  String uid;
  late String email;
  late String? mapo;
  late String? chepo;
  late String name;
  

  AppUser(
      {required this.id,
       this.techerId,
       this.techerName,
      required this.role,
      required this.uid,
      required this.email,
      required this.name,
      this.chepo,
      this.mapo});
}
