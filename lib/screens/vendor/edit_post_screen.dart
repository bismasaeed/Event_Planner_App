import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_app/blocs/vendor/vendor_bloc.dart';
import 'package:event_app/blocs/vendor/vendor_event.dart';
import 'package:event_app/blocs/vendor/vendor_state.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;
  final String userId;

  const EditPostScreen({Key? key, required this.postId, required this.userId})
    : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _categoryController;
  late TextEditingController _businessNameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();
    _businessNameController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();

    // Load the post data
    _loadPostData();
  }

  // Load post data for editing
  Future<void> _loadPostData() async {
    final postDoc =
        await FirebaseFirestore.instance
            .collection('vendors')
            .doc(widget.userId)
            .collection('posts')
            .doc(widget.postId)
            .get();
    final postData = postDoc.data();
    if (postData != null) {
      _categoryController.text = postData['category'];
      _businessNameController.text = postData['business_name'] ?? '';
      _priceController.text = postData['price'] ?? '';
      _quantityController.text = postData['quantity'] ?? '';
    }
  }

  // Save the updated post to Firestore
  void _savePost() {
    if (_formKey.currentState!.validate()) {
      final updatedPost = {
        'category': _categoryController.text,
        'business_name': _businessNameController.text,
        'price': _priceController.text,
        'quantity': _quantityController.text,
      };

      FirebaseFirestore.instance
          .collection('vendors')
          .doc(widget.userId)
          .collection('posts')
          .doc(widget.postId)
          .update(updatedPost)
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post updated successfully')),
            );
            Navigator.pop(context);
          })
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update post: $error')),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator:
                    (value) => value!.isEmpty ? 'Category is required' : null,
              ),
              TextFormField(
                controller: _businessNameController,
                decoration: const InputDecoration(labelText: 'Business Name'),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Business name is required' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                validator:
                    (value) => value!.isEmpty ? 'Price is required' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator:
                    (value) => value!.isEmpty ? 'Quantity is required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePost,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
