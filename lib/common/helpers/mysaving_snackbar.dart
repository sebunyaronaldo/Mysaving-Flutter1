import 'package:flutter/material.dart';

class MysavingSnackBar extends StatefulWidget {
  const MysavingSnackBar.success({
    Key? key,
    required this.message,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.maxLines = 2,
    this.backgroundColor = Colors.green,
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  const MysavingSnackBar.error({
    Key? key,
    required this.message,
    this.messagePadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.maxLines = 2,
    this.backgroundColor = Colors.red,
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  final String message; // Wiadomość wyświetlana w SnackBarze.
  final Color backgroundColor; // Kolor tła SnackBara.
  final int maxLines; // Maksymalna liczba linii tekstu w SnackBarze.
  final List<BoxShadow> boxShadow; // Cienie SnackBara.
  final BorderRadius borderRadius; // Promień zaokrąglenia SnackBara.
  final EdgeInsetsGeometry
      messagePadding; // Padding dla wiadomości w SnackBarze.
  final double textScaleFactor; // Współczynnik skalowania tekstu.
  final TextAlign textAlign; // Wyrównanie tekstu w SnackBarze.

  @override
  State<MysavingSnackBar> createState() => _MysavingSnackBarState();
}

class _MysavingSnackBarState extends State<MysavingSnackBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip
          .hardEdge, // Określa zachowanie clippingu dla kontenera.W przypadku Clip.hardEdge,
      //obszar poza granicami kontenera zostaje ostro obcięty,a wszystkie elementy poza tym obszarem są niewidoczne
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: widget
            .backgroundColor, // Ustawia kolor tła SnackBara na wartość przekazaną do konstruktora.
        borderRadius: widget
            .borderRadius, // Ustawia promień zaokrąglenia SnackBara na wartość przekazaną do konstruktora.
        boxShadow: widget
            .boxShadow, // Ustawia cień SnackBara na wartość przekazaną do konstruktora.
      ),
      width: double
          .infinity, // Ustawia szerokość kontenera na maksymalną dostępną szerokość.
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Center(
          child: Text(
            widget
                .message, // Ustawia tekst SnackBara na wartość przekazaną do konstruktora.
            style: theme.textTheme.bodyMedium?.merge(
              const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            textAlign: widget
                .textAlign, // Ustawia wyrównanie tekstu na wartość przekazaną do konstruktora.
            overflow: TextOverflow
                .ellipsis, // Określa sposób obsługi przepełnienia tekstu.
            maxLines:
                widget.maxLines, // Ustawia maksymalną liczbę linii tekstu.
            textScaleFactor: widget
                .textScaleFactor, // Ustawia współczynnik skalowania tekstu.
          ),
        ),
      ),
    );
  }
}

const kDefaultBoxShadow = [
  BoxShadow(
    color: Colors.black26,
    offset: Offset(0, 8),
    spreadRadius: 1,
    blurRadius: 30,
  ),
];

const kDefaultBorderRadius = BorderRadius.all(Radius.circular(11));

// Stałe kDefaultBoxShadow i kDefaultBorderRadius definiują domyślne wartości cienia i promienia zaokrąglenia,
// które są wykorzystywane w konstruktorach MysavingSnackBar.success i MysavingSnackBar.error jako wartości
// domyślne, jeśli nie zostaną przekazane inne wartości.
