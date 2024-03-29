import 'dart:io';
import 'package:flutter/material.dart';
import '../helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  final _nameFocus = FocusNode();

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
      _phoneController.text = _editedContact.phone!;

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text(_editedContact.name ?? 'Novo contato'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if(_editedContact.name != null && _editedContact.name!.isNotEmpty) {
                Navigator.pop(context, _editedContact);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            child: const Icon(Icons.save),
            backgroundColor: Colors.green,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
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
                        fit: BoxFit.cover
                      ),
                    ),
                  ),
                  onTap: () {
                    ImagePicker().pickImage(source: ImageSource.camera).then((file){
                      if(file == null) return;
                      setState(() {
                        _editedContact.img = file.path;
                      });
                    });
                  },
                ),
                const SizedBox(
                  height:20,
                ),
                buildTextField('Insira um Nome', 'Nome', Icons.person, TextInputType.text, _nameController, 'name'),
                const Divider(),
                buildTextField('Insira um e-mail', 'E-mail', Icons.email_rounded, TextInputType.emailAddress, _emailController, 'email'),
                const Divider(),
                buildTextField('Insira um telefone', 'Telefone', Icons.local_phone_rounded, TextInputType.phone, _phoneController, 'phone'),
              ],
            ),
          ),
        ),
    );
  }

  Widget buildTextField(String placeholder, String label, IconData icon, TextInputType inputType, TextEditingController c, contactEdited) {
    return TextField(
      onChanged: (text) {
        _userEdited = true;
        if (contactEdited == 'phone') {
          _editedContact.phone = text;
        } else if(contactEdited == 'email') {
          _editedContact.email = text;
        } else if (contactEdited == 'name') {
          setState(() {
            _editedContact.name = text;
          });
        }
      },
      controller: c,
      keyboardType: inputType,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
              borderSide: BorderSide(width: 2)
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          hintText: placeholder,
          labelText: label,
          prefixIcon: Icon(icon),
          fillColor: Colors.white70),
    );
  }

  Future<bool> _requestPop() {
    if(_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Descartar alterações?'),
            content: const Text('Se sair as alterações serão perdidas'),
            actions: <Widget>[
              TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
              ),
              TextButton(
                child: const Text('Sim'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
