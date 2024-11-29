class GiziProduk {
  String title;
  String imageUrl;
  double kalori;
  String satuanKalori; 
  double karbohidrat;
  String satuanKarbohidrat;
  double protein;
  String satuanProtein;
  double lemak;
  String satuanLemak;
  double gula;
  String satuanGula;
  double garam;
  String satuanGaram;

  GiziProduk({
    required this.title,
    required this.imageUrl,
    required this.kalori,
    this.satuanKalori = "kkal",
    required this.karbohidrat,
    this.satuanKarbohidrat = "g",
    required this.protein,
    this.satuanProtein = "g",
    required this.lemak,
    this.satuanLemak = "g",
    required this.gula,
    this.satuanGula = "g",
    required this.garam,
    this.satuanGaram = "mg",
  });
}
