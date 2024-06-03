import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labtim_mobile/api/api.dart';
import 'package:labtim_mobile/model/userModel/patientModel.dart';

class AddPatient extends StatefulWidget {
  const AddPatient({super.key});

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  bool patient = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController tokenController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  // ignore: unnecessary_new

  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    telController.dispose();
    tokenController.dispose();
    keyController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        patient = true;
      });
      PatientModel newPatient = PatientModel(
        id_Patient:
            '', // You can set a unique ID for the patient here if needed
        nom: firstNameController.text,
        prenom: secondNameController.text,
        tel: int.parse(telController.text),
        token: tokenController.text,
        key: keyController.text,
      );

      var result = await Api.AddPatient(newPatient.toMap());

      if (result != null && result[0]) {
        setState(() {
          patient = true;
        });
        Navigator.of(context).pop();
      } else if (result != null && !result[0]) {
        setState(() {
          patient = false;
        });
      } else {
        setState(() {
          patient = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Patient"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // First Name TextField
                    TextFormField(
                      controller: firstNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter First Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Second Name TextField
                    TextFormField(
                      controller: secondNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Second Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Second Name',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tel TextField
                    TextFormField(
                      controller: telController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Tel';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Tel',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Token TextField
                    TextFormField(
                      controller: tokenController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Token';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Token',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Key TextField
                    TextFormField(
                      controller: keyController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Key';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Key',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: patient ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ), // Set button color here
                      ),
                      child: const Text(
                        'Add Patient',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
