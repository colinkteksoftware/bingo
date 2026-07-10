import 'package:flutter/material.dart';

class StartedPage extends StatefulWidget {
  const StartedPage({super.key});

  @override
  State<StartedPage> createState() => _StartedPageState();
}

class _StartedPageState extends State<StartedPage> {
  int selectedTab = 1;
  int selectedDate = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5F7),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff7B4DFF),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSearch(),
            const SizedBox(height: 24),
            _buildDates(),
            const SizedBox(height: 20),
            _buildTabs(),
            const SizedBox(height: 20),
            _buildActiveCard(),
            const SizedBox(height: 16),
            _buildNextCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return const BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home),
            Icon(Icons.confirmation_number),
            SizedBox(width: 40),
            Icon(Icons.bar_chart),
            Icon(Icons.settings),
          ],
        ),
      ),
    );
  }

  Widget _buildDates() {
    final dates = [
      {"month": "FEB", "day": "28"},
      {"month": "MAR", "day": "04"},
      {"month": "MAR", "day": "05"},
      {"month": "MAR", "day": "06"},
    ];

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final selected = selectedDate == index;
          return GestureDetector(
            onTap: () => setState(() => selectedDate = index),
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: selected ? const Color(0xff7B4DFF) : Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dates[index]["month"]!,
                      style: TextStyle(
                          color: selected ? Colors.white : Colors.grey)),
                  Text(dates[index]["day"]!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selected ? Colors.white : Colors.black)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        /*Row(
          children: [
            _letterCircle("B", Colors.amber),
            _letterCircle("I", Colors.pink),
            _letterCircle("N", Colors.indigo),
            _letterCircle("G", Colors.green),
            _letterCircle("O", Colors.orange),
          ],
        ),*/
        Icon(Icons.dark_mode_outlined)
      ],
    );
  }

  /*Widget _letterCircle(String letter, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: color,
        child: Text(letter,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }*/

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Buscar sorteos o IDs...",
        ),
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ["Inactivo", "Activo", "Jugando", "Finalizado"];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final selected = selectedTab == index;
          return GestureDetector(
            onTap: () => setState(() => selectedTab = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: selected ? const Color(0xff7B4DFF) : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style:
                      TextStyle(color: selected ? Colors.white : Colors.grey),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff6A5AE0), Color(0xff8E7CFF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("202603040001",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          SizedBox(height: 8),
          Text("\$800.00 USD",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildNextCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("2026030500124",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          SizedBox(height: 8),
          Text("\$1,250.00",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
