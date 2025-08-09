class ChiTieu {
  final String id;
  final double soTien;
  final String danhMuc;
  final DateTime ngay;

  ChiTieu({
    required this.id,
    required this.soTien,
    required this.danhMuc,
    required this.ngay,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'soTien': soTien,
        'danhMuc': danhMuc,
        'ngay': ngay.toIso8601String(),
      };

  factory ChiTieu.fromJson(Map<String, dynamic> json) => ChiTieu(
        id: json['id'],
        soTien: json['soTien'],
        danhMuc: json['danhMuc'],
        ngay: DateTime.parse(json['ngay']),
      );
}