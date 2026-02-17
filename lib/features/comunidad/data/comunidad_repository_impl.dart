// lib/features/comunidad/data/repositories/comunidad_repository_impl.dart

import 'package:my_secure_app/features/comunidad/data/comunidad_local_datasource.dart';
import 'package:my_secure_app/features/comunidad/data/comunidad_repository.dart';
import 'package:my_secure_app/features/comunidad/models/emprendimiento_model.dart';

//import '../../domain/repositories/comunidad_repository.dart';
//import '../datasources/comunidad_local_datasource.dart';
//import '../models/emprendimiento_model.dart';

class ComunidadRepositoryImpl implements ComunidadRepository {
  final ComunidadLocalDatasource datasource;

  ComunidadRepositoryImpl({required this.datasource});

  @override
  List<EmprendimientoModel> obtenerTodos() => datasource.getAll();

  @override
  List<EmprendimientoModel> obtenerPorCategoria(String categoria) =>
      datasource.getByCategoria(categoria);

  @override
  EmprendimientoModel? obtenerPorId(String id) => datasource.getById(id);
}
