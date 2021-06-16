library dialy_schedule_manager.global;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './models/transactions.dart';

GoogleSignIn gSignIn = GoogleSignIn();
User user;

// set default values for the initial run
String email = '';
List<Transactions> trl = [];
