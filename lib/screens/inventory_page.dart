import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class InventoryScreen extends StatefulWidget {
  final String dumperName;
  InventoryScreen({required this.dumperName});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final CollectionReference inventoryRecords =
      FirebaseFirestore.instance.collection('inventory_records');
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController tyreIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController dealerNameController = TextEditingController();
  final TextEditingController tkphController = TextEditingController();
  final TextEditingController psiController = TextEditingController();
  final TextEditingController workingHoursController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController terrainTypeController = TextEditingController();
  final TextEditingController manufactureDateController =
      TextEditingController();
  final TextEditingController buyingDateController = TextEditingController();

  File? photo;

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        photo = File(pickedFile.path);
      });
    }
  }

  Future<void> _addOrEditInventory({DocumentSnapshot? document}) async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'tyreId': tyreIdController.text,
        'name': nameController.text,
        'manufacturer': manufacturerController.text,
        'dealerName': dealerNameController.text,
        'manufactureDate': manufactureDateController.text,
        'buyingDate': buyingDateController.text,
        'tkph': tkphController.text,
        'psi': psiController.text,
        'workingHours': workingHoursController.text,
        'size': sizeController.text,
        'type': typeController.text,
        'terrainType': terrainTypeController.text,
        'photo': photo?.path ?? '',
        'dumperName': widget.dumperName,
      };

      if (document != null) {
        await document.reference.update(data);
      } else {
        await inventoryRecords.add(data);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _downloadInventoryData() async {
    try {
      // Fetch inventory data from Firestore
      final snapshot = await inventoryRecords
          .where('dumperName', isEqualTo: widget.dumperName)
          .get();

      // Extract data into List<List<dynamic>>
      List<List<dynamic>> csvData = [
        [
          "Tyre ID",
          "Name",
          "Manufacturer",
          "Dealer",
          "Manufacture Date",
          "Buying Date",
          "TKPH",
          "PSI",
          "Working Hours",
          "Size",
          "Type",
          "Terrain Type"
        ]
      ];
      for (var doc in snapshot.docs) {
        csvData.add([
          doc['tyreId'],
          doc['name'],
          doc['manufacturer'],
          doc['dealerName'],
          doc['manufactureDate'],
          doc['buyingDate'],
          doc['tkph'],
          doc['psi'],
          doc['workingHours'],
          doc['size'],
          doc['type'],
          doc['terrainType'],
        ]);
      }

      // Convert to CSV format
      String csv = const ListToCsvConverter().convert(csvData);

      // Save to local file
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/inventory_data_${widget.dumperName}.csv';
      final file = File(path);
      await file.writeAsString(csv);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Downloaded inventory data to $path'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openForm({DocumentSnapshot? document}) {
    if (document != null) {
      tyreIdController.text = document['tyreId'];
      nameController.text = document['name'];
      manufacturerController.text = document['manufacturer'];
      dealerNameController.text = document['dealerName'];
      manufactureDateController.text = document['manufactureDate'];
      buyingDateController.text = document['buyingDate'];
      tkphController.text = document['tkph'];
      psiController.text = document['psi'];
      workingHoursController.text = document['workingHours'];
      sizeController.text = document['size'];
      typeController.text = document['type'];
      terrainTypeController.text = document['terrainType'];
    } else {
      tyreIdController.clear();
      nameController.clear();
      manufacturerController.clear();
      dealerNameController.clear();
      manufactureDateController.clear();
      buyingDateController.clear();
      tkphController.clear();
      psiController.clear();
      workingHoursController.clear();
      sizeController.clear();
      typeController.clear();
      terrainTypeController.clear();
      photo = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(document == null ? 'Add Inventory' : 'Edit Inventory'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(tyreIdController, 'Tyre ID', Icons.tag),
                  _buildTextField(nameController, 'Tyre Name',
                      Icons.drive_file_rename_outline),
                  _buildTextField(
                      manufacturerController, 'Manufacturer', Icons.factory),
                  _buildTextField(
                      dealerNameController, 'Dealer Name', Icons.store),
                  _buildTextField(manufactureDateController, 'Manufacture Date',
                      Icons.calendar_today),
                  _buildTextField(
                      buyingDateController, 'Buying Date', Icons.date_range),
                  _buildTextField(tkphController, 'TKPH Value', Icons.speed),
                  _buildTextField(psiController, 'PSI', Icons.compress),
                  _buildTextField(
                      workingHoursController, 'Working Hours', Icons.timer),
                  _buildTextField(sizeController, 'Size', Icons.aspect_ratio),
                  _buildTextField(typeController, 'Type', Icons.category),
                  _buildTextField(
                      terrainTypeController, 'Terrain Type', Icons.terrain),
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: _pickPhoto, child: Text('Pick Photo')),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () => _addOrEditInventory(document: document),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          return null;
        },
      ),
    );
  }

  Widget _buildLogCard(DocumentSnapshot document) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (document['photo'] != null && document['photo'].isNotEmpty)
              Image.file(
                File(document['photo']),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 12.0),
            _buildLogDetailRow('Tyre ID', document['tyreId'], Icons.tag),
            _buildLogDetailRow(
                'Name', document['name'], Icons.drive_file_rename_outline),
            _buildLogDetailRow(
                'Manufacturer', document['manufacturer'], Icons.factory),
            _buildLogDetailRow('Dealer', document['dealerName'], Icons.store),
            _buildLogDetailRow('Manufacture Date', document['manufactureDate'],
                Icons.calendar_today),
            _buildLogDetailRow(
                'Buying Date', document['buyingDate'], Icons.date_range),
            _buildLogDetailRow('TKPH', document['tkph'], Icons.speed),
            _buildLogDetailRow('PSI', document['psi'], Icons.compress),
            _buildLogDetailRow(
                'Working Hours', document['workingHours'], Icons.timer),
            _buildLogDetailRow('Size', document['size'], Icons.aspect_ratio),
            _buildLogDetailRow('Type', document['type'], Icons.category),
            _buildLogDetailRow(
                'Terrain Type', document['terrainType'], Icons.terrain),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _openForm(document: document),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await document.reference.delete();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(width: 10),
          Text(
            '$label: $value',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
        actions: [
          IconButton(
            icon: Icon(Icons.download_for_offline),
            onPressed: _downloadInventoryData,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: inventoryRecords
            .where('dumperName', isEqualTo: widget.dumperName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final logs = snapshot.data!.docs;

          return ListView(
            children: logs.map((doc) => _buildLogCard(doc)).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
