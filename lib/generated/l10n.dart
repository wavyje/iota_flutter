// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: 'address',
      args: [],
    );
  }

  /// `Street, Number, Postal Code, City`
  String get addressForm {
    return Intl.message(
      'Street, Number, Postal Code, City',
      name: 'addressForm',
      desc: 'form of address',
      args: [],
    );
  }

  /// `Authority Login`
  String get authorityLogin {
    return Intl.message(
      'Authority Login',
      name: 'authorityLogin',
      desc: 'Button for authority login',
      args: [],
    );
  }

  /// `Birthday`
  String get birthday {
    return Intl.message(
      'Birthday',
      name: 'birthday',
      desc: 'birthday',
      args: [],
    );
  }

  /// `Birthplace`
  String get birthplace {
    return Intl.message(
      'Birthplace',
      name: 'birthplace',
      desc: 'birthplace',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: 'cancel button',
      args: [],
    );
  }

  /// `Certificates`
  String get certificates {
    return Intl.message(
      'Certificates',
      name: 'certificates',
      desc: 'title of certificate page',
      args: [],
    );
  }

  /// `Certificates are valid!`
  String get certificatesValid {
    return Intl.message(
      'Certificates are valid!',
      name: 'certificatesValid',
      desc: 'appears when certificates are valid',
      args: [],
    );
  }

  /// `Certificate Created Successfully!`
  String get certificateSuccess {
    return Intl.message(
      'Certificate Created Successfully!',
      name: 'certificateSuccess',
      desc: 'when certificate was created successfully',
      args: [],
    );
  }

  /// `Check Certificate`
  String get checkCertificate {
    return Intl.message(
      'Check Certificate',
      name: 'checkCertificate',
      desc: 'Check the certificates',
      args: [],
    );
  }

  /// `Choose an Image`
  String get chooseImage {
    return Intl.message(
      'Choose an Image',
      name: 'chooseImage',
      desc: 'choose the profile picture',
      args: [],
    );
  }

  /// `Create QR Code`
  String get createQR {
    return Intl.message(
      'Create QR Code',
      name: 'createQR',
      desc: 'create QR Code',
      args: [],
    );
  }

  /// `Delete Data`
  String get deleteDataButton {
    return Intl.message(
      'Delete Data',
      name: 'deleteDataButton',
      desc: 'Button for deleting data',
      args: [],
    );
  }

  /// `Expiration Date: `
  String get expirationDate {
    return Intl.message(
      'Expiration Date: ',
      name: 'expirationDate',
      desc: 'when the certificate expires',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: 'first name',
      args: [],
    );
  }

  /// `Health Certificate`
  String get healthCertificate {
    return Intl.message(
      'Health Certificate',
      name: 'healthCertificate',
      desc: 'certificate of health check up',
      args: [],
    );
  }

  /// `Health Certificate could not be found`
  String get healthCertificateNotFound {
    return Intl.message(
      'Health Certificate could not be found',
      name: 'healthCertificateNotFound',
      desc: 'shows when health certificate could not be found',
      args: [],
    );
  }

  /// `Registration Certificate valid until `
  String get healthCertificateUpload {
    return Intl.message(
      'Registration Certificate valid until ',
      name: 'healthCertificateUpload',
      desc: 'shows on the health certificate upload page',
      args: [],
    );
  }

  /// `The image must show the face clearly`
  String get imageInformation {
    return Intl.message(
      'The image must show the face clearly',
      name: 'imageInformation',
      desc: 'information of image content',
      args: [],
    );
  }

  /// `Image saved successfully!`
  String get imageSuccess {
    return Intl.message(
      'Image saved successfully!',
      name: 'imageSuccess',
      desc: 'when image uploaded successfully',
      args: [],
    );
  }

  /// `A picture must be uploaded!`
  String get imageWarning {
    return Intl.message(
      'A picture must be uploaded!',
      name: 'imageWarning',
      desc: 'informs of obligatory picture upload',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: 'last name',
      args: [],
    );
  }

  /// `Nationality`
  String get nationality {
    return Intl.message(
      'Nationality',
      name: 'nationality',
      desc: 'nationality',
      args: [],
    );
  }

  /// `Not Existing`
  String get notExisting {
    return Intl.message(
      'Not Existing',
      name: 'notExisting',
      desc: 'when certificate not existing',
      args: [],
    );
  }

  /// `Obligatory`
  String get obligatoryField {
    return Intl.message(
      'Obligatory',
      name: 'obligatoryField',
      desc: 'Appears when obligatory field was not filled',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: 'password',
      args: [],
    );
  }

  /// `Password Incorrect`
  String get passwordIncorrect {
    return Intl.message(
      'Password Incorrect',
      name: 'passwordIncorrect',
      desc: 'password incorrect',
      args: [],
    );
  }

  /// `Personal Data`
  String get personalData {
    return Intl.message(
      'Personal Data',
      name: 'personalData',
      desc: 'personal data',
      args: [],
    );
  }

  /// `Registration`
  String get prostituteLogin {
    return Intl.message(
      'Registration',
      name: 'prostituteLogin',
      desc: 'Button for prostitute login',
      args: [],
    );
  }

  /// `Registration Certificate`
  String get registrationCertificate {
    return Intl.message(
      'Registration Certificate',
      name: 'registrationCertificate',
      desc: 'certificate of registering',
      args: [],
    );
  }

  /// `Registration Certificate could not be found`
  String get registrationCertificateNotFound {
    return Intl.message(
      'Registration Certificate could not be found',
      name: 'registrationCertificateNotFound',
      desc: 'shows when registration could not be found',
      args: [],
    );
  }

  /// `Registration`
  String get registrationPage {
    return Intl.message(
      'Registration',
      name: 'registrationPage',
      desc: 'title of registration page',
      args: [],
    );
  }

  /// `For Prostitutes`
  String get saveCertificates {
    return Intl.message(
      'For Prostitutes',
      name: 'saveCertificates',
      desc: 'certificates can be saved',
      args: [],
    );
  }

  /// `Scan QR Code`
  String get scanQR {
    return Intl.message(
      'Scan QR Code',
      name: 'scanQR',
      desc: 'Button for QR scanning (customer)',
      args: [],
    );
  }

  /// `Searching the Tangle, please wait`
  String get searchingNetwork {
    return Intl.message(
      'Searching the Tangle, please wait',
      name: 'searchingNetwork',
      desc: 'appears while checking the certificates',
      args: [],
    );
  }

  /// `Upload Certificate`
  String get uploadCertificate {
    return Intl.message(
      'Upload Certificate',
      name: 'uploadCertificate',
      desc: 'upload Certificate',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
