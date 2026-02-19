// lib/features/comunidad/domain/repositories/comunidad_repository.dart

import 'package:my_secure_app/features/comunidad/models/emprendimiento_model.dart';

//import '../../data/models/emprendimiento_model.dart';

abstract class ComunidadRepository {
  List<EmprendimientoModel> obtenerTodos();
  List<EmprendimientoModel> obtenerPorCategoria(String categoria);
  EmprendimientoModel? obtenerPorId(String id);
}
