import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:istaff/data/constants.dart' as constants;
import 'package:istaff/views/pages/home_page.dart';
import 'package:istaff/views/widget_tree.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    // Set initial value for easier testing
    _emailController.text = 'nurzaly@anm.gov.my';
    _passwordController.text = 'secret';
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');

    // if (token != null) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (_) => WidgetTree()),
    //   );
    // } else if (savedEmail != null && savedPassword != null) {
    //   // Prefill for dev/testing
    //   _emailController.text = savedEmail;
    //   _passwordController.text = savedPassword;
    //   setState(() {
    //     _rememberMe = true;
    //   });
    // }

    if (savedEmail != null && savedPassword != null) {
      // Prefill for dev/testing
      _emailController.text = savedEmail;
      _passwordController.text = savedPassword;

      setState(() {
        _rememberMe = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse(constants.apiBaseUrl + constants.loginEndpoint),
        headers: {
          'Content-Type': 'application/json', // Keep x-api-key as requested
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      setState(() {
        _isLoading = false;
      });

      final prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          final token = data['token'];
          final name = data['user']['name'] ?? 'User Name Not Provided';
          final email = data['user']['email'] ?? 'Email not provided';
          final avatarUrl = data['user']['avatar_url'] ?? 'Avatar Url not provided';
          
          await prefs.setString(constants.Kprefs.authTokenKey, token);
          await prefs.setString(constants.Kprefs.userNameKey, name);
          await prefs.setString(constants.Kprefs.userEmailKey, email);
          await prefs.setString(constants.Kprefs.userAvatarUrlKey, avatarUrl);

          if (_rememberMe) {
            await prefs.setString('saved_email', email);
            await prefs.setString('saved_password', password);
          } else {
            await prefs.remove('saved_email');
            await prefs.remove('saved_password');
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) {
                return WidgetTree();
              },
            ),
          );

        }
        else {
          _showDialog('Error', data['message'] ?? 'Login failed');
          _passwordController.clear();
        }
      } else {
        final data = jsonDecode(response.body);
        _showDialog('Error', data['error'] ?? 'Login failed');
        _passwordController.clear();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Login error: $e');
      _showDialog('Error', 'Something went wrong: $e');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Logo placeholder
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: Center(child: Text("Logo")),
                ),
                SizedBox(height: 40),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: [AutofillHints.email],
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Email is required';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                      return 'Enter a valid email';
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  autofillHints: [AutofillHints.password],
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Password is required';
                    if (value.length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Remember Me checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    Text("Remember Me"),
                  ],
                ),
                SizedBox(height: 16),

                // Login Button
                _isLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Text('Login'),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
