void archivoExcel() {
  try {
    // Crear un nuevo libro de trabajo Excel (XSSFWorkbook es para archivos .xlsx)
    Workbook workbook = new XSSFWorkbook();

    // Crear una hoja dentro del libro

    for (Particula p : particula) {
      
      
      Sheet hoja = workbook.createSheet("Particula #" + p.i);

      // Crear una fila en la hoja
      Row fila = hoja.createRow(0);
      fila.createCell(0).setCellValue("Carga");
      fila.createCell(1).setCellValue(p.q);

      fila = hoja.createRow(1);
      fila.createCell(0).setCellValue("Masa");
      fila.createCell(1).setCellValue(p.masa);

      fila = hoja.createRow(3);
      fila.createCell(0).setCellValue("Tiempo");
      fila.createCell(1).setCellValue("PosX");
      fila.createCell(2).setCellValue("PosY");
      fila.createCell(3).setCellValue("VelX");
      fila.createCell(4).setCellValue("VelY");
      fila.createCell(5).setCellValue("Velocidad");
      fila.createCell(6).setCellValue("AcelX");
      fila.createCell(7).setCellValue("ACelY");
      fila.createCell(8).setCellValue("Aceleracion");
      fila.createCell(9).setCellValue("FuerzaX");
      fila.createCell(10).setCellValue("FuerzaY");
      fila.createCell(11).setCellValue("Fuerza");
      fila.createCell(12).setCellValue("Campo");
      
      for(int i = 0; i < p.datoTiempo.size(); i++){
        Row row = hoja.createRow(4 + i);
        row.createCell(0).setCellValue(p.datoTiempo.get(i)); // Time
        row.createCell(1).setCellValue(p.datoPos.get(i).x); // PosX
        row.createCell(2).setCellValue(p.datoPos.get(i).y); // PosY
        row.createCell(3).setCellValue(p.datoVel.get(i).x); // VelX
        row.createCell(4).setCellValue(p.datoVel.get(i).y); // VelY
        row.createCell(5).setCellValue(p.datoVel.get(i).mag()); // Velocity magnitude
        row.createCell(6).setCellValue(p.datoAc.get(i).x); // AcelX
        row.createCell(7).setCellValue(p.datoAc.get(i).y); // AcelY
        row.createCell(8).setCellValue(p.datoAc.get(i).mag()); // Acceleration magnitude
        row.createCell(9).setCellValue(p.datoFuerza.get(i).x); // FuerzaX
        row.createCell(10).setCellValue(p.datoFuerza.get(i).y); // FuerzaY
        row.createCell(11).setCellValue(p.datoFuerza.get(i).mag()); // Force magnitude
        row.createCell(12).setCellValue(p.datoCampo.get(i).mag()); // Campo magnitude
      }
      
      
    }

    // Intentar guardar el archivo Excel en el sistema
    FileOutputStream fileOut = new FileOutputStream(dataPath("simulacion.xlsx"));
    workbook.write(fileOut);
    fileOut.close();
    workbook.close();
    println("Archivo Excel creado exitosamente.");
  }
  catch (IOException e) {
    e.printStackTrace();
    println("Error al crear el archivo Excel.");
  }
}
