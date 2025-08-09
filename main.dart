import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'chi_tieu.dart';
import 'them_chi_tieu_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý Chi tiêu',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: DanhSachChiTieuScreen(),
      routes: {
        '/themChiTieu': (context) => ThemChiTieuScreen(),
      },
    );
  }
}

class DanhSachChiTieuScreen extends StatefulWidget {
  @override
  _DanhSachChiTieuScreenState createState() => _DanhSachChiTieuScreenState();
}

class _DanhSachChiTieuScreenState extends State<DanhSachChiTieuScreen> {
  List<ChiTieu> danhSachChiTieu = [];
  final _formatTien = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void initState() {
    super.initState();
    _taiDanhSachChiTieu();
  }

  Future<void> _taiDanhSachChiTieu() async {
    final prefs = await SharedPreferences.getInstance();
    final String? chuoiChiTieu = prefs.getString('chiTieu');
    if (chuoiChiTieu != null) {
      final List<dynamic> json = jsonDecode(chuoiChiTieu);
      setState(() {
        danhSachChiTieu = json.map((e) => ChiTieu.fromJson(e)).toList();
      });
    }
  }

  Future<void> _xoaChiTieu(String id) async {
    setState(() {
      danhSachChiTieu.removeWhere((chiTieu) => chiTieu.id == id);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'chiTieu', jsonEncode(danhSachChiTieu.map((e) => e.toJson()).toList()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xóa chi tiêu')),
    );
  }

  void _hienThiXacNhanXoa(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Xác nhận'),
        content: Text('Bạn có chắc muốn xóa chi tiêu này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              _xoaChiTieu(id);
              Navigator.pop(context);
            },
            child: Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý Chi tiêu'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: danhSachChiTieu.isEmpty
            ? Center(
                child: Text(
                  'Chưa có chi tiêu nào',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: danhSachChiTieu.length,
                itemBuilder: (context, index) {
                  final chiTieu = danhSachChiTieu[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      leading: Icon(Icons.money_off, color: Colors.teal),
                      title: Text(
                        _formatTien.format(chiTieu.soTien),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${chiTieu.danhMuc} - ${DateFormat('dd/MM/yyyy').format(chiTieu.ngay)}',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _hienThiXacNhanXoa(context, chiTieu.id),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/themChiTieu');
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}
