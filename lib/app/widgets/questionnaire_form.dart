import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionnaireForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const QuestionnaireForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<QuestionnaireForm> createState() => _QuestionnaireFormState();
}

class _QuestionnaireFormState extends State<QuestionnaireForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'age': 0,
    'weight': 0.0,
    'height': 0.0,
    'gender': 'male',
    'activityLevel': 'sedentary',
    'goal': 'maintain',
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Age (years)'),
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Required' : null,
            onSaved: (v) => _formData['age'] = int.parse(v!),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Weight (kg)'),
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Required' : null,
            onSaved: (v) => _formData['weight'] = double.parse(v!),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Height (cm)'),
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Required' : null,
            onSaved: (v) => _formData['height'] = double.parse(v!),
          ),
          DropdownButtonFormField<String>(
            value: _formData['gender'],
            decoration: const InputDecoration(labelText: 'Gender'),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
            ],
            onChanged: (v) => setState(() => _formData['gender'] = v),
          ),
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
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSubmit(_formData);
              }
            },
            child: const Text('Calculate Daily Goals'),
          ),
        ],
      ),
    );
  }
}
