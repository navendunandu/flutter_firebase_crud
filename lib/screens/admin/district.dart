import 'package:flutter/material.dart';
import 'package:flutter_firebase/widgets/custom_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class District extends StatefulWidget {
  const District({super.key});

  @override
  State<District> createState() => _DistrictState();
}

class _DistrictState extends State<District> {
  TextEditingController _catController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String editId = '';

  final Stream<QuerySnapshot> _distStream =
      FirebaseFirestore.instance.collection('district').snapshots();

  void insertData() {
    try {
      final data = <String, dynamic>{'district': _catController.text.trim()};
      db
          .collection('district')
          .add(data)
          .then((DocumentReference doc) => Fluttertoast.showToast(
                msg: 'District Added Successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              ));
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

  void deleteItem(String documentId) {
    db
        .collection(
            'district') // Replace 'your_collection' with your actual collection name
        .doc(documentId)
        .delete()
        .then((_) {
      Fluttertoast.showToast(
        msg: 'Deleted',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      print("Document successfully deleted!");
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: 'Failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print("Error deleting document: $error");
    });
  }

  void editItem(String documentId, String item) {
    setState(() {
      _catController.text = item;
      editId = documentId;
    });
  }

  void updateItem() {
    Map<String, dynamic> newData = {'district': _catController.text};
    print(newData);
    try {
      db.collection('district').doc(editId).update(newData).then((_) {
        Fluttertoast.showToast(
          msg: 'Updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        print("Document successfully updated!");
      });
      editId = '';
      _catController.clear();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      editId = '';
      _catController.clear();
      print(e);
    }
  }

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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Administrator',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Text('Dashboard'),
                        Text(' > '),
                        Text('District'),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                        child: TextFormField(
                      controller: _catController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a District';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('District'),
                        hintText: 'Enter District Name',
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
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (editId == '') {
                              insertData();
                            } else {
                              updateItem();
                            }
                          }
                        },
                        child: Text('Submit')),
                    StreamBuilder<QuerySnapshot>(
                      stream: _distStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading");
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> data =
                                snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>;
                            final documentId = snapshot.data!.docs[index].id;
                            return ListTile(
                              leading: Text('${index + 1}'),
                              title: Text(data['district']),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          editItem(
                                              documentId, data['district']);
                                        },
                                        icon: Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () {
                                          deleteItem(documentId);
                                        },
                                        icon: Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),

          // ListView.builder(itemBuilder: itemBuilder)
        ],
      ),
    );
  }
}
