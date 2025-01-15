import 'package:flutter/material.dart';
import 'package:hepl_progra_mobile/user_controller.dart';
import 'package:flutter/widgets.dart';


main() {
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: "/",
      onGenerateRoute: RouteManager.generateroute,
    );
  }
}

class HomePage extends StatelessWidget {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            TextFormField(
              controller: loginController,
              decoration: const InputDecoration(
                hintText: "Login",
                border: OutlineInputBorder(),
                label: Text("Login"),
              ),
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
                label: Text("Password"),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  UserController.insertUser(loginController.text, passwordController.text);
                  Navigator.of(context).pushNamed("/user");
                  } ,
                child: const Text("Register")
            ),
          ],
        ),
      ),
    );
  }
}

class RouteManager {
  static Route<dynamic> generateroute(RouteSettings settings){

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/user' :
        return MaterialPageRoute(
          builder: (_) => UserPage(),
        );

      default:
        return _errorRoute();

    }
  }
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error'),
        ),
      );
    });
  }
}

class UserPage extends StatefulWidget {

  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<List<Map<String, dynamic>>> userData = UserController.getUser();

  List<Widget> userWig = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
                future: userData,
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    var data = snapshot.data!;
                    for(Map user in data){
                      userWig.add(Text("Login : ${user["name"]} Password : ${user["password"]}"));
                    }
                    return SizedBox(height: 300,child: ListView(children: userWig,),);
                  }
                  else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                })
          ],
        ),
      ),
    );
  }
}