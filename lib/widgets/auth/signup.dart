import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_consumer_auth/backend/auth.dart' as backend;
import 'package:web_consumer_auth/constants/colors.dart';
import 'package:web_consumer_auth/providers/auth_provider.dart';

class SignUp extends StatelessWidget {
  final AuthProvider authProvider;
  final switchWidget;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final controllerName = TextEditingController();
  final controllerUsername = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SignUp(
      {Key key,
      @required this.authProvider,
      @required this.switchWidget,
      @required this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: this.controllerName,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor ingrese su nombre';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      hintText: 'John Doe',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: this.controllerUsername,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor ingrese su nombre de usuario';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Nombre de Usuario',
                      hintText: 'john.doe',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: this.controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor ingrese su correo electrónico';
                      } else if (!value.contains('@')) {
                        return 'Por favor ingrese un correo electrónico válido';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      hintText: 'user@example.com',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: this.controllerPassword,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor ingrese su contraseña';
                      } else if (value.length < 6) {
                        return 'La contraseña de tener al menos 6 caracteres';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MaterialButton(
                      color: AppColors.ocean_green,
                      height: 46.0,
                      shape: StadiumBorder(),
                      child: Text(
                        "ACEPTAR",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // signup request
                          backend.signUp(
                                  controllerEmail.text,
                                  controllerPassword.text,
                                  controllerUsername.text,
                                  controllerName.text)
                              // succesful: save data and set state to connected
                              .then((user) {
                            _writePreferences(user);
                            authProvider.connect(user.name, user.username);
                            Navigator.pop(context, user);
                          })
                              // show error if it wasn't succesful
                              .catchError(
                            (error) {
                              scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(error.toString()),
                                ),
                              );
                            },
                          );
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MaterialButton(
                      color: Colors.white,
                      height: 46.0,
                      shape: StadiumBorder(),
                      child: Text(
                        "INICIAR SESIÓN",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.ocean_green,
                        ),
                      ),
                      onPressed: this.switchWidget),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

// Save user data after register
  _writePreferences(var user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', user.token);
    prefs.setString('name', user.name);
    prefs.setString('username', user.username);
  }
}
