import "package:go_router/go_router.dart";
import "package:showroom_maqueta/pages/agregar_a_pedido.dart";
import "package:showroom_maqueta/pages/buscador_cliente.dart";
import "package:showroom_maqueta/pages/login.dart";
import "package:showroom_maqueta/pages/nuevo_pedido.dart";
import "package:showroom_maqueta/pages/pagina_cliente.dart";
import "package:showroom_maqueta/pages/pedido_interno.dart";
import "package:showroom_maqueta/pages/product_page.dart";
import "package:showroom_maqueta/pages/seleccion_origen.dart";
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/select_origin',
      name: SeleccionOrigen.name,
      builder: (context, state) => const SeleccionOrigen(),
    ),
    GoRoute(
      path: '/product_page',
      builder: (context, state) => const ProductPage()
    ),
    GoRoute(
      path: '/product_add',
      builder: (context, state) => const AgregarPedido(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginNew(),
    ),
    GoRoute(
      path: '/client_search',
      builder: (context, state) => const BuscadorCliente(),
    ),
    GoRoute(
      path: '/client_page',
      builder: (context, state) => const PaginaCliente(),
    ),
    GoRoute(
      path: '/pedidoInterno',
      builder: (context, state) => const PedidoInterno(),
    ),
    GoRoute(
      path: '/nuevoPedido',
      builder: (context, state) => const NuevoPedido(),
    ),
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => const VersionCheckPage(),
    // ),
    // GoRoute(
    //   path: '/dashboard',
    //   builder: (context, state) => const DashboardPage(),
    // ),

  ]
);