import 'package:bingo/providers/bingo_provider.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

//late Future<void> _initializeControllerFuture;

class BingoDetailPage extends StatefulWidget {
  const BingoDetailPage({super.key});

  @override
  State<BingoDetailPage> createState() => _BingoDetailPageState();
}

class _BingoDetailPageState extends State<BingoDetailPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //final provider = Provider.of<BingoProvider>(context, listen: false);
    final provider = context.watch<BingoProvider>();
    return SingleChildScrollView(
      child: Container(
        height:
            provider.qrcode != "-1" ? size.height * 0.16 : size.height * 0.16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: provider.qrcode != "-1"
                          ? size.height * 0.15
                          : size.height * 0.15,
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
                      child: Row(
                        children: [
                          Container(
                            width: size.width * 0.68,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 2, 0, 2),
                                            child: Text(
                                              'Bingo ID',
                                              style: TextStyle(
                                                fontFamily: 'Cera Pro',
                                                color: Colors.white,
                                                fontSize: size.width * 0.030,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${provider.bingo.bingoId ?? 0}'
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontFamily: 'Cera Pro',
                                              color: Colors.white,
                                              fontSize: size.width * 0.050,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 25, 0),
                                    child: Text(
                                      'Valor \$${provider.bingo.precioPorCartilla?.toStringAsFixed(2) ?? '0'}',
                                      style: TextStyle(
                                        fontFamily: 'Cera Pro',
                                        color: Colors.white,
                                        fontSize: size.width * 0.030,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    provider.figure.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        dateFormatted(provider.bingo.fecha
                                            .toString()
                                            .substring(0, 16)),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () async {
                                if (provider.bingo.estado == 3) {
                                  showAlerta(
                                    context,
                                    'Mensaje Informativo',
                                    'El bingo ya se encuentra finalizado',
                                  );
                                  return;
                                }

                                provider.updateQrcode('-1');
                                provider.updateScan(true);

                                final status =
                                    await Permission.camera.request();

                                if (!status.isDenied) {
                                  provider.clearBooklet();
                                  provider.updateLoading(true);

                                  if (provider.isLoading) {
                                    final String? scan =
                                        await SimpleBarcodeScanner.scanBarcode(
                                      context,
                                      barcodeAppBar: const BarcodeAppBar(
                                        appBarTitle: 'Test',
                                        centerTitle: false,
                                        enableBackButton: true,
                                        backButtonIcon:
                                            Icon(Icons.arrow_back_ios),
                                      ),
                                      isShowFlashIcon: true,
                                      delayMillis: 2000,
                                      cameraFace: CameraFace.back,
                                    );

                                    print('result scan => $scan');
                                    if (scan != null && scan != '-1') {
                                      provider.updateQrcode(scan);
                                      provider.updateLoading(false);
                                    }
                                  }
                                }
                              },                              
                              child: Builder(
                                builder: (_) {
                                  final estado = provider.bingo.estado;

                                  if ((estado == 1 || estado == 2) &&
                                      !provider.isScanning) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.qr_code,
                                          color: Colors.white,
                                          size: size.width * 0.14,
                                        ),
                                      ],
                                    );
                                  } else if (estado == 3) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.monetization_on_outlined,
                                          color: Colors.green[600],
                                          size: size.width * 0.14,
                                        ),
                                      ],
                                    );
                                  } else if (estado == 4) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red[600],
                                          size: size.width * 0.14,
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ),
                          )

                          /*provider.bingo.estado == 1 ||
                                  provider.bingo.estado == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: GestureDetector(
                                    onTap: () async {
                                      Center(
                                        child: provider.isLoading
                                            ? const CircularProgressIndicator()
                                            : provider.errorMessage != null
                                                ? Text(provider.errorMessage
                                                    .toString())
                                                : provider.listBingos.isEmpty
                                                    ? const Text(
                                                        'No hay bingo disponibles')
                                                    : ListView.builder(
                                                        itemCount: provider
                                                            .listBingos.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final bingo = provider
                                                                  .listBingos[
                                                              index];
                                                          return ListTile(
                                                            title: Text(
                                                                'ID: ${bingo.bingoId}'),
                                                            subtitle: Text(
                                                                '${bingo.fecha}'),
                                                          );
                                                        },
                                                      ),
                                      );

                                      if (provider.bingo.estado == 3) {
                                        showAlerta(
                                          context,
                                          'Mensaje Informativo',
                                          'El bingo ya se encuentra finalizado',
                                        );
                                        setState(() {});
                                      } else {
                                        provider.updateQrcode('-1');
                                        provider.updateScan(true);
                                        final PermissionStatus status =
                                            await Permission.camera.request();
                                        if (status.isDenied) {
                                          await _initializeControllerFuture;
                                        } else {
                                          provider.clearBooklet();
                                          provider.updateLoading(true);
                                          if (provider.isLoading) {
                                            /*String scan = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const QRScannerScreen(),
                                              ),
                                            );*/

                                            String? scan =
                                                await SimpleBarcodeScanner
                                                    .scanBarcode(
                                              context,
                                              barcodeAppBar:
                                                  const BarcodeAppBar(
                                                appBarTitle: 'Test',
                                                centerTitle: false,
                                                enableBackButton: true,
                                                backButtonIcon:
                                                    Icon(Icons.arrow_back_ios),
                                              ),
                                              isShowFlashIcon: true,
                                              delayMillis: 2000,
                                              cameraFace: CameraFace.back,
                                            );
                                            print('result scan => $scan');
                                            if (scan != null || scan == '-1') {
                                              provider.updateQrcode(
                                                  scan.toString());
                                              provider.updateLoading(false);
                                            }
                                          }
                                        }
                                      }
                                    },
                                    child: (provider.bingo.estado == 1 ||
                                                provider.bingo.estado == 2) &&
                                            !provider.isScanning
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.qr_code,
                                                color: Colors.white,
                                                size: size.width * 0.14,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                  ),
                                )
                              : provider.bingo.estado == 3
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.monetization_on_outlined,
                                            color: Colors.green[600],
                                            size: size.width * 0.14,
                                          ),
                                        ],
                                      ),
                                    )
                                  : provider.bingo.estado == 3
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red[600],
                                                size: size.width * 0.14,
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
