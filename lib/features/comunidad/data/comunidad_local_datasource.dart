// lib/features/comunidad/data/datasources/comunidad_local_datasource.dart

import '../models/emprendimiento_model.dart';

/// Fuente de datos local (mock). Reemplazar con API o Hive según necesites.
class ComunidadLocalDatasource {
  static const List<EmprendimientoModel> emprendimientos = [
    EmprendimientoModel(
      id: 'cafe-don-pedro',
      nombre: 'Café Don Pedro',
      categoria: 'gastronomia',
      descripcionCorta: 'Café artesanal y repostería tradicional',
      descripcionLarga:
          'Café Don Pedro es un emprendimiento familiar que lleva tres generaciones '
          'cultivando café de altura. Ofrecemos una experiencia completa: desde el '
          'recorrido por los cultivos hasta la degustación de café recién tostado y '
          'repostería tradicional hecha con productos de la región.',
      imagenUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAXX2Bt7fml4ZAjFhcZewqDD5Qdmh-pOXWVrzcY6Ewir13jD9-xpnl2lJe539q_9In4YOpOtF_qEof3lZRawGjONJhsAC7uNtAdhiyfuw7Vf38jPAgiYcj2LvsAP4wuinbstfh2gIrOOiMbSAuXBg5es1cGBUPg_XimEXbgtpkeGfbPlK4x6LV_BBaCBNo0gT8Y0_MJmRxwbcT_Il4Ts3qDp0PlWC94J4_Uj-o-N9_ndRQxVKR6yPSyHEgWub5UDUQv-nQ1wtFkgTDO',
      tramo: 'Tramo 1, km 8',
      ubicacion: 'Tramo 1, km 8 - Valle Verde',
      calificacion: 4.8,
      totalResenas: 42,
      contactoNombre: 'Pedro Ramírez & Familia',
      telefono: '+57 300 123 4567',
      horario: 'Lunes a Domingo, 7:00 AM - 6:00 PM',
      servicios: [
        ServicioModel(icono: 'local_cafe', titulo: 'Degustación de Café', descripcion: 'Prueba 5 variedades de café especial'),
        ServicioModel(icono: 'agriculture', titulo: 'Tour por la Finca', descripcion: 'Conoce el proceso del café (2 horas)'),
        ServicioModel(icono: 'restaurant', titulo: 'Almuerzos Tradicionales', descripcion: 'Comida casera con productos locales'),
      ],
      resenas: [
        ResenaModel(nombre: 'María González', estrellas: 5, texto: 'Excelente experiencia! El tour fue muy educativo y el café es delicioso.', fecha: 'Hace 2 días'),
        ResenaModel(nombre: 'Carlos Mendoza', estrellas: 4, texto: 'Muy buena atención, el café especial está delicioso. Lo recomiendo.', fecha: 'Hace 1 semana'),
      ],
    ),
    EmprendimientoModel(
      id: 'tejidos-ancestrales',
      nombre: 'Tejidos Ancestrales',
      categoria: 'artesania',
      descripcionCorta: 'Textiles y artesanías indígenas',
      descripcionLarga:
          'Tejidos Ancestrales es una cooperativa de mujeres artesanas que preservan '
          'las técnicas milenarias de tejido indígena. Cada pieza cuenta una historia '
          'de la comunidad y es elaborada a mano con materiales naturales de la región.',
      imagenUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBS2RZRdHvVpPdrGhk4RxENSp_bae2h_NlA7ARIenScdoaMZjLIVfvoXzxqE2kGAbopgzREFUiDl1AjvU7NmecyKOXbgazopZRECNDF-cHkknlcX1A7vZgZTp0LBcOiY5HRQ4pTt5p0nxYZJEyAAG1QomJpZqsVMesbiNX9ztLNruBTtYpDz2jIRXST0S0l00DHivwym_EeQtS0tGeQfZs0vXAQeUhbVY1ZqrDw51mcUVOBCrpFxLu4NZwRvvjdQLvFsIlIaTkqv8Ss',
      tramo: 'Tramo 2, km 5',
      ubicacion: 'Tramo 2, km 5 - Comunidad Wayuu',
      calificacion: 4.9,
      totalResenas: 28,
      contactoNombre: 'Rosa Wayuu (Coordinadora)',
      telefono: '+57 310 987 6543',
      horario: 'Martes a Sábado, 8:00 AM - 5:00 PM',
      servicios: [
        ServicioModel(icono: 'checkroom', titulo: 'Mochilas Wayuu', descripcion: 'Bolsos tejidos a mano con diseños únicos'),
        ServicioModel(icono: 'palette', titulo: 'Taller de Tejido', descripcion: 'Aprende técnicas ancestrales (4 horas)'),
        ServicioModel(icono: 'shopping_bag', titulo: 'Venta de Artesanías', descripcion: 'Hamacas, manillas y textiles decorativos'),
      ],
      resenas: [
        ResenaModel(nombre: 'Lucía Fernández', estrellas: 5, texto: 'Las mochilas son increíbles, auténtica artesanía. El taller fue una experiencia que no olvidaré.', fecha: 'Hace 3 días'),
      ],
    ),
    EmprendimientoModel(
      id: 'posada-el-descanso',
      nombre: 'Posada El Descanso',
      categoria: 'hospedaje',
      descripcionCorta: 'Alojamiento familiar comunitario',
      descripcionLarga:
          'Posada El Descanso es un alojamiento familiar con vistas panorámicas al camino. '
          'Ofrecemos habitaciones cómodas, desayuno incluido con productos orgánicos '
          'del huerto y un ambiente tranquilo para recuperar energías.',
      imagenUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAXX2Bt7fml4ZAjFhcZewqDD5Qdmh-pOXWVrzcY6Ewir13jD9-xpnl2lJe539q_9In4YOpOtF_qEof3lZRawGjONJhsAC7uNtAdhiyfuw7Vf38jPAgiYcj2LvsAP4wuinbstfh2gIrOOiMbSAuXBg5es1cGBUPg_XimEXbgtpkeGfbPlK4x6LV_BBaCBNo0gT8Y0_MJmRxwbcT_Il4Ts3qDp0PlWC94J4_Uj-o-N9_ndRQxVKR6yPSyHEgWub5UDUQv-nQ1wtFkgTDO',
      tramo: 'Tramo 1, km 12',
      ubicacion: 'Tramo 1, km 12 - La Cuchilla',
      calificacion: 4.7,
      totalResenas: 35,
      contactoNombre: 'Familia Morales',
      telefono: '+57 315 456 7890',
      horario: 'Check-in: 2:00 PM | Check-out: 11:00 AM',
      servicios: [
        ServicioModel(icono: 'bed', titulo: 'Habitaciones', descripcion: '6 habitaciones con baño privado o compartido'),
        ServicioModel(icono: 'free_breakfast', titulo: 'Desayuno Incluido', descripcion: 'Productos orgánicos del huerto propio'),
        ServicioModel(icono: 'luggage', titulo: 'Guardarropa', descripcion: 'Custodia de equipaje para caminantes'),
      ],
      resenas: [
        ResenaModel(nombre: 'Andrés Torres', estrellas: 5, texto: 'El lugar perfecto para descansar. La familia es hospitalísima y el desayuno es increíble.', fecha: 'Hace 5 días'),
      ],
    ),
  ];

  List<EmprendimientoModel> getAll() => emprendimientos;

  List<EmprendimientoModel> getByCategoria(String categoria) =>
      emprendimientos.where((e) => e.categoria == categoria).toList();

  EmprendimientoModel? getById(String id) {
    try {
      return emprendimientos.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
