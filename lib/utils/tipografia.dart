import 'package:flutter/cupertino.dart';

class TipoTipografia {
  static const FontWeight regular = FontWeight.w200;

  static const FontWeight medium = FontWeight.w400;

  static const FontWeight bold = FontWeight.w600;

  static const FontWeight ultra = FontWeight.w800;
}

class Tipografia {
  static const String fontName = 'TripSans';

  static const TextStyle titulo1 = TextStyle(
    fontFamily: fontName,
    fontSize: 40.0,
    fontWeight: TipoTipografia.ultra,
  );

  static const TextStyle titulo2 = TextStyle(
    fontFamily: fontName,
    fontSize: 18.0,
    fontWeight: TipoTipografia.bold,
  );

  static const TextStyle titulo3 = TextStyle(
    fontFamily: fontName,
    fontSize: 24.0,
    fontWeight: TipoTipografia.bold,
  );

  static const TextStyle titulo4 = TextStyle(
    fontFamily: fontName,
    fontSize: 24.0,
    fontWeight: TipoTipografia.ultra,
  );

  static const TextStyle corpo1 = TextStyle(
    fontFamily: fontName,
    fontSize: 18.0,
    fontWeight: TipoTipografia.medium,
  );

  static const TextStyle corpo2 = TextStyle(
    fontFamily: fontName,
    fontSize: 16.0,
    fontWeight: TipoTipografia.regular,
  );
  static const TextStyle corpo2Bold = TextStyle(
    fontFamily: fontName,
    fontSize: 16.0,
    fontWeight: TipoTipografia.bold,
  );
}
