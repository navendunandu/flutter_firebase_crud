import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/admin/category.dart';
import 'package:flutter_firebase/screens/admin/subcategory.dart';
import 'package:flutter_firebase/widgets/custom_scaffold.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: ListView(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Category(),
                            ));
                      },
                      child: const Box(text: 'Category')),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SubCategory(),
                            ));
                      },
                      child: const Box(text: 'Sub Category'))
                ],
              ),
            )),
      ],
    ));
  }
}

class Box extends StatefulWidget {
  final String text;
  const Box({super.key, required this.text});

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue[800], borderRadius: BorderRadius.circular(10)),
      height: 150,
      child: Center(
        child: Text(
          widget.text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5),
        ),
      ),
    );
  }
}
