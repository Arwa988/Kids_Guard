import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kids_guard/firebase_options.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  static FirebaseFirestore? _firestore;
  static FirebaseAuth? _auth;

  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
  }

  FirebaseFirestore get firestore => _firestore!;
  FirebaseAuth get auth => _auth!;

  // Get current user ID
  String? get currentUserId => auth.currentUser?.uid;
  
  // Check if user is logged in
  bool get isLoggedIn => auth.currentUser != null;
}