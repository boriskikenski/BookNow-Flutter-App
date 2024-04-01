import 'package:book_now/model/dto/registerDTO.dart';
import 'package:book_now/model/exception/password_creation_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:book_now/service/auth_service.dart';

import '../firebase_options.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _fullName;
  late final TextEditingController _email;
  late final TextEditingController _username;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  String errorMessage = '';

  @override
  void initState() {
    _fullName = TextEditingController();
    _email = TextEditingController();
    _username = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _username.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SingleChildScrollView(
  //     child: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.only(top: 70.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //               child: TextField(
  //                 controller: _fullName,
  //                 obscureText: false,
  //                 decoration: InputDecoration(
  //                   hintText: 'Full name',
  //                   labelText: 'Full name',
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10.0),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
  //               child: TextField(
  //                 controller: _email,
  //                 obscureText: false,
  //                 enableSuggestions: false,
  //                 autocorrect: false,
  //                 keyboardType: TextInputType.emailAddress,
  //                 decoration: InputDecoration(
  //                   hintText: 'Email',
  //                   labelText: 'Email',
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10.0),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //               child: TextField(
  //                 controller: _username,
  //                 obscureText: false,
  //                 decoration: InputDecoration(
  //                   hintText: 'Username',
  //                   labelText: 'Username',
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10.0),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
  //               child: TextField(
  //                 controller: _password,
  //                 obscureText: true,
  //                 enableSuggestions: false,
  //                 autocorrect: false,
  //                 decoration: InputDecoration(
  //                   hintText: 'Password',
  //                   labelText: 'Password',
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10.0),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //               child: TextField(
  //                 controller: _confirmPassword,
  //                 obscureText: true,
  //                 enableSuggestions: false,
  //                 autocorrect: false,
  //                 decoration: InputDecoration(
  //                   hintText: 'Confirm Password',
  //                   labelText: 'Confirm Password',
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10.0),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             if(errorMessage.isNotEmpty)
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
  //                 child: Center(
  //                   child: Text(
  //                     errorMessage,
  //                     style: const TextStyle(color: Colors.red),
  //                   ),
  //                 ),
  //               ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10.0),
  //               child: ElevatedButton(
  //                 onPressed: () async{
  //                   try {
  //                     RegisterDTO costumer = RegisterDTO(
  //                         _fullName.text,
  //                         _username.text,
  //                         _email.text,
  //                         _password.text,
  //                         _confirmPassword.text
  //                     );
  //                     await AuthService().register(costumer);
  //                     Navigator.pop(context);
  //                   } on FirebaseAuthException catch (e) {
  //                     setState(() {
  //                       if (e.code == 'weak-password') {
  //                         errorMessage = 'Weak password!';
  //                       } else if (e.code == 'invalid-email') {
  //                         errorMessage = 'Invalid email!';
  //                       } else {
  //                         errorMessage = 'Already existing profile. Chose different mail and username.';
  //                       }
  //                     });
  //                   } catch (e) {
  //                     setState(() {
  //                       if (e is PasswordsNotMatchException) {
  //                         errorMessage = e.toString();
  //                       }
  //                     });
  //                   }
  //                 },
  //                 child: const Text('Register'),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 45),
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text('Cancel'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
        title: const Text('BookNow'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            controller: _fullName,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Full name',
                              labelText: 'Full name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                          child: TextField(
                            controller: _email,
                            obscureText: false,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            controller: _username,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                          child: TextField(
                            controller: _password,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            controller: _confirmPassword,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        if(errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                            child: Center(
                              child: Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10.0),
                          child: ElevatedButton(
                            onPressed: () async{
                              try {
                                RegisterDTO costumer = RegisterDTO(
                                    _fullName.text,
                                    _username.text,
                                    _email.text,
                                    _password.text,
                                    _confirmPassword.text
                                );
                                await AuthService().register(costumer);
                                Navigator.pushNamedAndRemoveUntil(context, '/login/', (route) => false);
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  if (e.code == 'weak-password') {
                                    errorMessage = 'Weak password!';
                                  } else if (e.code == 'invalid-email') {
                                    errorMessage = 'Invalid email!';
                                  } else {
                                    errorMessage = 'Already existing profile. Chose different mail and username.';
                                  }
                                });
                              } catch (e) {
                                setState(() {
                                  if (e is PasswordsNotMatchException) {
                                    errorMessage = e.toString();
                                  }
                                });
                              }
                            },
                            child: const Text('Register'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 45),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context, '/login/', (route) => false);
                            },
                            child: const Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      )
    );
  }
}
