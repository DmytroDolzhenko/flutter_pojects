import 'package:flutter/material.dart';
import '../utils/validators.dart';

class AddTaskForm extends StatefulWidget {
  final Function(String) onSubmit;

  const AddTaskForm({super.key, required this.onSubmit});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Task Title',
              hintText: 'Enter task title',
            ),
            validator: Validators.validateTitle,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}