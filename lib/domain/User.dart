class User {
  final String name;
  final String password;

  User({
    required this.name,
    required this.password,
  });
  Map<String, Object?> toMap(){
    return{
      'name':name,
      'password':password
    };
  }
  @override
  String toString(){
    return "The user registered is $name =|= $password";
  }
}