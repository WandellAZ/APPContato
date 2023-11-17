import 'package:contatos/Contatos.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Telainicial());
}

class Telainicial extends StatelessWidget {
  const Telainicial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: const [
          icone(),
        ]),
      ),
    );
  }
}

class icone extends StatelessWidget {
  const icone({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 360,
          height: 800,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Color.fromARGB(255, 117, 95, 173)),
          child: Stack(
            children: [
              Positioned(
                left: 36,
                top: 90,
                child: Container(
                  width: 288,
                  height: 288,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/pi.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 59,
                top: 487,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Contatos())
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ), backgroundColor: const Color.fromARGB(255, 242, 242, 242),
                    minimumSize: const Size(242, 57),
                  ),
                  child: const Text(
                    'Contatos',
                    style: TextStyle(
                      color: Color(0xFF73007D),
                      fontSize: 24,
                      fontFamily: 'Koulen',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
