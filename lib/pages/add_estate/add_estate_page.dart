import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/providers/category_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:rental_estate_app/providers/estate_provider.dart';

import '../../models/estate.dart';


class AddEstatePage extends StatefulWidget {
  EstateProvider estateProvider;

  AddEstatePage({required this.estateProvider});

  @override
  _AddEstatePageState createState() => _AddEstatePageState();
}

class _AddEstatePageState extends State<AddEstatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedCategory;
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final Map<String, dynamic> _features = {
    'bedrooms': 1,
    'bathrooms': 1,
    'area': 0.0,
    'parking': false,
    'furnished': false,
  };

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')), //TODO loc
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Image'), //TODO loc
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'), //TODO loc
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'), //TODO loc
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required'; //TODO loc
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required'; //TODO loc
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number'; //TODO loc
    }
    if (double.parse(value) <= 0) {
      return 'Price must be greater than 0'; //TODO loc
    }
    return null;
  }

  String chooseImage(String? category){
    switch(category){
      case 'Home':
        return 'house1.jpg';
      case 'Office':
        return 'office1.jpg';
      case 'Apartment':
        return 'apartment1.jpg';
      case 'Villa':
      default:
        return 'villa1.jpg';
    }
  }

  void _submitForm() async{
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one image')), //TODO loc
      );
      return;
    }

    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final estateData = {
        'title': _titleController.text.trim(),
        'category': _selectedCategory,
        'address': _addressController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'features': {
          'bedrooms': _features['bedrooms'],
          'bathrooms': _features['bathrooms'],
        },
        'imageUrl': "https://cross-rentalestate.s3.us-east-1.amazonaws.com/${chooseImage(_selectedCategory)}",
        'postedDate': '2025-12-12T00:00:00.000',
        'views': 0
      };

      try{
        DocumentReference ref = await FirebaseFirestore.instance.collection('estates').add(estateData);

        debugPrint('New estate created with ID: ${ref.id}');

        widget.estateProvider.addEstate(Estate.fromFirestore(await ref.get()));

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Estate listing created successfully'), //TODO loc
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')), //TODO loc
        );
      }
    } else if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')), //TODO loc
      );
    }
  }

  Widget _buildImageList() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length + 1,
        itemBuilder: (context, index) {
          if (index == _selectedImages.length) {
            return Container(
              width: 100,
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.add_photo_alternate),
                onPressed: _showImagePickerDialog,
              ),
            );
          }

          return Stack(
            children: [
              Container(
                width: 100,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(_selectedImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 12,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Estate'), //TODO loc
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Images', //TODO loc
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              _buildImageList(),
              SizedBox(height: 24),

              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title', //TODO loc
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: _validateNotEmpty,
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category', //TODO loc
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: categoryProvider.categories.map((category) {
                  return DropdownMenuItem(
                    value: category.title,
                    child: Text(category.title),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address', //TODO loc
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: _validateNotEmpty,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price', //TODO loc
                  prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: _validatePrice,
              ),
              SizedBox(height: 24),

              Text(
                'Features', //TODO loc
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Bedrooms', //TODO loc
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _features['bedrooms'].toString(),
                      onChanged: (value) {
                        _features['bedrooms'] = int.tryParse(value) ?? 1;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Bathrooms', //TODO loc
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _features['bathrooms'].toString(),
                      onChanged: (value) {
                        _features['bathrooms'] = int.tryParse(value) ?? 1;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Area (sq ft)', //TODO loc
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                initialValue: _features['area'].toString(),
                onChanged: (value) {
                  _features['area'] = double.tryParse(value) ?? 0.0;
                },
              ),
              SizedBox(height: 16),

              SwitchListTile(
                title: Text('Parking Available'), //TODO loc
                value: _features['parking'],
                onChanged: (bool value) {
                  setState(() {
                    _features['parking'] = value;
                  });
                },
              ),

              SwitchListTile(
                title: Text('Furnished'), //TODO loc
                value: _features['furnished'],
                onChanged: (bool value) {
                  setState(() {
                    _features['furnished'] = value;
                  });
                },
              ),

              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Create Listing'), //TODO loc
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 