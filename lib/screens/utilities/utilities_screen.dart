import 'package:ecogreen_city/screens/utilities/detail_utilities_screen.dart';
import 'package:flutter/material.dart';

class UtilitiesScreen extends StatefulWidget {
  @override
  State<UtilitiesScreen> createState() => _UtilitiesScreenState();
}

class _UtilitiesScreenState extends State<UtilitiesScreen> {
  var _selectedIndex = 0;
  final List<Map<String, dynamic>> utilities = [
    {
      'title': 'Rạng Đông',
      'address':
          'Số 87-89, phố Hạ Đình, Thanh Xuân Trung, Quận Thanh Xuân, Hà Nội',
      'icon': Icons.store,
      'color': Colors.green,
    },
    {
      'title': 'Máy lọc nước Kasama',
      'address': 'Số 164 Nam Đường Q. Long Biên, TP Hà Nội',
      'icon': Icons.water_damage,
      'color': Colors.blue,
    },
    {
      'title': 'U ULTTY Việt Nam',
      'address': 'Số 11 Nguyễn Xiển, Thanh Xuân, Hà Nội',
      'icon': Icons.cleaning_services,
      'color': Colors.orange,
    },
    {
      'title': 'Pate Ông Tây',
      'address': 'Số 40 liên kề 11b2 KĐT Mỗ Lao, Hà Đông, Hà Nội',
      'icon': Icons.fastfood,
      'color': Colors.red,
    },
  ];
  String searchQuery = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index != 1) {
      // Index 1 is UtilitiesScreen, so no need to navigate to itself
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => getScreenForIndex(index)),
      );
    }
  }

  Widget getScreenForIndex(int index) {
    // Implement navigation logic here, e.g., return different screens based on index
    return UtilitiesScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
          decoration: InputDecoration(
            hintText: 'Tìm kiếm cửa hàng',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
          itemCount: utilities
              .where((utility) =>
                  utility['title'].toLowerCase().contains(searchQuery))
              .length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.brown,
            thickness: 1.0,
          ),
          itemBuilder: (context, index) {
            final utility = utilities
                .where((utility) =>
                    utility['title'].toLowerCase().contains(searchQuery))
                .elementAt(index);
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailUtilities(
                        // title: utility['title'],
                        // address: utility['address'],
                        ),
                  ),
                );
              },
              child: ListTile(
                leading: Icon(utility['icon'], color: utility['color']),
                title: Text(utility['title']),
                subtitle: Text(utility['address']),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Nhà của tôi'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Tiện ích'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }
}
