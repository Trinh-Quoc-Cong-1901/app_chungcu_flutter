import 'package:flutter/material.dart';

class AddAdressScreen extends StatefulWidget {
  const AddAdressScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddAdressScreenState createState() => _AddAdressScreenState();
}

class _AddAdressScreenState extends State<AddAdressScreen> {
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedWard;

  List<String> provinces = [
    'Hà Nội',
    'Hồ Chí Minh',
    'Đà Nẵng'
  ]; // Danh sách tỉnh/thành phố
  Map<String, List<String>> districts = {
    'Hà Nội': ['Quận Hoàng Mai', 'Quận Thanh Xuân', 'Quận Cầu Giấy'],
    'Hồ Chí Minh': ['Quận 1', 'Quận 3', 'Quận 5'],
    'Đà Nẵng': ['Quận Hải Châu', 'Quận Sơn Trà', 'Quận Thanh Khê'],
  };
  Map<String, List<String>> wards = {
    'Quận Hoàng Mai': [
      'Phường Thanh Trì',
      'Phường Đại Kim',
      'Phường Hoàng Văn Thụ'
    ],
    'Quận Thanh Xuân': ['Phường Thanh Xuân Bắc', 'Phường Thanh Xuân Nam'],
    'Quận Cầu Giấy': ['Phường Dịch Vọng', 'Phường Yên Hòa'],
    // Thêm các phường cho các quận khác
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm địa chỉ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Tên',
                hintText: 'Tên người nhận hàng',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                hintText: 'Điền số điện thoại',
              ),
              keyboardType: TextInputType.phone,
            ),
            DropdownButtonFormField<String>(
              value: selectedProvince,
              items: provinces.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedProvince = newValue;
                  selectedDistrict = null; // Xóa giá trị khi tỉnh thay đổi
                  selectedWard = null; // Xóa giá trị khi tỉnh thay đổi
                });
              },
              decoration: const InputDecoration(
                labelText: 'Tỉnh/Thành phố',
              ),
            ),
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              items: selectedProvince != null
                  ? districts[selectedProvince]!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  : [],
              onChanged: (newValue) {
                setState(() {
                  selectedDistrict = newValue;
                  selectedWard = null; // Xóa giá trị khi quận thay đổi
                });
              },
              decoration: const InputDecoration(
                labelText: 'Quận/Huyện',
              ),
            ),
            DropdownButtonFormField<String>(
              value: selectedWard,
              items: selectedDistrict != null
                  ? wards[selectedDistrict]!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  : [],
              onChanged: (newValue) {
                setState(() {
                  selectedWard = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Phường/Xã',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Địa chỉ chi tiết',
                hintText:
                    'Nhập địa chỉ cụ thể (số phòng, số nhà, tên tòa nhà,...)',
              ),
            ),
            SwitchListTile(
              title: const Text('Đặt làm địa chỉ mặc định'),
              value: false,
              onChanged: (value) {
                // Xử lý logic khi bật/tắt
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Xử lý lưu địa chỉ
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                    double.infinity, 48), // Chiều rộng tối đa của nút
              ),
              child: const Text('Hoàn thành'),
            ),
          ],
        ),
      ),
    );
  }
}
