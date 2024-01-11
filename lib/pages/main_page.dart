//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:imcproject_hive/models/imc_model.dart';
import 'package:imcproject_hive/repositories/imc_repository.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late ImcRepository imcRepository;
  PageController controller = PageController(initialPage: 0);
  int posicaoPagina = 0;

  var pesoController = TextEditingController();
  var alturaController = TextEditingController();
  //double res = 0;
  //var classificacao;
  var _registros = const <ImcModel>[];
  //var _classificacao = const <ImcModel>[];
  @override
  void initState() {
    super.initState();
    obter();
  }

  void obter() async {
    imcRepository = await ImcRepository.carregar();
    _registros = imcRepository.obterDados();
    setState(() {});
  }

  double calcularIMC(double altura, double peso) {
    // O cálculo correto do IMC é peso / altura^2
    return peso / (altura * altura);
  }

  String classificarIMC(double imc) {
    if (imc < 18.5) {
      return "Abaixo do Peso";
    } else if (imc >= 18.5 && imc < 24.9) {
      return "Peso Normal";
    } else if (imc >= 25 && imc < 29.9) {
      return "Sobrepeso";
    } else if (imc >= 30 && imc < 34.9) {
      return "Obesidade Grau 1";
    } else if (imc >= 35 && imc < 39.9) {
      return "Obesidade Grau 2";
    } else {
      return "Obesidade Grau 3";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext bc) {
                  return AlertDialog(
                    title: const Text("Adicionar IMC"),
                    content: Wrap(
                      children: [
                        const Text("Altura em 0.00"),
                        TextField(
                          controller: alturaController,
                          keyboardType: TextInputType.number,
                        ),
                        const Text("Peso em quilos"),
                        TextField(
                          controller: pesoController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancelar")),
                      TextButton(
                          onPressed: () async {
                            try {
                              double altura =
                                  double.parse(alturaController.text);
                              double peso = double.parse(pesoController.text);
                              //double res = altura / peso * peso;
                              double imc = calcularIMC(altura, peso);
                              await imcRepository
                                  .salvar(ImcModel.criar(altura, peso, imc));
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                              obter();
                              setState(() {});
                            } catch (e) {
                              // Trate qualquer erro de conversão aqui, como valores inválidos.
                              debugPrint('Erro ao converter para Double: $e');
                            }
                          },
                          child: const Text("Salvar"))
                    ],
                  );
                });
          }),
      body: Container(
          color: Colors.red,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Card(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Lista de IMC:",
                          style:
                              TextStyle(fontSize: 28, color: Colors.blue[900]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _registros.length,
                    itemBuilder: (BuildContext bc, int index) {
                      var tarefa = _registros[index];
                      return Dismissible(
                        onDismissed: (DismissDirection dismissDirection) async {
                          imcRepository.excluir(tarefa);
                          obter();
                        },
                        key: Key(tarefa.toString() != ""
                            ? tarefa.toString()
                            : "Vazio"),
                        child: ListTile(
                          title: Column(
                            children: [
                              const Text("Peso:"),
                              Text(tarefa.peso.toString()),
                              const SizedBox(
                                width: 50,
                              ),
                              const Text("Altura:"),
                              Text(tarefa.altura.toStringAsFixed(1)),
                              const SizedBox(
                                width: 50,
                              ),
                              const Text("IMC:"),
                              Text(tarefa.classificacao.toStringAsFixed(2)),
                              const SizedBox(
                                width: 50,
                              ),
                              const Text("Classificação:"),
                              Text(classificarIMC(tarefa.classificacao)
                                  .toString())
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          )),
    );
  }
}
