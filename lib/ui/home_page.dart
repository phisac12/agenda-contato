import 'dart:io';
import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: <Widget> [
          PopupMenuButton <OrderOptions> (
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                    child: Text('Ordernar de A-Z'),
                  value: OrderOptions.orderaz,
                ),
                const PopupMenuItem<OrderOptions>(
                  child: Text('Ordernar de Z-A'),
                  value: OrderOptions.orderza,
                )
              ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return Card(
      child: InkWell(
        onTap: () {
          _showOptions(context, index);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null
                          ? FileImage(File(contacts[index].img!))
                          : const AssetImage('images/isaac.jpg') as ImageProvider),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? '',
                      style: const TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email ?? '',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      contacts[index].phone ?? '',
                      style: const TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            builder: (context) {
              return WillPopScope(
                onWillPop: null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _actionButtons('Ligar', () {
                        launch('tel:${contacts[index].phone}');
                        Navigator.pop(context);
                      }),
                      _actionButtons('Editar', () {
                        Navigator.pop(context);
                        _showContactPage(contact: contacts[index]);
                      }),
                      _actionButtons('Excluir', () {
                        Navigator.pop(context);
                        _deleteContact(index);
                      }),
                    ],
                  ),
                ),
              );
            },
            onClosing: () {},
          );
        });
  }

  _deleteContact(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Descartar alterações?'),
            content: Text("Se confirmar o contato \'${contacts[index].name}'\ será excluído"),
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
                  helper.deleteContact(contacts[index].id!);
                  contacts.removeAt(index);
                  _getAllContacts();
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void _showContactPage({dynamic contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  Widget _actionButtons(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.redAccent, fontSize: 20),
        ),
      ),
    );
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch(result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b){
         return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((b, a){
         return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }
}
