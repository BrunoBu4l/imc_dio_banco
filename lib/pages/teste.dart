import 'package:flutter/material.dart';
import 'package:imcproject_hive/configuracoes/configuracoes_hive_page.dart';
import 'package:imcproject_hive/models/imc_model.dart';
import 'package:imcproject_hive/pages/consulta_page.dart';
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

  @override
  void initState() {
    super.initState();
    obterTarefas();
  }

  void obterTarefas() async {
    imcRepository = await ImcRepository.carregar();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Página Principal"),
        ),
        body: Column(
          children: [
            const Text("Cadastro de Imc:"),
            const Text("Peso em Kilos:"),
            TextField(
              controller: pesoController,
              keyboardType: TextInputType.number,
            ),
            const Text("Altura em Metros:"),
            TextField(
              controller: alturaController,
              keyboardType: TextInputType.number,
            ),
            TextButton(
                onPressed: () async {
                  try {
                    double altura = double.parse(alturaController.text);
                    double peso = double.parse(pesoController.text);
                    double classificacao = 0;
                    await imcRepository
                        .salvar(ImcModel.criar(altura, peso, classificacao));
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    obterTarefas();
                    setState(() {});
                  } catch (e) {
                    // Trate qualquer erro de conversão aqui, como valores inválidos.
                    debugPrint('Erro ao converter para Double: $e');
                  }
                },
                child: const Text("Salvar")),
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (value) {
                  setState(() {
                    posicaoPagina = value;
                  });
                },
                children: const [
                  MainPage(),
                  ConsultaPage(),
                  ConfiguracoesHivePage(),
                ],
              ),
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
                      label: "Consulta", icon: Icon(Icons.check)),
                  BottomNavigationBarItem(
                      label: "Registros", icon: Icon(Icons.app_registration)),
                ])
          ],
        ),
      ),
    );
  }
}
