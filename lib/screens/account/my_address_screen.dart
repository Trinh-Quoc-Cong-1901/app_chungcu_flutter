import 'package:ecogreen_city/screens/account/add_adress_screen.dart';
import 'package:flutter/material.dart';

class MyAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Địa chỉ của tôi'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAdressScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          AddressCard(
            name: 'Trịnh Quốc Công',
            phone: '0392921501',
            addressLine1: '286 Nguyễn Xiển',
            addressLine2:
                'Thành phố Hà Nội • Quận Hoàng Mai • Phường Thanh Trì',
          ),
          AddressCard(
            name: 'Trịnh Như Quỳnh',
            phone: '0971793348',
            addressLine1: 'Nguyễn Xiển, Thanh Xuân, Hà Nội',
            addressLine2: 'Thành phố Hà Nội • Quận Hoàng Mai • Phường Đại Kim',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyAddressScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final String name;
  final String phone;
  final String addressLine1;
  final String addressLine2;

  AddressCard({
    required this.name,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(phone),
            Text(addressLine1),
            Text(addressLine2),
          ],
        ),
        trailing: Icon(Icons.edit),
        onTap: () {
          // Chỉnh sửa địa chỉ
        },
      ),
    );
  }
}
