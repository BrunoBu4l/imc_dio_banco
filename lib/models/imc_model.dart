import 'package:hive/hive.dart';

part 'imc_model.g.dart';

@HiveType(typeId: 0)
class ImcModel extends HiveObject {
  @HiveField(0)
  double altura = 0.00;

  @HiveField(1)
  double peso = 0.00;

  @HiveField(2)
  double classificacao = 0.00;

  ImcModel();

  ImcModel.criar(this.altura, this.peso, this.classificacao);
}
