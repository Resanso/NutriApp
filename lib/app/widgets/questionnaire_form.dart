// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

// Widget form kuesioner untuk mengumpulkan data pengguna
class QuestionnaireForm extends StatefulWidget {
  // Callback function yang akan dipanggil saat form di-submit
  final Function(Map<String, dynamic>) onSubmit;

  const QuestionnaireForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<QuestionnaireForm> createState() => _QuestionnaireFormState();
}

class _QuestionnaireFormState extends State<QuestionnaireForm> {
  // Key untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // Data yang akan disimpan dari form
  final Map<String, dynamic> _formData = {
    'age': 0, // Umur dalam tahun
    'weight': 0.0, // Berat badan dalam kg
    'height': 0.0, // Tinggi badan dalam cm
    'gender': 'male', // Jenis kelamin
    'activityLevel': 'sedentary', // Tingkat aktivitas fisik
    'goal': 'maintain', // Target yang ingin dicapai
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Input field untuk umur
          TextFormField(
            decoration: const InputDecoration(labelText: 'Age (years)'),
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Required' : null,
            onSaved: (v) => _formData['age'] = int.parse(v!),
          ),

          // Input field untuk berat badan
          TextFormField(
            decoration: const InputDecoration(labelText: 'Weight (kg)'),
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Required' : null,
            onSaved: (v) => _formData['weight'] = double.parse(v!),
          ),

          // Input field untuk tinggi badan
          TextFormField(
            decoration: const InputDecoration(labelText: 'Height (cm)'),
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Required' : null,
            onSaved: (v) => _formData['height'] = double.parse(v!),
          ),

          // Dropdown untuk memilih jenis kelamin
          DropdownButtonFormField<String>(
            value: _formData['gender'],
            decoration: const InputDecoration(labelText: 'Gender'),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
            ],
            onChanged: (v) => setState(() => _formData['gender'] = v),
          ),

          // Dropdown untuk memilih tingkat aktivitas
          DropdownButtonFormField<String>(
            value: _formData['activityLevel'],
            decoration: const InputDecoration(labelText: 'Activity Level'),
            items: const [
              DropdownMenuItem(value: 'sedentary', child: Text('Sedentary')),
              DropdownMenuItem(value: 'light', child: Text('Light Exercise')),
              DropdownMenuItem(
                value: 'moderate',
                child: Text('Moderate Exercise'),
              ),
              DropdownMenuItem(value: 'active', child: Text('Very Active')),
            ],
            onChanged: (v) => setState(() => _formData['activityLevel'] = v),
          ),

          // Dropdown untuk memilih target
          DropdownButtonFormField<String>(
            value: _formData['goal'],
            decoration: const InputDecoration(labelText: 'Goal'),
            items: const [
              DropdownMenuItem(value: 'lose', child: Text('Lose Weight')),
              DropdownMenuItem(
                value: 'maintain',
                child: Text('Maintain Weight'),
              ),
              DropdownMenuItem(value: 'gain', child: Text('Gain Weight')),
            ],
            onChanged: (v) => setState(() => _formData['goal'] = v),
          ),
          const SizedBox(height: 20),

          // Tombol untuk menghitung hasil
          ElevatedButton(
            onPressed: () {
              // Validasi form sebelum menyimpan data
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSubmit(_formData); // Kirim data ke parent widget
              }
            },
            child: const Text('Calculate Daily Goals'),
          ),
        ],
      ),
    );
  }
}
