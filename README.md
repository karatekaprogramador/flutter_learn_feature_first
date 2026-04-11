# Karateka TODO App

Aplicación Flutter de tareas (TODO) con autenticación.

## Arquitectura seleccionada

Este proyecto usa arquitectura **feature-first**, organizando el código por funcionalidades para facilitar escalabilidad y mantenimiento.

Estructura principal actual:

- `lib/core`: elementos compartidos (tema global, widgets reutilizables).
- `lib/features/onboarding`: flujo de onboarding.
- `lib/features/auth`: autenticación (login).

## Tema visual

El diseño sigue una línea **minimalista**, con:

- paleta de colores suaves y no agresivos,
- interfaz limpia y enfocada en legibilidad,
- componentes modernos basados en Material 3.

## Estado actual

- Onboarding implementado.
- Login implementado con validaciones básicas de formulario.
- Sistema de rutas implementado con `go_router`.
- Navegación `Onboarding -> Login` conectada con rutas por feature.
- Router central configurado en `lib/core/router/app_router.dart`.

## Features implementadas

- Arquitectura `feature-first` por módulos (`onboarding`, `auth`).
- Tema global minimalista (Material 3, colores suaves y UI limpia).
- Onboarding con páginas, indicador y CTA de avance.
- Login UI con formulario, validaciones y acciones principales.
- Enrutamiento declarativo con `go_router` (`MaterialApp.router`).

## Dependencias principales

- `go_router`
- `flutter_bloc`
- `get_it`
