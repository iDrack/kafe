class   AppUser {
  final String uuid;
  final String email;
  String name;
  int deevee = 0;
  int goldenSeed = 0;

  AppUser({required this.uuid, required this.name, required this.email, required this.deevee, required this.goldenSeed});

  Map<String, dynamic> toDocument() {
    return {
      'name': this.name,
      'email': this.email,
      'uuid': this.uuid,
      'deevee': this.deevee,
      'goldenSeed': this.goldenSeed,
    };
  }

  factory AppUser.fromSnapshot(Map<String, dynamic>? snapshot, String uuid) {
    return AppUser(
        name: snapshot?["name"],
        email: snapshot?["email"],
        uuid: uuid,
        deevee: snapshot?["deevee"],
        goldenSeed: snapshot?["goldenSeed"]
    );
  }
}