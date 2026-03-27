import 'dart:io';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() async {
  final logoFile = File('assets/images/cleanfinance-logo.png');
  final logoBytes = await logoFile.readAsBytes();
  final logo = pw.MemoryImage(logoBytes);
  final pdf = pw.Document();
  final date = DateFormat('dd/MM/yyyy').format(DateTime.now());

  pw.Widget bullet(String text) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('• ', style: const pw.TextStyle(fontSize: 11)),
            pw.Expanded(
              child: pw.Text(
                text,
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 2),
              ),
            ),
          ],
        ),
      );

  pdf.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(
          base: pw.Font.helvetica(),
          bold: pw.Font.helveticaBold(),
        ),
      ),
      build: (context) => [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(
              width: 64,
              height: 64,
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(16),
              ),
              child: pw.ClipRRect(
                horizontalRadius: 16,
                verticalRadius: 16,
                child: pw.Image(logo, fit: pw.BoxFit.cover),
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'CleanFinance',
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blueGrey900,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Presentación comercial de producto',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.blueGrey600,
                  ),
                ),
                pw.Text(
                  'Documento generado el $date',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.blueGrey400,
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 24),
        pw.Container(
          padding: const pw.EdgeInsets.all(18),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromInt(0xFFEAF4F3),
            borderRadius: pw.BorderRadius.circular(18),
          ),
          child: pw.Text(
            'CleanFinance es una app móvil de finanzas personales, privada y offline, diseñada para que cualquier persona registre ingresos, gastos, ahorros y metas de forma simple, visual y confiable.',
            style: const pw.TextStyle(fontSize: 12, lineSpacing: 3),
          ),
        ),
        pw.SizedBox(height: 24),
        pw.Text(
          'Propuesta de valor',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        bullet('Experiencia moderna, minimalista y enfocada en claridad visual.'),
        bullet('Funcionamiento 100% local: sin backend ni dependencia de nube.'),
        bullet('Control rápido del dinero con dashboard, reportes e insights simples.'),
        bullet('Acceso seguro con PIN, biometría y recuperación por preguntas personales.'),
        bullet('Ideal para usuarios que quieren entender sus finanzas sin tecnicismos.'),
        pw.SizedBox(height: 20),
        pw.Text(
          'Funciones principales',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        bullet('Dashboard con saldo actual, ingresos, gastos, ahorro y accesos rápidos.'),
        bullet('Registro de movimientos con categorías, subcategorías y medio de pago configurable.'),
        bullet('Metas de ahorro múltiples con progreso visual y aportes vinculados.'),
        bullet('Reportes visuales: distribución por categoría, evolución mensual e ingresos vs gastos.'),
        bullet('Ajustes de moneda, idioma (español/inglés), tema, biometría y respaldo local.'),
        pw.SizedBox(height: 20),
        pw.Text(
          'Mejoras recientes incorporadas',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        bullet('Nuevo branding con logo personalizado y nombre CleanFinance en launcher y app.'),
        bullet('Rediseño integral de UI/UX con estilo fintech moderno, tarjetas y más aire visual.'),
        bullet('Selector desplegable de medios de pago administrables desde Ajustes.'),
        bullet('Selector de idioma con soporte para español e inglés en la app principal.'),
        bullet('Soporte Android mejorado para biometría mediante FlutterFragmentActivity.'),
        pw.SizedBox(height: 20),
        pw.Text(
          'Arquitectura y tecnología',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        bullet('Frontend mobile en Flutter con enfoque multiplataforma.'),
        bullet('Arquitectura limpia: capas separadas de presentación, dominio y datos.'),
        bullet('Base local SQLite y almacenamiento seguro con secure storage del sistema.'),
        bullet('Estado manejado con Riverpod para mantener el código escalable y testeable.'),
        pw.SizedBox(height: 20),
        pw.Text(
          'Seguridad y privacidad',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        bullet('PIN local hasheado con derivación segura.'),
        bullet('Biometría opcional como acceso rápido, con fallback a PIN.'),
        bullet('Recuperación local mediante dos respuestas personales hasheadas.'),
        bullet('Sin tracking, sin publicidad y sin envío de datos financieros a terceros.'),
        pw.SizedBox(height: 20),
        pw.Text(
          'Escenarios de uso',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        bullet('Usuarios individuales que quieren control diario del dinero.'),
        bullet('Clientes que valoran privacidad, simplicidad y operación offline.'),
        bullet('Productos white-label o adaptaciones para nichos de educación financiera.'),
      ],
    ),
  );

  final outputFile = File('docs/CleanFinance-presentacion-cliente.pdf');
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsBytes(await pdf.save());
}
