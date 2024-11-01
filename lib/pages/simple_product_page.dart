import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:showroom_maqueta/models/product.dart';
import 'package:showroom_maqueta/providers/item_provider.dart';
import 'package:showroom_maqueta/services/product_services.dart';

class PaginaSimpleProducto extends StatefulWidget {
  const PaginaSimpleProducto({super.key});

  @override
  State<PaginaSimpleProducto> createState() => _PaginaSimpleProductoState();
}

class _PaginaSimpleProductoState extends State<PaginaSimpleProducto> {
  late String raiz = '';
  Product productoNuevo = Product.empty();
  late String almacen = '';
  late String token = '';
  late int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
    cargarDatos();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  cargarDatos() async {
    almacen = context.read<ItemProvider>().almacen;
    token = context.read<ItemProvider>().token;
    raiz = context.read<ItemProvider>().raiz;
    productoNuevo = await ProductServices().getSingleProductByRaiz(raiz, almacen, token);
    setState(() {});
  }

  void _scrollToIndex(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          raiz,
          style: TextStyle(
            color: colores.onPrimary,
          ),
        ),
        backgroundColor: colores.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (productoNuevo.imagenes.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                productoNuevo.descripcion,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: PhotoViewGallery.builder(
                    itemCount: productoNuevo.imagenes.length,
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(productoNuevo.imagenes[index]),
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    pageController: _pageController,
                    scrollPhysics: const BouncingScrollPhysics(),
                    backgroundDecoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(productoNuevo.imagenes.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      _scrollToIndex(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        width: 16.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentIndex == index ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ] else ...[
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Cargando...'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}