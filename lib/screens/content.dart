import 'dart:developer';
import 'package:web_consumer_auth/backend/auth.dart' as backend;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_consumer_auth/constants/colors.dart';
import 'package:web_consumer_auth/providers/auth_provider.dart';
import 'package:web_consumer_auth/screens/auth.dart';

class Content extends StatefulWidget {
  final AuthProvider authState;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Content({Key key, @required this.authState}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  void initState() {
    super.initState();
    // load data on startup
    _readPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Bienvenido",
          style: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Color(0xffffffff),
          ),
        ),
        backgroundColor: AppColors.ocean_green,
        centerTitle: true,
      ),
      body: navigation(context),
    );
    ;
  }

  Widget navigation(BuildContext context) {
    return !widget.authState.isLogged
        ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: MaterialButton(
                color: AppColors.ocean_green,
                height: 46.0,
                shape: StadiumBorder(),
                child: Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Auth(
                              authProvider: widget.authState,
                            )),
                  );
                },
              ),
            ),
          )
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    widget.authState.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Color(0xff444444),
                    ),
                  ),
                ),
                Text(
                  widget.authState.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Color(0xff444444),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: MaterialButton(
                    color: AppColors.ocean_green,
                    height: 46.0,
                    shape: StadiumBorder(),
                    child: Text(
                      "Cerrar Sesión",
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _removePreferences();
                      widget.authState.disconnect();
                    },
                  ),
                ),
              ],
            ),
          );
  }

// Read user data
  _readPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "none";
    // Check token
    backend.checkToken(token)
    // if it's valid, load data
    .then((isValid) {
      if (isValid) {
      log("k");
        String name = prefs.getString('name');
        String username = prefs.getString('username');
        widget.authState.connect(name, username);
      } else {
        log("bruh");
        widget.authState.disconnect();
      }
    })
    // if not, set state to disconnected
    .catchError((error) {
      widget.authState.disconnect();
    });
  }

// Remove user data after logoff
  _removePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('name');
    prefs.remove('username');
  }
}
