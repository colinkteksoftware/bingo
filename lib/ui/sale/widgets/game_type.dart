import 'package:bingo/providers/sale_provider.dart';
import 'package:bingo/utils/colores.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameTypeWidget extends StatefulWidget {
  const GameTypeWidget({Key? key}) : super(key: key);

  @override
  State<GameTypeWidget> createState() => _GameTypeWidgetState();
}

class _GameTypeWidgetState extends State<GameTypeWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaleProvider>(context);
    var size = MediaQuery.of(context).size;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              provider.updateType(0);
              provider.calculeTotal();
              //setState(() {});
            },
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: provider.type == 0 ? primaryBlue : Colors.black,
                    width: 2,
                  ),
                  color: provider.type == 0 ? primaryBlue : Colors.transparent,
                ),
                padding: const EdgeInsets.all(12),
                child: provider.type == 0
                    ? const Icon(Icons.check, color: Color(0xFFcaf0f8))
                    : const SizedBox(),
              ),
              Center(
                child: Text(
                  "Normal",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.030,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]),
          ),
          const SizedBox(width: 3.5),
          GestureDetector(
            onTap: () {
              provider.updateType(1);
              provider.calculeTotal();
              //setState(() {});
            },
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: provider.type == 1 ? primaryBlue : Colors.black,
                    width: 2,
                  ),
                  color: provider.type == 1 ? primaryBlue : Colors.transparent,
                ),
                padding: const EdgeInsets.all(12),
                child: provider.type == 1
                    ? const Icon(Icons.check, color: Color(0xFFcaf0f8))
                    : const SizedBox(),
              ),
              Center(
                child: Text(
                  "Promocional",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.030,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]),
          ),
          const SizedBox(width: 3.5),
          GestureDetector(
            onTap: () {
              provider.updateType(2);
              provider.calculeTotal();
              setState(() {
                _controller.text = provider.counter.toString();
              });
            },
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: provider.type == 2 ? primaryBlue : Colors.black,
                    width: 2,
                  ),
                  color: provider.type == 2 ? primaryBlue : Colors.transparent,
                ),
                padding: const EdgeInsets.all(12),
                child: provider.type == 2
                    ? const Icon(Icons.check, color: Color(0xFFcaf0f8))
                    : const SizedBox(),
              ),
              Center(
                child: Text(
                  "Progresivo",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.030,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]),
          ),
          provider.type == 2
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.amber),
                      onPressed: () {
                        provider.decrement();
                        setState(() {
                          _controller.text = provider.counter.toString();
                        });
                      },
                    ),
                    SizedBox(
                      width: size.width * 0.14,
                      child: TextFormField(
                        controller: _controller,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.034,
                          fontFamily: 'gotic',
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * 0.034,
                            fontFamily: 'gotic',
                            fontWeight: FontWeight.bold,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * 0.020,
                            fontFamily: 'gotic',
                            fontWeight: FontWeight.bold,
                          ),
                          labelText: 'Cantidad',
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            final newValue = int.tryParse(value);
                            if (newValue != null && newValue >= 0) {
                              provider.updateCounter(newValue);
                              _controller.text = provider.counter.toString();
                            } else {
                              _controller.text = provider.counter.toString();
                            }
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.amber),
                      onPressed: () {
                        provider.increment();
                        setState(() {
                          _controller.text = provider.counter.toString();
                        });
                      },
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
