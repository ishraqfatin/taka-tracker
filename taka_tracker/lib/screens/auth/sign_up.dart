import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taka_tracker/services/utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final auth = FirebaseAuth.instance;

  bool _setLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  bool _validatePassword(String value) {
    return value.length >= 6;
  }

  bool _validateConfirmPassword(String value) {
    return value == _passwordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.5,
                image: AssetImage(
                  'assets/background_image.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Register for,",
                      style: TextStyle(
                        color: Color.fromARGB(255, 35, 35, 35),
                        fontSize: 14,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Taka',
                          style: TextStyle(
                            color: Color.fromARGB(255, 69, 172, 117),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Tracker',
                          style: TextStyle(
                            color: Color.fromARGB(255, 19, 30, 68),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    TextField(
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                      ),
                      
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        helperText: "* At least 6 characters",
                        helperStyle: const TextStyle(
                          fontSize: 12,
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                        prefixIcon: const Icon(Icons.lock, color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: _togglePasswordVisibility,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                          color: Colors.black, fontFamily: 'Roboto'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                        prefixIcon: const Icon(Icons.lock, color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: _toggleConfirmPasswordVisibility,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                      style: const TextStyle(
                          color: Colors.black, fontFamily: 'Roboto'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (ValidatorClass()
                                .validateUserName(_usernameController.text) !=
                            null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color.fromARGB(255, 144, 4, 4),
                              showCloseIcon: true,
                              content: Text('Enter a Username'),
                            ),
                          );
                          return;
                        }
                        if (ValidatorClass()
                                .validateEmail(_emailController.text) !=
                            null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color.fromARGB(255, 144, 4, 4),
                              showCloseIcon: true,
                              content: Text('Enter a valid Email'),
                            ),
                          );
                          return;
                        }
                        if (!_validatePassword(_passwordController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color.fromARGB(255, 144, 4, 4),
                              showCloseIcon: true,
                              content: Text(
                                  'Password must be at least 6 characters long.'),
                            ),
                          );
                          return;
                        }

                        if (!_validateConfirmPassword(
                            _confirmPasswordController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              showCloseIcon: true,
                              backgroundColor:
                                  const Color.fromARGB(255, 144, 4, 4),
                              content: const Text('Passwords do not match.'),
                              width: 280.0, // Width of the SnackBar.
                              padding: const EdgeInsets.symmetric(
                                horizontal:
                                    8.0, // Inner padding for SnackBar content.
                              ),
                              behavior: SnackBarBehavior.floating,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          );
                          return;
                        }

                        //API here...
                        try {
                          setState(() {
                            _setLoading = true;
                          });
                          await auth.createUserWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                              )
                              .then(
                                (res) => {
                                  if (res.user != null)
                                    {
                                      res.user!.updateDisplayName(
                                          _usernameController.text)
                                    }
                                },
                              );
                          setState(() {
                            _setLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              showCloseIcon: true,
                              backgroundColor:
                                  const Color.fromARGB(255, 4, 144, 97),
                              content: const Text('Successfully Signed Up!'),
                              width: 280.0, // Width of the SnackBar.
                              padding: const EdgeInsets.symmetric(
                                horizontal:
                                    8.0, // Inner padding for SnackBar content.
                              ),
                              behavior: SnackBarBehavior.floating,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          );
                          _emailController.clear();
                          _passwordController.clear();
                          _confirmPasswordController.clear();
                        } catch (error) {
                          setState(() {
                            _setLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              showCloseIcon: true,
                              backgroundColor:
                                  const Color.fromARGB(255, 144, 4, 4),
                              content: const Text('Something went wrong :('),
                              width: 280.0, // Width of the SnackBar.
                              padding: const EdgeInsets.symmetric(
                                horizontal:
                                    8.0, // Inner padding for SnackBar content.
                              ),
                              behavior: SnackBarBehavior.floating,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _setLoading
                          ? const CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: Color.fromARGB(255, 10, 149, 91),
                            )
                          : const Text(
                              'Sign Up',
                              style:
                                  TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                            ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            // Navigate to sign in screen
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Roboto'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
