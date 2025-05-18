// 📁 File: test/repositories/auth_repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/repositories/auth_repository.dart';
import 'package:event_app/models/user_model.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  User,
  UserCredential,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
])
void main() {
  late MockFirebaseAuth mockAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockGoogleUser;
  late MockGoogleSignInAuthentication mockGoogleAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDoc;
  late AuthRepository repository;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockGoogleUser = MockGoogleSignInAccount();
    mockGoogleAuth = MockGoogleSignInAuthentication();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDoc = MockDocumentReference();

    repository = AuthRepository(
      auth: mockAuth,
      googleSignIn: mockGoogleSignIn,
      firestore: mockFirestore,
    );
  });

  test('signInWithGoogle returns a CustomUser when sign-in is successful', () async {
    // Arrange
    when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleUser);
    when(mockGoogleUser.authentication).thenAnswer((_) async => mockGoogleAuth);
    when(mockGoogleAuth.accessToken).thenReturn('access-token');
    when(mockGoogleAuth.idToken).thenReturn('id-token');
    when(mockAuth.signInWithCredential(any)).thenAnswer((_) async => mockUserCredential);
    when(mockUserCredential.user).thenReturn(mockUser);

    when(mockUser.uid).thenReturn('123');
    when(mockUser.displayName).thenReturn('Test User');
    when(mockUser.email).thenReturn('test@example.com');
    when(mockUser.photoURL).thenReturn('http://photo.url');

    when(mockFirestore.collection('users')).thenReturn(mockCollection);
    when(mockCollection.doc('123')).thenReturn(mockDoc);
    when(mockDoc.set(any)).thenAnswer((_) async => {});

    // Act
    final result = await repository.signInWithGoogle();

    // Assert
    expect(result, isA<CustomUser>());
    expect(result!.uid, '123');
    expect(result.displayName, 'Test User');
    verify(mockDoc.set(any)).called(1);
  });

  test('getCurrentUser returns CustomUser when Firebase currentUser is present', () {
    // Arrange
    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('123');
    when(mockUser.displayName).thenReturn('Tester');
    when(mockUser.email).thenReturn('tester@example.com');
    when(mockUser.photoURL).thenReturn('photo.jpg');

    // Act
    final result = repository.getCurrentUser();

    // Assert
    expect(result, isA<CustomUser>());
    expect(result!.uid, '123');
    expect(result.displayName, 'Tester');
  });
}