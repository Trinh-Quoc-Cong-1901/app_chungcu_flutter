import 'package:flutter/material.dart';

class CustomSocialButton extends StatelessWidget {
  final Widget icon;
  // final Color iconColor;
  final String text;
  final VoidCallback onPressed;

  const CustomSocialButton({
    super.key,
    required this.icon,
    // required this.iconColor,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              // backgroundColor: iconColor,
              radius: 15,
              child: icon,
            ),

            SizedBox(width: screenWidth * 12 / 340),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: Color(0xFF000059),
              ),
            ),
            // Spacer này trong row hoặc colum nó sẽ chiếm không gian còn lại, và đẩy phần tử sau nó về phía sau cùng bên phải
            const Spacer(),
            const Icon(
              Icons.arrow_forward,
              color: Color(0xFF000059),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
