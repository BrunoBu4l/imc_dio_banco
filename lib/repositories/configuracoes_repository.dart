import 'package:hive/hive.dart';
import 'package:imcproject_hive/models/configuracoes_model.dart';

class ConfiguracoesRepository {
  static late Box _box;

  ConfiguracoesRepository._criar();

  static Future<ConfiguracoesRepository> carregar() async {
    if (Hive.isBoxOpen('configuracoes')) {
      _box = Hive.box('configuracoes');
    } else {
      _box = await Hive.openBox('configuracoes');
    }
    return ConfiguracoesRepository._criar();
  }

  void salvar(ConfiguracoesModel configuracoesModel) {
    _box.put('configuracoesModel', {
      'peso': configuracoesModel.peso,
      'altura': configuracoesModel.altura,
      'classificacao': configuracoesModel.classificacao,
    });
  }

  ConfiguracoesModel obterDados() {
    var configuracoes = _box.get('configuracoesModel');
    if (configuracoes == null) {
      return ConfiguracoesModel.vazio();
    }
    return ConfiguracoesModel(
      configuracoes["peso"],
      configuracoes["altura"],
      configuracoes["classificacao"],
    );
  }
}
