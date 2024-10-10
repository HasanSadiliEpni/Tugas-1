import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

// Root of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 41, 95, 176)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Kontak'),
    );
  }
}

// Home Page combining counter and contact list
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 

  // Contact list variables
  List<Contact> _contacts = [];


  // Add contact function
  void _addContact(Contact contact) {
    setState(() {
      _contacts.add(contact);
    });
  }

  // Delete contact function
  void _deleteContact(String id) {
    setState(() {
      _contacts.removeWhere((contact) => contact.id == id);
    });
  }

  // Navigate to add contact form
  void _navigateToAddContact() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ContactFormScreen(onSubmit: _addContact),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Divider(),
          Expanded(
            child: _contacts.isEmpty
                ? const Center(child: Text('Tidak ada kontak.'))
                : ListView.builder(
                    itemCount: _contacts.length,
                    itemBuilder: (ctx, index) => ContactItem(
                      contact: _contacts[index],
                      onDelete: _deleteContact,
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _navigateToAddContact,
            tooltip: 'Add Contact',
            child: const Icon(Icons.contact_page),
          ),
        ],
      ),
    );
  }
}

// Contact Model
class Contact {
  String id;
  String name;
  String phoneNumber;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });
}

// Contact Form Screen to add new contact
class ContactFormScreen extends StatefulWidget {
  final Function(Contact) onSubmit;

  ContactFormScreen({required this.onSubmit});

  @override
  _ContactFormScreenState createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newContact = Contact(
        id: Uuid().v4(),
        name: _nameController.text,
        phoneNumber: _phoneController.text,
      );
      widget.onSubmit(newContact);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Contact')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for displaying each contact item
class ContactItem extends StatelessWidget {
  final Contact contact;
  final Function(String) onDelete;

  ContactItem({
    required this.contact,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.name),
      subtitle: Text(contact.phoneNumber),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => onDelete(contact.id),
      ),
    );
  }
}
