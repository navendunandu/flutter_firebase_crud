import 'package:flutter/material.dart';
import 'package:flutter_firebase/widgets/custom_scaffold.dart';

class SubCategory extends StatefulWidget {
  const SubCategory({super.key});

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  TextEditingController _catController = TextEditingController();
  late String _selectedCat = '';

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
                      Text('Sub Category'),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                      child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                          value: _selectedCat,
                          decoration: InputDecoration(
                            hintText: 'Select Department',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            label: const Text('Category'),
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
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCat = newValue!;
                            });
                          },
                          isExpanded: true,
                          items: List.empty()
                          // deptList.map<DropdownMenuItem<String>>(
                          //   (Map<String, dynamic> department) {
                          //     return DropdownMenuItem<String>(
                          //       value: department[
                          //           'id'], // Use document ID as the value
                          //       child: Text(department['name']),
                          //     );
                          //   },
                          // ).toList(),
                          ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _catController,
                        decoration: InputDecoration(
                          label: const Text('Sub-Category'),
                          hintText: 'Enter Sub-Category Name',
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
                      ),
                    ],
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
