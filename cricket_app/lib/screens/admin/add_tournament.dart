import 'package:cricket_app/widgets/admin/tournament.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cricket_app/backend_config/config.dart';

class AddTournamentScreen extends StatefulWidget {
  const AddTournamentScreen({super.key});
  @override
  State<AddTournamentScreen> createState() {
    return _AddTournamentScreen();
  }
}

class _AddTournamentScreen extends State<AddTournamentScreen> {
  final TextEditingController _dateControllerStart = TextEditingController();
  final TextEditingController _dateControllerEnd = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredVenue = '';
  var _enteredCountry = '';

  var _isSending = false;
  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      final url = Uri.parse(addTournamentUrl);
      await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": _enteredName,
          "organiser": _enteredCountry,
          "venue": _enteredVenue,
          "date_start": _dateControllerStart.text,
          "date_end": _dateControllerEnd.text,
        }),
      );

      if (!context.mounted) {
        return;
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success", style: TextStyle(color: Colors.green)),
            content: const Text("The addition was Successful", style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, const Tournament());
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _dateControllerStart.dispose();
    _dateControllerEnd.dispose();
    super.dispose();
  }

  Future<void> _selectedDate(int controllerIndex) async {
    // Pass controller index
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (controllerIndex == 0) {
          _dateControllerStart.text = picked.toString().split(" ")[0];
        } else {
          _dateControllerEnd.text = picked.toString().split(" ")[0];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Tournament"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Tournament Name"),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter valid characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 20,
                      decoration: const InputDecoration(
                        label: Text("Venue"),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter valid characters";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredVenue = value!;
                      },
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                      maxLength: 20,
                      decoration: const InputDecoration(
                        label: Text("Organising Country"),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter valid characters";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredCountry = value!;
                      },
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(
                          color: Color.fromARGB(255, 223, 210, 210)),
                      controller: _dateControllerStart,
                      decoration: InputDecoration(
                        labelText: "Starting Date",
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.calendar_month_rounded,
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                        ),
                      ),
                      readOnly: true,
                      onTap: () => _selectedDate(0),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(
                          color: Color.fromARGB(255, 223, 210, 210)),
                      controller: _dateControllerEnd,
                      decoration: InputDecoration(
                        labelText: "End Date",
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.calendar_month_rounded,
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                        ),
                      ),
                      readOnly: true,
                      onTap: () => _selectedDate(1),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSending
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                            _dateControllerStart.clear();
                            _dateControllerEnd.clear();
                          },
                    child: const Text("Reset"),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text("Add Tournament"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
