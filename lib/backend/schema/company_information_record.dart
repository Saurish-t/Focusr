import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CompanyInformationRecord extends FirestoreRecord {
  CompanyInformationRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "logo" field.
  String? _logo;
  String get logo => _logo ?? '';
  bool hasLogo() => _logo != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  bool hasPhone() => _phone != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  // "appleStoreURL" field.
  String? _appleStoreURL;
  String get appleStoreURL => _appleStoreURL ?? '';
  bool hasAppleStoreURL() => _appleStoreURL != null;

  // "playStoreURL" field.
  String? _playStoreURL;
  String get playStoreURL => _playStoreURL ?? '';
  bool hasPlayStoreURL() => _playStoreURL != null;

  // "coverImage" field.
  String? _coverImage;
  String get coverImage => _coverImage ?? '';
  bool hasCoverImage() => _coverImage != null;

  // "company_bio" field.
  String? _companyBio;
  String get companyBio => _companyBio ?? '';
  bool hasCompanyBio() => _companyBio != null;

  // "termsURL" field.
  String? _termsURL;
  String get termsURL => _termsURL ?? '';
  bool hasTermsURL() => _termsURL != null;

  // "chef_info" field.
  List<ChefsStruct>? _chefInfo;
  List<ChefsStruct> get chefInfo => _chefInfo ?? const [];
  bool hasChefInfo() => _chefInfo != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _logo = snapshotData['logo'] as String?;
    _email = snapshotData['email'] as String?;
    _phone = snapshotData['phone'] as String?;
    _address = snapshotData['address'] as String?;
    _appleStoreURL = snapshotData['appleStoreURL'] as String?;
    _playStoreURL = snapshotData['playStoreURL'] as String?;
    _coverImage = snapshotData['coverImage'] as String?;
    _companyBio = snapshotData['company_bio'] as String?;
    _termsURL = snapshotData['termsURL'] as String?;
    _chefInfo = getStructList(
      snapshotData['chef_info'],
      ChefsStruct.fromMap,
    );
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('company_information');

  static Stream<CompanyInformationRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CompanyInformationRecord.fromSnapshot(s));

  static Future<CompanyInformationRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => CompanyInformationRecord.fromSnapshot(s));

  static CompanyInformationRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CompanyInformationRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CompanyInformationRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CompanyInformationRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CompanyInformationRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CompanyInformationRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCompanyInformationRecordData({
  String? name,
  String? logo,
  String? email,
  String? phone,
  String? address,
  String? appleStoreURL,
  String? playStoreURL,
  String? coverImage,
  String? companyBio,
  String? termsURL,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'logo': logo,
      'email': email,
      'phone': phone,
      'address': address,
      'appleStoreURL': appleStoreURL,
      'playStoreURL': playStoreURL,
      'coverImage': coverImage,
      'company_bio': companyBio,
      'termsURL': termsURL,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
    }.withoutNulls,
  );

  return firestoreData;
}

class CompanyInformationRecordDocumentEquality
    implements Equality<CompanyInformationRecord> {
  const CompanyInformationRecordDocumentEquality();

  @override
  bool equals(CompanyInformationRecord? e1, CompanyInformationRecord? e2) {
    const listEquality = ListEquality();
    return e1?.name == e2?.name &&
        e1?.logo == e2?.logo &&
        e1?.email == e2?.email &&
        e1?.phone == e2?.phone &&
        e1?.address == e2?.address &&
        e1?.appleStoreURL == e2?.appleStoreURL &&
        e1?.playStoreURL == e2?.playStoreURL &&
        e1?.coverImage == e2?.coverImage &&
        e1?.companyBio == e2?.companyBio &&
        e1?.termsURL == e2?.termsURL &&
        listEquality.equals(e1?.chefInfo, e2?.chefInfo) &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber;
  }

  @override
  int hash(CompanyInformationRecord? e) => const ListEquality().hash([
        e?.name,
        e?.logo,
        e?.email,
        e?.phone,
        e?.address,
        e?.appleStoreURL,
        e?.playStoreURL,
        e?.coverImage,
        e?.companyBio,
        e?.termsURL,
        e?.chefInfo,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber
      ]);

  @override
  bool isValidKey(Object? o) => o is CompanyInformationRecord;
}
