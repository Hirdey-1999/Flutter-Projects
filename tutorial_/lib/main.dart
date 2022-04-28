import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  
  Widget build(BuildContext context) {
    Widget titleSection = Container(
    padding: const EdgeInsets.all(32),
    child: Row(
      children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: const Text('LakeSide', style: TextStyle(fontWeight: FontWeight.bold
                ),
              ),
            ),
          Text('Sector-31, Faridabad', style: TextStyle(color: Colors.grey[500],
          ),
          )
          ],)
          ),
          Icon(
      Icons.star,color: Colors.red[500],)
      ],
    ),
    
  );
    Color color = Theme.of(context).primaryColor;
    Widget buttonSection = Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
      children: [
        _buildButtonColumn(color, Icons.call, 'CALL'),
        _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
        _buildButtonColumn(color, Icons.share, 'SHARE'),
      ],
      );
    Widget textSection = const Padding(padding: EdgeInsets.all(32),
      child: Text('Pristine Mall Is Present At The Start Of The Sector-31'
        'Covered By The Residential Houses Which Make It Best To Be Used For Their Morning Walk',softWrap: true,),);
    return MaterialApp(
      
      title: 'FLutter Layout Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Welcome to Flutter Layout Demo'))
        ),
        body: Column(
          children: [
            Image.asset(
              'images/pristine.jpg',
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
            titleSection,
            textSection,
            buttonSection,
            
          ],
        ),
      ),
    );
  }
}

Column _buildButtonColumn(Color color, IconData icon, String label){
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: color),
      Container(
        margin: const EdgeInsets.only(top: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: color,
          )
        ),
      )
    ],
  );
}
