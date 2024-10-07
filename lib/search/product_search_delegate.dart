
// // ignore_for_file: overridden_fields

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:showroom_maqueta/providers/item_provider.dart';

// import '../models/product.dart';
// import '../services/product_services.dart';

// class ProductSearchDelegate extends SearchDelegate{

//   @override
//   final String searchFieldLabel;
//   final List<Product> historial;
//   ProductSearchDelegate(this.searchFieldLabel, this.historial);



//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return[
//       IconButton(
//         onPressed: ()=>query='', 
//         icon: const Icon(Icons.clear)
//       ),
//     ];
    
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//    return IconButton(
//     onPressed: ()=>close(context, null), 
//     icon: const Icon(Icons.arrow_back_ios_new),
//   );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
    
//     if(query.trim().isEmpty){
//       return const Text('No hay valor en el query');
//     }

//     final productServices = ProductServices();
//     final almacen = context.watch<ItemProvider>().almacen;
//     final token1 = context.watch<ItemProvider>().token;

//     return FutureBuilder(
      
//       future: productServices.getProductByName(query, almacen, token1 ),
//       builder: (_, AsyncSnapshot snapshot){

//         if(snapshot.hasError){
//           return const ListTile(title: Text('no hay ningun producto con ese termino'),);
//         }

//         if(snapshot.hasData){
//           return _showProducts(snapshot.data);
//         }else{
//           return const Center(child: CircularProgressIndicator(strokeWidth: 4),);
//         }

//       }

      
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
    
//     return _showProducts(historial);
//   }

//   Widget _showProducts(List<Product> products){

//     return ListView.builder(
//       itemCount: products.length,
//       itemBuilder: (context, i){

//         final producto = products[i];
//         return ListTile(
//           title: Text(producto.descripcion.toString()),
//           subtitle: Text(producto.raiz.toString()),
//           trailing: SizedBox(
//             width: MediaQuery.of(context).size.width/1.5,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(producto.precioVentaActual.toString()),
//                 const Icon(Icons.chevron_right)
//               ],
//             ),
//           ),
//           onTap: (){
//             close(context, producto);
//           },
//         );
//       }
//     );


//   }

 
// }