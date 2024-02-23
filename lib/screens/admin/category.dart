import 'package:flutter/material.dart';
import 'package:flutter_firebase/widgets/custom_scaffold.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  TextEditingController _catController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          SizedBox(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Administrator',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Text('Dashboard'),
                      Text(' > '),
                      Text('Category'),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                      child: TextFormField(
                    controller: _catController,
                    decoration: InputDecoration(
                      label: const Text('Category'),
                      hintText: 'Enter Category Name',
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(onPressed: () {}, child: Text('Submit')),
                ],
              ),
            ),
          ),
          // ListView.builder(itemBuilder: itemBuilder)
        ],
      ),
    );
  }
}
