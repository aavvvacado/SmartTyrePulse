import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_tyre_pulse/repositories/dumper_repository.dart';
import 'package:smart_tyre_pulse/screens/inventory_page.dart';

import '../models/dumper_model.dart';

class DumperListScreen1 extends StatefulWidget {
  @override
  _DumperListScreenState createState() => _DumperListScreenState();
}

class _DumperListScreenState extends State<DumperListScreen1> {
  final DumperRepository dumperRepository = DumperRepository();
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    final dumpers =
        dumperRepository.getDumpers(); // Get current list of dumpers

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Dumper'),
        backgroundColor: Colors.yellowAccent,
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 18,
            childAspectRatio: 0.8,
          ),
          itemCount: dumpers.length,
          itemBuilder: (context, index) {
            final dumper = dumpers[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InventoryScreen(
                      dumperName: dumper.name,
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.asset(
                          () {
                            String imagePath =
                                'assets/images/dumper_default.png'; // Default image path

                            // Set different images based on the dumper's name
                            if (dumper.name == 'Dumper A') {
                              imagePath = 'assets/images/dumper_1.png';
                            } else if (dumper.name == 'Dumper B') {
                              imagePath = 'assets/images/dumper_2.png';
                            } else if (dumper.name == 'Dumper C') {
                              imagePath = 'assets/images/dumper_3.png';
                            } else if (dumper.name == 'Dumper D') {
                              imagePath = 'assets/images/dumper_4.png';
                            }
                            return imagePath;
                          }(), // Immediately-invoked function to return the appropriate image path
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dumper.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Location: ${dumper.location}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Status: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                dumper.status,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(dumper.status),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () =>
                                    _showEditDumperDialog(context, dumper),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteDumper(dumper),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDumperDialog(context),
        backgroundColor: Colors.yellowAccent,
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  // Method to get the color based on the status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'idle':
        return Colors.yellow;
      case 'under care':
        return Colors.red;
      case 'operational':
        return Colors.green;
      default:
        return Colors.grey; // Default color if no match
    }
  }

  // Show a dialog to add a new dumper
  void _showAddDumperDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController statusController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Dumper'),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 10.0), // Added padding
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width * 0.8), // Limit width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Dumper Name',
                      suffixIcon: Icon(Icons.drive_file_rename_outline),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      suffixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: statusController,
                    decoration: InputDecoration(
                      labelText: 'Status',
                      suffixIcon: Icon(Icons.accessibility_new),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Upload Image:'),
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () => _pickImage(),
                      ),
                      _imageFile == null
                          ? Text('No image selected')
                          : Text('Image selected'),
                    ],
                  ),
                  SizedBox(height: 10),
                  _imageFile != null
                      ? Image.file(
                          File(_imageFile!.path),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newDumper = Dumper(
                  name: nameController.text,
                  location: locationController.text,
                  status: statusController.text,
                  imagePath: _imageFile?.path ??
                      'assets/images/dumper_1.png', // Default image if none selected
                  id: '', // Generate unique ID here if needed
                  operator: '',
                );
                // Add the new dumper to the repository and update UI
                setState(() {
                  dumperRepository.addDumper(newDumper);
                });
                Navigator.of(context).pop();
              },
              child: Text('Add Dumper'),
            ),
          ],
        );
      },
    );
  }

  // Show a dialog to edit a dumper
  void _showEditDumperDialog(BuildContext context, Dumper dumper) {
    final TextEditingController nameController =
        TextEditingController(text: dumper.name);
    final TextEditingController locationController =
        TextEditingController(text: dumper.location);
    final TextEditingController statusController =
        TextEditingController(text: dumper.status);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Dumper'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Dumper Name'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: statusController,
                  decoration: InputDecoration(labelText: 'Status'),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Upload Image:'),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () => _pickImage(),
                    ),
                    _imageFile == null
                        ? Text('No image selected')
                        : Text('Image selected'),
                  ],
                ),
                SizedBox(height: 10),
                _imageFile != null
                    ? Image.file(
                        File(_imageFile!.path),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Update dumper details
                  dumper.name = nameController.text;
                  dumper.location = locationController.text;
                  dumper.status = statusController.text;
                  dumper.imagePath = _imageFile?.path ?? dumper.imagePath;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  // Pick an image for the dumper
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  // Delete a dumper
  void _deleteDumper(Dumper dumper) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Dumper'),
          content: Text('Are you sure you want to delete this dumper?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  dumperRepository.deleteDumper(dumper);
                });
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
