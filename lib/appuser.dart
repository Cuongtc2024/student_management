class AppUser {
  String id;
  String? techerId;
  String? techerName;
  String role;
  String uid;
  late String email;
  late String? mathpoint;
  late String? chemistpoint;
  late String name;
  

  AppUser( 
      {required this.id,
       this.techerId,
       this.techerName,
      required this.role,
      required this.uid,
      required this.email,
      required this.name,
      this.chemistpoint,
      this.mathpoint});
}
