import 'dart:io';
import 'package:event_planner_app/blocs/vendor/vendor_bloc.dart';
import 'package:event_planner_app/blocs/vendor/vendor_event.dart';
import 'package:event_planner_app/blocs/vendor/vendor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class VendorFormScreen extends StatefulWidget {
  const VendorFormScreen({super.key});

  @override
  State<VendorFormScreen> createState() => _VendorFormScreenState();
}

class _VendorFormScreenState extends State<VendorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'Venue';
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _extraField1Controller = TextEditingController();
  final _extraField2Controller = TextEditingController();

  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      BlocProvider.of<VendorBloc>(context).add(
        SubmitVendorForm(
          category: _category,
          name: _nameController.text.trim(),
          contact: _contactController.text.trim(),
          price: _priceController.text.trim(),
          quantity: _quantityController.text.trim(),
          extraField1: _extraField1Controller.text.trim(),
          extraField2: _extraField2Controller.text.trim(),
          imageFile: _imageFile!,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the form and select an image.')),
      );
    }
  }

  List<Widget> _buildDynamicFields() {
    switch (_category) {
      case 'Food':
        return [
          TextFormField(
            controller: _extraField1Controller,
            decoration: const InputDecoration(labelText: 'Cuisine Type'),
            validator: (value) => value!.isEmpty ? 'Enter cuisine type' : null,
          ),
          TextFormField(
            controller: _extraField2Controller,
            decoration: const InputDecoration(labelText: 'Menu Description'),
            validator: (value) => value!.isEmpty ? 'Enter menu description' : null,
          ),
        ];
      case 'Decor':
        return [
          TextFormField(
            controller: _extraField1Controller,
            decoration: const InputDecoration(labelText: 'Decor Style'),
            validator: (value) => value!.isEmpty ? 'Enter decor style' : null,
          ),
          TextFormField(
            controller: _extraField2Controller,
            decoration: const InputDecoration(labelText: 'Themes Offered'),
            validator: (value) => value!.isEmpty ? 'Enter themes offered' : null,
          ),
        ];
      case 'Venue':
      default:
        return [
          TextFormField(
            controller: _extraField1Controller,
            decoration: const InputDecoration(labelText: 'Venue Location'),
            validator: (value) => value!.isEmpty ? 'Enter venue location' : null,
          ),
          TextFormField(
            controller: _extraField2Controller,
            decoration: const InputDecoration(labelText: 'Capacity'),
            validator: (value) => value!.isEmpty ? 'Enter capacity' : null,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vendor Form")),
      body: BlocListener<VendorBloc, VendorState>(
        listener: (context, state) {
          if (state is VendorSubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Vendor info uploaded successfully")),
            );
            Navigator.pop(context);
          } else if (state is VendorSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                DropdownButtonFormField<String>(
                  value: _category,
                  items: ['Venue', 'Food', 'Decor']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _category = val!),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Vendor Name'),
                  validator: (value) => value!.isEmpty ? 'Enter name' : null,
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: 'Contact Info'),
                  validator: (value) => value!.isEmpty ? 'Enter contact' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  validator: (value) => value!.isEmpty ? 'Enter price' : null,
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  validator: (value) => value!.isEmpty ? 'Enter quantity' : null,
                ),
                // Dynamic fields based on category
                ..._buildDynamicFields(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo),
                      label: const Text("Gallery"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera),
                      label: const Text("Camera"),
                    ),
                  ],
                ),
                if (_imageFile != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.file(_imageFile!, height: 150),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
