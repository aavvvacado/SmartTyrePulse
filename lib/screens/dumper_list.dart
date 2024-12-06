import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_tyre_pulse/repositories/dumper_repository.dart';
import 'package:smart_tyre_pulse/screens/tyre_list.dart';

import '../models/dumper_model.dart';

class DumperListScreen extends StatefulWidget {
  @override
  _DumperListScreenState createState() => _DumperListScreenState();
}

class _DumperListScreenState extends State<DumperListScreen> {
  final DumperRepository dumperRepository = DumperRepository();
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    final dumpers = dumperRepository.getDumpers(); // Dummy data retrieval

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Dumper'),
        backgroundColor: Colors.yellowAccent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.blue,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No new alerts!')),
              );
            },
          ),
        ],
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
            // Manually assign an image for each dumper
            String imagePath =
                'assets/images/dumper_default.png'; // Default image path

            // You can set different images manually here
            if (dumper.name == 'Dumper A') {
              imagePath = 'assets/images/dumper_1.png'; // Example for Dumper 1
            } else if (dumper.name == 'Dumper B') {
              imagePath = 'assets/images/dumper_2.png'; // Example for Dumper 2
            } else if (dumper.name == 'Dumper C') {
              imagePath = 'assets/images/dumper_3.png'; // Example for Dumper 3
            } else if (dumper.name == 'Dumper D') {
              imagePath = 'assets/images/dumper_4.png'; // Example for Dumper 3
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TyreListPage(dumperName: dumper.name),
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
                          imagePath, // Use the manually assigned image
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'idle':
        return Colors.yellow;
      case 'under care':
        return Colors.red;
      case 'operational':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showAddDumperDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController statusController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Dumper'),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width -
                        40), // Add a margin from the sides
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Dumper Name'),
                    ),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(labelText: 'Location'),
                    ),
                    TextField(
                      controller: statusController,
                      decoration: InputDecoration(labelText: 'Status'),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Upload Image:'),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () => _pickImage(),
                        ),
                        Flexible(
                          child: Text(
                            _imageFile == null
                                ? 'No image selected'
                                : 'Image selected',
                            overflow:
                                TextOverflow.ellipsis, // Prevent overflow text
                            maxLines: 1, // Limit to a single line
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                  imagePath: _imageFile?.path,
                  id: '',
                  operator: '',
                );
                dumperRepository.addDumper(newDumper);
                Navigator.of(context).pop();
              },
              child: Text('Add Dumper'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedImage;
    });
  }
}
