import 'package:flutter/material.dart';
import 'package:imcproject_hive/models/imc_model.dart';
import 'package:imcproject_hive/repositories/imc_repository.dart';

class ConsultaPage extends StatefulWidget {
  const ConsultaPage({super.key});

  @override
  State<ConsultaPage> createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  late ImcRepository imcRepository;
  var _registros = const <ImcModel>[];
  PageController controller = PageController(initialPage: 0);
  int posicaoPagina = 0;

  var pesoController = TextEditingController();
  var alturaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    obterTarefas();
  }

  void obterTarefas() async {
    imcRepository = await ImcRepository.carregar();
    _registros = imcRepository.obterDados();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Página Consulta"),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: _registros.length,
                      itemBuilder: (BuildContext bc, int index) {
                        var tarefa = _registros[index];
                        return Dismissible(
                          onDismissed:
                              (DismissDirection dismissDirection) async {
                            imcRepository.excluir(tarefa);
                            obterTarefas();
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
                                Text(tarefa.altura.toString())
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    onTap: (value) {
                      controller.jumpToPage(value);
                    },
                    currentIndex: posicaoPagina,
                    items: const [
                      BottomNavigationBarItem(
                          label: "Inicio", icon: Icon(Icons.home)),
                      BottomNavigationBarItem(
                          label: "Registros",
                          icon: Icon(Icons.app_registration)),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
