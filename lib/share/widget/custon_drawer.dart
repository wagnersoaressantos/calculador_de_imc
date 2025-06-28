import 'package:calculadora_imc/page/configuracoes_page.dart';
import 'package:flutter/material.dart';

class CustonDrawer extends StatelessWidget {
  const CustonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Wrap(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        title: Text("Camera"),
                        leading: Icon(Icons.camera_alt),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        title: Text("Galeria"),
                        leading: Icon(Icons.photo),
                      ),
                    ],
                  );
                },
              );
            },
            child: UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(235, 48, 235, 1),
                // borderRadius: BorderRadius.circular(10),
              ),
              accountName: Text('Wagner Soares'),
              accountEmail: Text('email@email.com'),
            ),
          ),
          InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 5),
                  Text('Configurações'),
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfiguracoesPage()),
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
