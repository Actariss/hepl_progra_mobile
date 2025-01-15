import 'package:flutter/material.dart';
import 'package:hepl_progra_mobile/Adriaan/routes.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nobel Prizes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String user = userController.text;
      final bytes = utf8.encode(passwordController.text);
      final hash = sha256.convert(bytes);
      String pass = hash.toString();
      _formKey.currentState!.reset();

      if (await checkUser(user, pass)) {
        Navigator.of(context).pushReplacementNamed('/home', arguments: user);
      } else {
        final snackBar = const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('No such user found. Try registering'),
              ),
            ],
          ),
          showCloseIcon: true,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nobel Prizes App",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.primaryColor,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                height: 150,
                width: 150,
                padding: EdgeInsets.all(20),
                child: Image.asset("assets/images/nobel.png")),
            Form(
                key: _formKey,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.person),
                        labelText: "Username",
                        hintText: 'Enter your username',
                      ),
                      validator: (String? value) {
                        return (value == null || value.isEmpty)
                            ? "This field is required"
                            : null;
                      },
                      controller: userController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.password),
                        labelText: "Password",
                        hintText: 'Enter your password',
                      ),
                      validator: (String? value) {
                        return (value == null || value.isEmpty)
                            ? "This field is required"
                            : null;
                      },
                      controller: passwordController,
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      width: 200,
                      child: FilledButton(
                          onPressed: _handleLogin,
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      width: 200,
                      child: FilledButton.tonal(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/register');
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                  ),
                ]))
          ],
        ),
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
  final _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final bytes = utf8.encode(passwordController.text);
      final hash = sha256.convert(bytes);
      User user =
          User(username: userController.text, password: hash.toString());
      await insertUser(user);
      Navigator.of(context).pushReplacementNamed('/');
      _formKey.currentState!.reset();
    }
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Register Page",
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          backgroundColor: theme.primaryColor,
        ),
        body: Form(
          key: _formKey,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.person),
                  labelText: "Username",
                  hintText: 'Enter your username',
                ),
                validator: (String? value) {
                  return (value == null || value.isEmpty)
                      ? "This field is required"
                      : null;
                },
                controller: userController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.password),
                  labelText: "Password",
                  hintText: 'Enter your password',
                ),
                validator: (String? value) {
                  return (value == null || value.isEmpty)
                      ? "This field is required"
                      : null;
                },
                controller: passwordController,
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: 200,
                child: FilledButton(
                    onPressed: _handleRegister,
                    child: Text(
                      "Create Account",
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ),
          ]),
        ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});
  final String user;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _startYear;
  int? _endYear;
  final int _minYear = 1901; // Nobel Prize inception year
  final int _maxYear = DateTime.now().year;
  final List<String> _categories = [
    'Physics',
    'Chemistry',
    'Medicine',
    'Literature',
    'Peace',
    'Economic Sciences',
  ];
  final Set<String> _selectedCategories = {};

  List<int> _generateYearList(int start, int end) {
    return List<int>.generate(end - start + 1, (index) => start + index);
  }

  @override
  Widget build(BuildContext context) {
    List<int> years = _generateYearList(_minYear, _maxYear);
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nobel Prizes",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Greetings ${widget.user}!",
              style: TextStyle(fontSize: 20),),
            SizedBox(height: 20),
            Text(
              'Start and End Year',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Start Year Dropdown
            DropdownButtonFormField<int>(
              value: _startYear,
              decoration: InputDecoration(
                labelText: 'Start Year',
                border: OutlineInputBorder(),
              ),
              items: years.map((year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _startYear = value;
                  if (_endYear != null && _endYear! < _startYear!) {
                    _endYear = null; // Reset end year if it's less than start year
                  }
                });
              },
            ),
            SizedBox(height: 20),
            // End Year Dropdown
            DropdownButtonFormField<int>(
              value: _endYear,
              decoration: InputDecoration(
                labelText: 'End Year',
                border: OutlineInputBorder(),
              ),
              items: years.where((year) => _startYear == null || year >= _startYear!).map((year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _endYear = value;
                });
              },
            ),
            SizedBox(height: 30),
            Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Checkboxes for categories
            Expanded(
              child: ListView(
                children: _categories.map((category) {
                  return CheckboxListTile(
                    title: Text(category),
                    value: _selectedCategories.contains(category),
                    onChanged: (isChecked) {
                      setState(() {
                        if (isChecked == true) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // Apply Filters Button
            Center(
              child: ElevatedButton.icon(
                label: Icon(Icons.search),
                onPressed: () {
                  if (_startYear == null || _endYear == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select both start and end years')),
                    );
                  } else if (_selectedCategories.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select at least one category')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Filters applied:\nYears: $_startYear to $_endYear\nCategories: ${_selectedCategories.join(', ')}',
                        ),
                        showCloseIcon: true,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}