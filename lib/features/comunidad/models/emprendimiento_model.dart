// lib/features/comunidad/data/models/emprendimiento_model.dart

class ServicioModel {
  final String icono;
  final String titulo;
  final String descripcion;

  const ServicioModel({
    required this.icono,
    required this.titulo,
    required this.descripcion,
  });
}

class ResenaModel {
  final String nombre;
  final int estrellas;
  final String texto;
  final String fecha;

  const ResenaModel({
    required this.nombre,
    required this.estrellas,
    required this.texto,
    required this.fecha,
  });
}

class EmprendimientoModel {
  final String id;
  final String nombre;
  final String categoria;       // 'gastronomia' | 'artesania' | 'hospedaje'
  final String descripcionCorta;
  final String descripcionLarga;
  final String imagenUrl;
  final String tramo;
  final String ubicacion;
  final double calificacion;
  final int totalResenas;
  final String contactoNombre;
  final String telefono;
  final String horario;
  final List<ServicioModel> servicios;
  final List<ResenaModel> resenas;

  const EmprendimientoModel({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.descripcionCorta,
    required this.descripcionLarga,
    required this.imagenUrl,
    required this.tramo,
    required this.ubicacion,
    required this.calificacion,
    required this.totalResenas,
    required this.contactoNombre,
    required this.telefono,
    required this.horario,
    required this.servicios,
    required this.resenas,
  });
}
