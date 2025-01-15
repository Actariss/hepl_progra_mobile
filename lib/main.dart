import 'dart:convert';
// import 'package:json_annotation/json_annotation.dart';
import 'package:hepl_progra_mobile/route_dart.dart';
import 'package:flutter/material.dart';
import 'package:hepl_progra_mobile/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:multiselect/multiselect.dart';


void main() => runApp(const MyApp());

final class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Test",
      themeMode: _themeMode,
      theme: ThemeData.from(
          colorScheme: MaterialTheme.lightMediumContrastScheme()),
      // Applique le thème clair
      darkTheme:
          ThemeData.from(colorScheme: MaterialTheme.darkMediumContrastScheme()),
      // Applique le thème sombre
      initialRoute: "/",
      onGenerateRoute: RouteManager.generateroute,
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showBox = false;
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var login = "";

  Future<bool> _checkCreds(login, formPassword) async {
    var sharedPrefs = await SharedPreferences.getInstance();
    bool operation = false;
    setState(() {
      var password = sharedPrefs.getString(login);
      if (password != null) {
        if (password ==
            (sha256.convert(utf8.encode(formPassword))).toString()) {
          operation = true;
          this.login = login;
        }
      }
    });
    return operation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          actions: <Widget>[
            Switch(
              value: showBox,
              onChanged: (value) {
                setState(() {
                  showBox = value;
                });
                if (value) {
                  MyApp.of(context).changeTheme(ThemeMode.light);
                } else {
                  MyApp.of(context).changeTheme(ThemeMode.dark);
                }
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le champ Login ne peut être vide';
                            }
                            return null;
                          },
                          controller: loginController,
                          decoration: const InputDecoration(
                            hintText: "Login",
                            border: OutlineInputBorder(),
                            label: Text("Login"),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le champ Password ne peut être vide';
                            }
                            return null;
                          },
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(),
                            label: Text("Password"),
                          ),
                        ),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool checkResult = await _checkCreds(
                                loginController.text, passwordController.text);
                            if (checkResult) {
                              Navigator.of(context)
                                  .pushReplacementNamed("/home", arguments: login);
                            } else {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text(
                                            'Wrong Login or password'),
                                        content: const Text(
                                            'You submitted a wrong login or password'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ));
                            }
                          }

                          // Navigator.of(context).pushReplacementNamed("/home", arguments: "YEAH")
                        },
                        child: const Text("Connect")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("/register");
                        },
                        child: const Text("Register")),
                  ],
                ),
              ]),
        ));
  }
}

class HomePage extends StatefulWidget {
  final String data;

  
  const HomePage({super.key, required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}
enum Category {
  chemistry,
  literature,
  peace,
  physics,
  physiologyormedicine;

  static String categoryToString(category){
    switch(category){
      case Category.chemistry:
        return "Chemistry";
      case Category.literature:
        return "Literature";
      case Category.peace:
        return "Peace";
      case Category.physics:
        return "Physics";
      case Category.physiologyormedicine:
        return "Physiology or medicine";
      default:
        return "Unknown category";
    }
  }
}

class Nobel {
  String awardYear;
  Category category;
  Map <String, String> laureate;
  Nobel(this.awardYear, this.category, this.laureate);
  String get getAwardYear {
    return awardYear;
  }
  Category get getCategory {
    return category;
  }
  Map<String, String> get getLaureate {
    return laureate;
  }
  @override
  String toString() {
    String display = "Year: $awardYear\nCategory: $category\nLaureate: $laureate";
    return display;
  }

}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> nobelFutur;
  List<String> selectedYear = [];
  List<String> selectedCategory = [];
  // late Map<String, dynamic> nobelData;
  Future<Map<String, dynamic>> getPage() async{
    var reponse = await http.get(
        Uri.parse("https://api.nobelprize.org/2.1/nobelPrizes")
    );
    if (reponse.statusCode == 200) {
      var jsonResponse =
      jsonDecode(reponse.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    else{
      throw Exception('Failed to load nobel');
    }
  }


  @override
  void initState() {
    super.initState();
    nobelFutur = (getPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        actions: <Widget>[
          ElevatedButton(
              onPressed: (){
                Navigator.of(context).pushReplacementNamed("/");
              },
              child: const Text("Log out")),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Bonjour ${widget.data}"),
            DropDownMultiSelect(
              selectedValuesStyle: TextStyle(color: Colors.white),
              separator: '__',
              onChanged: (List<String> x) {
                setState(() {
                  selectedYear =x;
                });
              },
              options: const ['1901' , '1902' , '1903' , '1904' , "1905"],
              selectedValues: selectedYear,
              hint: const Text("Filter on year"),


            ),
            DropDownMultiSelect(
              selectedValuesStyle: TextStyle(color: Colors.white),
              separator: '__',
              onChanged: (List<String> x) {
                setState(() {
                  selectedCategory =x;
                });
              },
              options: const ['Chemistry' , 'Literature' , 'Peace' , 'Physics' , "Physiology or medicine"],
              selectedValues: selectedCategory,
              hint: const Text("Filter on category"),


            ),
            FutureBuilder(
                future: nobelFutur,
                builder: (context, snapshot){
                  if (snapshot.hasData) {
                    var data = snapshot.data!;
                    Set yearsNumber = {};
                    List<Widget> year = [];
                    List<Nobel> myNobels = [];
                    for (var nobel in data["nobelPrizes"]){
                      String year = nobel["awardYear"];
                      String categoryName = nobel["category"]["en"];
                      categoryName = categoryName.toLowerCase();
                      categoryName = categoryName.replaceAll(" ", "");
                      Category category = Category.values.byName(categoryName);
                      Map<String, String> laureates = {};
                      for (var laureate in nobel["laureates"]){
                        try {
                          laureates[laureate["knownName"]["en"]] =
                          laureate["motivation"]["en"];
                        }
                        on NoSuchMethodError {
                          laureates[laureate["orgName"]["en"]] =
                          laureate["motivation"]["en"];
                        }
                      }
                      myNobels.add(Nobel(year, category, laureates));
                    }

                    for (Nobel nobel in myNobels){
                      print(selectedCategory);
                      if (selectedYear.contains(nobel.getAwardYear)) {
                        if (yearsNumber.add(nobel.getAwardYear)) {
                          List<Widget> categories = [];
                          for (Nobel nobel2 in myNobels) {
                            List<Widget> laureate = [];
                            if (selectedCategory.contains(Category.categoryToString(nobel2.getCategory)) && selectedYear.contains(nobel2.getAwardYear)) {
                              if (nobel.getAwardYear == nobel2.getAwardYear) {
                                for (Nobel noble3 in myNobels) {
                                    if (noble3.getCategory ==
                                        nobel2.getCategory &&
                                        noble3.getAwardYear ==
                                            nobel2.getAwardYear) {
                                      for (var key in noble3.getLaureate.keys) {
                                        laureate.add(ListTile(title: Text(
                                            "Laureate name: $key")));
                                        laureate.add(ListTile(title: Text(
                                            "Laureate motivation: ${noble3
                                                .getLaureate[key]}")));
                                    }
                                  }
                                }
                              }
                              categories.add(ExpansionTile(title: Text(
                                  Category.categoryToString(
                                      nobel2.getCategory)),
                                children: laureate,));
                            }
                          }
                          year.add(ExpansionTile(title: Text(
                              nobel.getAwardYear), children: categories,));
                        }
                      }  // categorie.add(ExpansionTile(title: Text(nobel.getCategory.name)));
                    }
                    return Flexible(child: ListView(
                      children: year,
                    ));
                  }
                  else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                }
            ),

        ]),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  Future<void> _wipeCreds() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.clear();
  }

  Future<void> _storeCreds(String login, String password) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    var bytes = utf8.encode(password);
    var hashpasswd = sha256.convert(bytes);
    sharedPrefs.setString(login, "$hashpasswd");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register here"),
      ),
      body: Center(
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le champ Login ne peut être vide';
                        }
                        return null;
                      },
                      controller: loginController,
                      decoration: const InputDecoration(
                        hintText: "Login",
                        border: OutlineInputBorder(),
                        label: Text("Login"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le champ Password ne peut être vide';
                        }
                        return null;
                      },
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(),
                          label: Text("Password")),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _storeCreds(
                              loginController.text, passwordController.text);
                          Navigator.of(context).pushReplacementNamed("/");
                        },
                        child: const Text("login")),
                    ElevatedButton(onPressed: (){

                      _wipeCreds();
                      // setState(() {
                      //   clearState = "=> Done !";
                      // });
                      const snack = SnackBar(content: Text("Account cleared !"));
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    }, child: const Text("Clear all accounts"),),

                  ],
                ))
          ],
        ),
      ),
    );
  }
}

// @JsonSerializable()
// class Profile {
//   final String login;
//   final String hashedPassword;
//
//   Profile({required this.login, required this.hashedPassword})
//
//   factory Profile.fromJson(Map<String, dynamic> json) =>
//       _$ProfileFromJson(json);
//
//   Map<String, dynamic> toJson() => _$ProfileToJson(this);
//
//
// }
