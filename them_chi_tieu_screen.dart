import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'chi_tieu.dart';

class ThemChiTieuScreen extends StatefulWidget {
  @override
  _ThemChiTieuScreenState createState() => _ThemChiTieuScreenState();
}

class _ThemChiTieuScreenState extends State<ThemChiTieuScreen> {
  final _soTienController = TextEditingController();
  String _danhMuc = 'Thực phẩm';

  Future<void> _luuChiTieu(ChiTieu chiTieu) async {
    final prefs = await SharedPreferences.getInstance();
    final String? chuoiChiTieu = prefs.getString('chiTieu');
    List<ChiTieu> danhSachChiTieu = [];
    if (chuoiChiTieu != null) {
      final List<dynamic> json = jsonDecode(chuoiChiTieu);
      danhSachChiTieu = json.map((e) => ChiTieu.fromJson(e)).toList();
    }
    danhSachChiTieu.add(chiTieu);
    await prefs.setString(
        'chiTieu', jsonEncode(danhSachChiTieu.map((e) => e.toJson()).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm Chi Tiêu')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _soTienController,
              decoration: InputDecoration(labelText: 'Số tiền'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _danhMuc,
              items: ['Thực phẩm', 'Giao thông', 'Khác']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => _danhMuc = value!),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_soTienController.text.isNotEmpty) {
                  try {
                    final chiTieu = ChiTieu(
                      id: Uuid().v4(),
                      soTien: double.parse(_soTienController.text),
                      danhMuc: _danhMuc,
                      ngay: DateTime.now(),
                    );
                    _luuChiTieu(chiTieu);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã thêm chi tiêu')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Vui lòng nhập số hợp lệ')),
                    );
                  }
                }
              },
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
