import 'package:flutter/material.dart';
import '../logininfo.dart' as logininf;
import '../main.dart';

class AppBarClass extends StatelessWidget {
  final String _title;
  final double _wd;
  final double _topPadding;
  final GlobalKey<ScaffoldState> scaffoldKey;

  AppBarClass(
    this._title,
    this._wd,
    this._topPadding,
    this.scaffoldKey,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: _topPadding),
      height: 50 + _topPadding,
      child: Row(
        children: [
          Container(
            width: _wd * 0.15,
            child: FlatButton(
              onPressed: () {
                scaffoldKey.currentState.openDrawer();
              },
              child: Icon(Icons.menu),
            ),
          ),
          Container(
            width: _wd * 0.7,
            child: Text(
              _title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            width: _wd * 0.15,
            child: FlatButton(
              onPressed: () {
                logininf.gSignIn.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPageWidget()),
                );
              },
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      decoration: _title == "Home Page"
          ? BoxDecoration(
              color: Colors.black.withOpacity(0.1),
            )
          : BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue,
                  Colors.red,
                ],
              ),
            ),
    );
  }
}
