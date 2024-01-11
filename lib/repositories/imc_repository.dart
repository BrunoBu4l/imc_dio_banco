import 'package:hive/hive.dart';
import 'package:imcproject_hive/models/imc_model.dart';

class ImcRepository {
  static late Box _box;

  ImcRepository._criar();

  static Future<ImcRepository> carregar() async {
    if (Hive.isBoxOpen('dadosCadastraisModel1')) {
      _box = Hive.box('dadosCadastraisModel1');
    } else {
      _box = await Hive.openBox('dadosCadastraisModel1');
    }
    return ImcRepository._criar();
  }

  salvar(ImcModel imcModel) {
    _box.add(imcModel);
  }

  alterar(ImcModel imcModel) {
    imcModel.save();
  }

  excluir(ImcModel imcModel) {
    imcModel.delete();
  }

  List<ImcModel> obterDados() {
    return _box.values.cast<ImcModel>().toList();
  }
}
