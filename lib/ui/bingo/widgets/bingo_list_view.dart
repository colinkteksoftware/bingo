import 'package:bingo/core/data/models/bingo.dart';
import 'package:bingo/providers/bingo_provider.dart';
import 'package:bingo/utils/colores.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:bingo/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BingosListView extends StatefulWidget {
  const BingosListView({Key? key}) : super(key: key);

  @override
  State<BingosListView> createState() => _BingosListViewState();
}

class _BingosListViewState extends State<BingosListView> {
  final pf = Preferencias();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BingoProvider>(context);

    var size = MediaQuery.of(context).size;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: primaryBlue));
    }

    if (provider.listBingos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.cancel,
              color: primaryBlue,
              size: 60,
            ),
            SizedBox(height: 10),
            Text(
              'No hay bingos disponibles para el estado seleccionado.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: size.height * 0.44,
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          height: 0,
          color: Color(0xFFcaf0f8),
          thickness: 0,
          indent: 0,
          endIndent: 0,
        ),
        itemCount: provider.listBingos.length,
        itemBuilder: (ctx, index) {
          final order = provider.listBingos[index];
          return GestureDetector(
            onTap: () async {
              pf.setBingoId = order.bingoId ?? 0;
              provider.updateBingo(order);

              Bingo playing = order;
              await Navigator.pushNamed(context, AppRoutes.home, arguments: {
                'bingo': playing,
              });

              provider.fetchShowBingos(provider.status);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 3),
              child: Container(
                width: size.width * 0.9,
                height: size.height * 0.19,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: const AssetImage('assets/images/bingo.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 1, 0, 1),
                                  child: Text(
                                    'Bingo ID',
                                    style: TextStyle(
                                      fontFamily: 'Cera Pro',
                                      color: Colors.white,
                                      fontSize: size.width * 0.04,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${order.bingoId}'.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'Cera Pro',
                                    color: Colors.white,
                                    fontSize: size.width * 0.06,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Consumer<BingoProvider>(
                                  builder: (context, figuraProvider, child) {
                                    final figure = figuraProvider.figure.toString();
                                    return Text(
                                      (figure.toString().length > 20)
                                          ? '${figure.toString().substring(0, 20)}...'
                                          : figure.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Descripción: ${order.descripcion}",
                          style: TextStyle(
                            fontFamily: 'Cera Pro',
                            color: Colors.white,
                            fontSize: size.width * 0.034,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 25, 0),
                              child: Column(
                                children: [
                                  Text(
                                    'Valor c/u \$${order.precioPorCartilla?.toStringAsFixed(2) ?? 0}',
                                    style: TextStyle(
                                      fontFamily: 'Cera Pro',
                                      color: Colors.white,
                                      fontSize: size.width * 0.030,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Valor Total \$${((order.precioPorCartilla ?? 0) * 6).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontFamily: 'Cera Pro',
                                      color: Colors.white,
                                      fontSize: size.width * 0.030,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Text(
                              dateFormatted(
                                  order.fecha.toString().substring(0, 16)),
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Colors.white,
                                fontSize: size.width * 0.030,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
