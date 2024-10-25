import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VisualSearchRecord extends FirestoreRecord {
  VisualSearchRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  void _initializeFields() {
    _image = snapshotData['image'] as String?;
    _name = snapshotData['name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('visualSearch');

  static Stream<VisualSearchRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => VisualSearchRecord.fromSnapshot(s));

  static Future<VisualSearchRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => VisualSearchRecord.fromSnapshot(s));

  static VisualSearchRecord fromSnapshot(DocumentSnapshot snapshot) =>
      VisualSearchRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static VisualSearchRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      VisualSearchRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'VisualSearchRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is VisualSearchRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createVisualSearchRecordData({
  String? image,
  String? name,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'image': image,
      'name': name,
    }.withoutNulls,
  );

  return firestoreData;
}

class VisualSearchRecordDocumentEquality
    implements Equality<VisualSearchRecord> {
  const VisualSearchRecordDocumentEquality();

  @override
  bool equals(VisualSearchRecord? e1, VisualSearchRecord? e2) {
    return e1?.image == e2?.image && e1?.name == e2?.name;
  }

  @override
  int hash(VisualSearchRecord? e) =>
      const ListEquality().hash([e?.image, e?.name]);

  @override
  bool isValidKey(Object? o) => o is VisualSearchRecord;
}
