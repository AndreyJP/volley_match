import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Navbar maior e destacada
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'VolleyMatch',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Logo maior e espaçada
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.person, size: 64, color: Colors.blueAccent),
              SizedBox(width: 24),
              Icon(Icons.group, size: 64, color: Colors.green),
              SizedBox(width: 24),
              Icon(Icons.bar_chart, size: 64, color: Colors.teal),
            ],
          ),

          const SizedBox(height: 50),

          // Cards full-width com mais espaçamento
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                children: [
                  _buildFullWidthCard(
                    context,
                    icon: Icons.person,
                    label: 'Jogadores',
                    color: Colors.blueAccent,
                    onPressed: () =>
                        Navigator.pushNamed(context, '/players'),
                  ),
                  const SizedBox(height: 24),
                  _buildFullWidthCard(
                    context,
                    icon: Icons.group,
                    label: 'Times',
                    color: Colors.green,
                    onPressed: () => Navigator.pushNamed(context, '/teams'),
                  ),
                  const SizedBox(height: 24),
                  _buildFullWidthCard(
                    context,
                    icon: Icons.sports_volleyball,
                    label: 'Placar',
                    color: Colors.cyan,
                    onPressed: () =>
                        Navigator.pushNamed(context, '/scoreboard'),
                  ),
                  const SizedBox(height: 24),
                  _buildFullWidthCard(
                    context,
                    icon: Icons.bar_chart,
                    label: 'Partidas',
                    color: Colors.teal,
                    onPressed: () =>
                        Navigator.pushNamed(context, '/matches'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthCard(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
