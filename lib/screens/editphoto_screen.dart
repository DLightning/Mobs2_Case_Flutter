import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/photo_controller.dart';
import 'package:flutter_app/model/photo.dart';

class EditPhotoView extends StatefulWidget {
  final Photo photo;
  final String userId; // Adicione esta linha

  const EditPhotoView({Key? key, required this.photo, required this.userId})
      : super(key: key);

  @override
  _EditPhotoViewState createState() => _EditPhotoViewState();
}

class _EditPhotoViewState extends State<EditPhotoView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final PhotoController _photoController = PhotoController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.photo.name;
    descriptionController.text = widget.photo.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobs2 Case'),
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      File(widget.photo.imagePath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.cyan,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                        ),
                        onPressed: () {
                          widget.photo.name = nameController.text;
                          widget.photo.description = descriptionController.text;
                          _photoController.updatePhoto(
                              widget.photo, widget.userId);
                          Navigator.popUntil(
                              context, ModalRoute.withName('/home'));
                          Navigator.pushReplacementNamed(context, '/home');

                          setState(() {
                            isEditing = false;
                          });
                        },
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) async {
          if (index == 0) {
            Navigator.popUntil(context, ModalRoute.withName('/home'));
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Delete Photo'),
                  content:
                      const Text('Are you sure you want to delete this photo?'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await deletePhoto(widget.photo, widget.userId);
                        Navigator.popUntil(
                            context, ModalRoute.withName('/home'));
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            label: 'Delete',
          ),
        ],
      ),
    );
  }

  Future<void> deletePhoto(Photo photo, String userId) async {
    try {
      await _photoController.deletePhoto(photo.id, widget.userId);
      Navigator.popUntil(context, ModalRoute.withName('/home'));
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Error deleting photo: $e');
    }
  }
}
