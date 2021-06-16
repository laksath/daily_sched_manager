import 'package:daily_schedule_manager/postauth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'logininfo.dart' as logininf;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    LoginHomePage(),
  );
}

class LoginHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.blueAccent,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: "HOME",
      home: LoginPageWidget(),
    );
  }
}

class LoginPageWidget extends StatefulWidget {
  @override
  LoginPageWidgetState createState() => LoginPageWidgetState();
}

class LoginPageWidgetState extends State<LoginPageWidget> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth;
  User user;
  bool isUserSignedIn = false;

  @override
  void initState() {
    super.initState();

    initApp();
  }

  void initApp() async {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    _auth = FirebaseAuth.instanceFor(app: defaultApp);
    checkIfUserIsSignedIn();
  }

  void checkIfUserIsSignedIn() async {
    var userSignedIn = await _googleSignIn.isSignedIn();
    logininf.user = _auth.currentUser;
    setState(() {
      isUserSignedIn = userSignedIn;
    });
  }

  Future<User> _handleSignIn() async {
    bool userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });

    if (isUserSignedIn) {
      user = _auth.currentUser;
      logininf.email = user.email;
      logininf.gSignIn = _googleSignIn;
      logininf.user = user;
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      user = (await _auth.signInWithCredential(credential)).user;
      userSignedIn = await _googleSignIn.isSignedIn();
      setState(() {
        isUserSignedIn = userSignedIn;
      });
    }

    return user;
  }

  void onGoogleSignIn(BuildContext context) async {
    user = await _handleSignIn();
    logininf.email = user.email;
    logininf.gSignIn = _googleSignIn;
    logininf.user = user;
    var userSignedIn = Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );

    setState(() {
      isUserSignedIn = userSignedIn == null ? true : false;
    });
  }

  Future<bool> _exitStay() {
    return showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: Text("Do you want to quit the application?"),
          actions: [
            RaisedButton(
              child: Text("Yes"),
              color: Colors.redAccent,
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            RaisedButton(
              child: Text("No"),
              color: Colors.green,
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _ht = MediaQuery.of(context).size.height;
    final _wd = MediaQuery.of(context).size.width;
    final _topPadding = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: () {
        return _exitStay();
      },
      child: Scaffold(
        body: isUserSignedIn
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: _wd * 0.1),
                child: Column(
                  children: [
                    Container(
                      child: SizedBox(
                        height: _topPadding * 1.5,
                        width: _wd,
                      ),
                    ),
                    Container(
                      height: (_ht - _topPadding) * 0.15,
                      child: FittedBox(
                        child: Text(
                          "Welcome\n${logininf.user.displayName}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: (_ht - _topPadding) * 0.01,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(logininf.user.photoURL),
                      radius: (_ht - _topPadding) * 0.1,
                    ),
                    SizedBox(height: (_ht - _topPadding) * 0.3),
                    Container(
                      width: _wd * 0.8,
                      height: (_ht - _topPadding) * 0.1,
                      child: SignInButton(
                        Buttons.GoogleDark,
                        text: "Sign out from Google",
                        onPressed: () {
                          logininf.gSignIn.signOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPageWidget(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: (_ht - _topPadding) * 0.01),
                    Container(
                      width: _wd * 0.8,
                      height: (_ht - _topPadding) * 0.1,
                      child: RaisedButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          child: FittedBox(
                            child: Text(
                              "Continue as ${logininf.user.displayName}",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                        color: Colors.green,
                        onPressed: () {
                          onGoogleSignIn(context);
                        },
                      ),
                    )
                  ],
                ),
              )
            : Container(
                margin: EdgeInsets.symmetric(horizontal: _wd * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: _topPadding * 1.5,
                    ),
                    Container(
                      height: (_ht - _topPadding) * 0.1,
                      child: FittedBox(
                        child: Text(
                          "PRODUCTIVE DAILY SCHEDULE MANAGER",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: (_ht - _topPadding) * 0.05,
                    ),
                    Container(
                      height: _wd * 0.9 * 2400 / 3840,
                      width: _wd * 0.9,
                      child: Image.asset(
                        "images/work.jpg",
                      ),
                    ),
                    SizedBox(
                      height: (_ht - _topPadding) * 0.05,
                    ),
                    SignInButton(
                      Buttons.GoogleDark,
                      onPressed: () {
                        onGoogleSignIn(context);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
