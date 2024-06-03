class PatientModel {
  String id_Patient;
  String nom;
  String prenom;
  int tel;
  String token;
  String key;
  PatientModel(
      {required this.id_Patient,
      required this.nom,
      required this.prenom,
      required this.tel,
      required this.token,
      required this.key});

  factory PatientModel.fromJson(Map<dynamic, dynamic> j) {
    return PatientModel(
        id_Patient: j['id_Patient'],
        nom: j['nom'],
        prenom: j['prenom'],
        tel: int.tryParse(j['tel'] ?? '') ?? 0, // Parse 'tel' as integer
        token: j['token'],
        key: j['_key']);
  }
  Map toMap() {
    return {
      "id_Patient": id_Patient,
      "nom": nom,
      "prenom": prenom,
      "tel": tel,
      "token": nom,
      "_key": key,
    };
  }
}
