class PremiumUser {
  int id;
  int silverUser;
  int goldUser;
  int diamondUser;

  PremiumUser({required this.silverUser, required this.goldUser, required this.diamondUser, required this.id});
  Map<String, dynamic> toMap() {
    return {'id': id, 'silverUser': silverUser, 'goldUser': goldUser, 'diamondUser': diamondUser};
  }
}
