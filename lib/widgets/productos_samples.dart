// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ProductosSamples extends StatelessWidget {
  List imgList = [
    'AH-5838',
    'AH-2311',
    'AH-4444',
    'AD-1234',
  ];

  ProductosSamples({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 0; i < imgList.length; i++)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Checkbox(
                      activeColor: const Color(0xFFFD725A),
                      value: true,
                      onChanged: (value) {}),
                  Container(
                    height: 140,
                    width: 140,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Image.asset('images/${imgList[i]}.jpeg'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          imgList[i],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.7)),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.7,
                      child: Column(
                        children: [
                          const Text('Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500', style: TextStyle(fontSize: 24),),
                          tabla(),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'paginaProducto');
                              },
                              icon: const Icon(Icons.edit),
                              color: Colors.redAccent,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            IconButton(
                              onPressed: (){},
                              icon: const Icon(Icons.delete),
                              color: Colors.redAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  DataTable tabla() {
    return DataTable(
      border: TableBorder.all(),
      columns: const [
        DataColumn(
          label: SizedBox(
            width: 38,
          ),
        ),
        DataColumn(
          label: Text('Talles'),
        ),
        DataColumn(
            label: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Center(
              child: Text(
            'XS',
            style: TextStyle(color: Colors.black),
          )),
        )),
        DataColumn(
            label: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Center(
              child: Text(
            "S",
            style: TextStyle(color: Colors.black),
          )),
        )),
        DataColumn(
            label: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Center(
              child: Text(
            "M",
            style: TextStyle(color: Colors.black),
          )),
        )),
        DataColumn(
            label: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Center(
              child: Text(
            "L",
            style: TextStyle(color: Colors.black),
          )),
        )),
        DataColumn(
            label: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Center(
              child: Text(
            "XL",
            style: TextStyle(color: Colors.black),
          )),
        )),
        DataColumn(
            label: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Center(
              child: Text(
            "2XL",
            style: TextStyle(color: Colors.black),
          )),
        )),
        DataColumn(
            label: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Center(
              child: Text(
            "3XL",
            style: TextStyle(color: Colors.black),
          )),
        )),
      ],
      rows: [
        ultimaFila(Colors.red),
        ultimaFila(Colors.blue),
        ultimaFila(Colors.green),
        ultimaFila(Colors.purple),
        ultimaFila(Colors.lime),
      ],
    );
  }

  ultimaFila(miColor) {
    return DataRow(cells: [
      DataCell(
        CircleAvatar(backgroundColor: miColor),
      ),
      const DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cant:',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Precio:',
            style: TextStyle(fontSize: 16),
          ),
        ],
      )),
      const DataCell(Column(
        children: [
          Text('5'),
          Text('\$890.0'),
        ],
      )),
      const DataCell(Column(
        children: [
          Text('5'),
          Text('\$890.0'),
        ],
      )),
      const DataCell(Column(
        children: [
          Text('5'),
          Text('\$890.0'),
        ],
      )),
      const DataCell(Column(
        children: [
          Text('5'),
          Text('\$890.0'),
        ],
      )),
      const DataCell(Column(
        children: [
          Text('5'),
          Text('\$890.0'),
        ],
      )),
      const DataCell(Column(
        children: [
          Text('5'),
          Text('\$890.0'),
        ],
      )),
      const DataCell(Column(
        children: [
          Text('5'),
          Text('\$890.0'),
        ],
      )),
    ]);
  }
}
