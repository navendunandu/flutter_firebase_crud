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
  final _formKey = GlobalKey<FormState>();
  String? _selectedCat;

  List<Map<String, dynamic>> distList = [];
  List<Map<String, dynamic>> placeData = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> fetchDistrict() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await db.collection('district').get();

      List<Map<String, dynamic>> dist = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'district': doc['district'].toString(),
              })
          .toList();
      setState(() {
        distList = dist;
      });
    } catch (e) {
      print('Error fetching department data: $e');
    }
  }

  void insertData() {
    try {
      final data = <String, dynamic>{
        'place': _catController.text.trim(),
        'district': _selectedCat
      };
      db
          .collection('place')
          .add(data)
          .then((DocumentReference doc) => Fluttertoast.showToast(
                msg: 'Place Added Successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              ));
      fetchData();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await db.collection('place').get();

      List<Map<String, dynamic>> place = [];

      for (var doc in querySnapshot.docs) {
        try {
          String? district = await getDistrict(doc['district']); // Await here
          // print(district);
          place.add({
            'id': doc.id,
            'place': doc['place'].toString(),
            'district': district,
          });
        } catch (e) {
          print('Error fetching district for place ${doc.id}: $e');
          // Handle the error gracefully, e.g., add a default value or log the error.
        }
      }
      setState(() {
        placeData = place;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<String?> getDistrict(String collectionId) async {
    try {
      // Get the district document using the collection ID
      final docSnapshot =
          await db.collection('district').doc(collectionId).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Extract the district value
        final districtValue = docSnapshot.data()!['district'];
        // print(districtValue);
        return districtValue;
      } else {
        return null; // Return null if the document doesn't exist
      }
    } catch (error) {
      // Handle potential errors
      print("Error fetching district value: $error");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDistrict();
    fetchData();
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
                          (Map<String, dynamic> dist) {
                            return DropdownMenuItem<String>(
                              value: dist['id'], // Use document ID as the value
                              child: Text(dist['district']),
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
                  ElevatedButton(
                      onPressed: () {
                        insertData();
                      },
                      child: const Text('Submit')),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: placeData.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> data =
                          placeData[index] as Map<String, dynamic>;
                      return ListTile(
                        leading: Text('${index + 1}'),
                        title: Text(data['place']),
                        subtitle: Text(data['district']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    // editItem(
                                    //     documentId, data['district']);
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    // deleteItem(documentId);
                                  },
                                  icon: Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
