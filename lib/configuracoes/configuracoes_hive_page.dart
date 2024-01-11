import 'package:flutter/material.dart';
import 'package:imcproject_hive/models/configuracoes_model.dart';
import 'package:imcproject_hive/repositories/configuracoes_repository.dart';

class ConfiguracoesHivePage extends StatefulWidget {
  const ConfiguracoesHivePage({Key? key}) : super(key: key);

  @override
  State<ConfiguracoesHivePage> createState() => _ConfiguracoesHivePageState();
}

class _ConfiguracoesHivePageState extends State<ConfiguracoesHivePage> {
  late ConfiguracoesRepository configuracoesRepository;
  var configuracoesModel = ConfiguracoesModel.vazio();

  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  TextEditingController classificacaoController = TextEditingController();

  @override
  void initState() {
    // implement initState
    super.initState();
    carregarDados();
  }

  carregarDados() async {
    configuracoesRepository = await ConfiguracoesRepository.carregar();
    configuracoesModel = configuracoesRepository.obterDados();
    pesoController.text = configuracoesModel.peso.toString();
    alturaController.text = configuracoesModel.altura.toString();
    classificacaoController.text = configuracoesModel.classificacao.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: const Text("Configurações Hive")),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Altura"),
                    controller: alturaController,
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      try {
                        configuracoesModel.altura =
                            double.parse(alturaController.text);
                        configuracoesModel.peso =
                            double.parse(pesoController.text);
                        configuracoesModel.classificacao =
                            double.parse(classificacaoController.text);
                      } catch (e) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("Meu App"),
                                content: const Text(
                                    "Favor informar uma altura ou peso válida!"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Ok"))
                                ],
                              );
                            });
                        return;
                      }

                      configuracoesRepository.salvar(configuracoesModel);
                      Navigator.pop(context);
                    },
                    child: const Text("Salvar"))
              ],
            )));
  }
}
