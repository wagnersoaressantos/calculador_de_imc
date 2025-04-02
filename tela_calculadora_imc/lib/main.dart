import 'package:flutter/material.dart';
import 'package:tela_calculadora_imc/calcularIMC/calculador_de_imc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de IMC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 4, 238, 82),
        ),
      ),
      home: const MyHomePage(title: 'Calculadora de IMC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nomePessoa = TextEditingController();
  final TextEditingController _pesoPessoa = TextEditingController();
  final TextEditingController _alturaPessoa = TextEditingController();
  String _resultado = "";
  bool _exibirResultado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.cyan,
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // container da image
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    style: BorderStyle.solid,
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/image.png',
                      height: 75,
                      width: 75,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    style: BorderStyle.solid,
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _nomePessoa,
                      decoration: InputDecoration(hintText: 'Nome'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    style: BorderStyle.solid,
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _pesoPessoa,
                      decoration: InputDecoration(hintText: 'Peso (ex: 75)'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    style: BorderStyle.solid,
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _alturaPessoa,
                      decoration: InputDecoration(
                        hintText: 'Altura (m) ex 1.69',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              if (_exibirResultado)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  child: Text(
                    _resultado,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _resultado = CalculadorDeImc.calculadorDeImc(
                      double.tryParse(_pesoPessoa.text)!,
                      double.tryParse(_alturaPessoa.text)!,
                    );
                    _exibirResultado = true;
                  });
                },
                child: Text('Calcular'),
              ),
              SizedBox(height: 2),
              if (_exibirResultado)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _resultado = "";
                      _exibirResultado = false;
                    });
                  },
                  child: Text('Novo Calculo'),
                ),
            ],
          ),
        ),
      ),

      // body: Container(
      //   // padding: EdgeInsets.all(15),
      //   color: Colors.blue,
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         const Text('You have pushed the button this many times:'),
      //         Text(
      //           '$_counter',
      //           style: Theme.of(context).textTheme.headlineMedium,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
