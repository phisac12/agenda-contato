import 'dart:io';
import 'package:flutter/material.dart';
import '../helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  const ContactPage({required this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _userEdited = false;

  late Contact _editedContact;

  @override
  void initState() {
    super.initState();

    if(widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name!;
      _emailController.text = _editedContact.email!;
      _nameController.text = _editedContact.phone!;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(_editedContact.name ?? 'Novo contato'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _editedContact.img != null ?
                      FileImage(File(_editedContact.img!)) :
                      const AssetImage('images/isaac.jpg') as ImageProvider,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height:20,
            ),
            TextField(
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editedContact.name = text;
                });
              },
              controller: _nameController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                      borderSide: BorderSide(width: 2)
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Insira seu nome",
                  labelText: "Nome",
                  prefixIcon: Icon(Icons.person),
                  fillColor: Colors.white70),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (text) {
                _userEdited = true;
                _editedContact.email = text;
              },
              controller:_emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                      borderSide: BorderSide(width: 2)
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Insira seu e-mail",
                  labelText: "E-mail",
                  prefixIcon: Icon(Icons.email_rounded),
                  fillColor: Colors.white70),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (text) {
                _userEdited = true;
                _editedContact.phone = text;
              },
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                      borderSide: BorderSide(width: 2)
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Insira seu telefone",
                  labelText: "Telefone",
                  prefixIcon: Icon(Icons.local_phone_rounded),
                  fillColor: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
