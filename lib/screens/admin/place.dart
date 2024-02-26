import 'package:flutter/material.dart';
import 'package:flutter_firebase/widgets/custom_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Place extends StatefulWidget {
  const Place({super.key});

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  TextEditingController _catController = TextEditingController();
  late String _selectedCat = '';

  List<Map<String, dynamic>> distList = [];

  Future<void> fetchDistrict() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('district').get();

      List<Map<String, dynamic>> dept = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'district': doc['district'].toString(),
              })
          .toList();

      setState(() {
        distList = dept;
      });
    } catch (e) {
      print('Error fetching department data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDistrict();
  }

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Administrator',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const Row(
                    children: [
                      Text('Dashboard'),
                      Text(' > '),
                      Text('Place'),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                      child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedCat,
                        decoration: InputDecoration(
                          hintText: 'Select District',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          label: const Text('District'),
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
                        items: distList.map<DropdownMenuItem<String>>(
                          (Map<String, dynamic> district) {
                            return DropdownMenuItem<String>(
                              value: district[
                                  'district'], // Use district name as the value
                              child: Text(district['district']),
                            );
                          },
                        ).toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _catController,
                        decoration: InputDecoration(
                          label: const Text('Place'),
                          hintText: 'Enter Place Name',
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
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(onPressed: () {}, child: const Text('Submit')),
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
