// ignore_for_file: unnecessary_getters_setters

class ConfiguracoesModel {
  double _peso = 0;
  double _altura = 0;
  double _classificacao = 0;

  ConfiguracoesModel.vazio() {
    _peso = 0;
    _altura = 0;
    _classificacao = 0;
  }

  ConfiguracoesModel(this._altura, this._peso, this._classificacao);

  double get altura => _altura;

  set altura(double altura) {
    _altura = altura;
  }

  double get peso => _peso;

  set peso(double peso) {
    _peso = peso;
  }

  double get classificacao => _classificacao;

  set classificacao(double classificacao) {
    _classificacao = classificacao;
  }
}
