# CoffeeDemo — Carta de cafés en 3D con RealityKit

CoffeeDemo es una app de iOS que muestra una carta de bebidas donde cada una se ve
como un modelo 3D girando sobre fondo negro, con una tarjeta inferior que lista
ingredientes, notas y precio, y flechas para pasar de una a otra. Existe como proyecto
de portafolio para mostrar cómo se carga y presenta contenido 3D en iOS con
`RealityView` y `async/await`, cómo se normaliza y anima un modelo cargado en runtime,
y cómo se separa la lógica de navegación en un tipo de valor probado.

> **Los modelos 3D no vienen en el repo.** Los `.usdz` que usaba la demo son assets de
> terceros y no se pueden redistribuir. Ver [Cómo probar la app](#cómo-probar-la-app).

<img width="1257" height="677" alt="CoffeeDemo" src="https://github.com/user-attachments/assets/cbdb41eb-2115-4fd7-8bff-879f0b0690d3" />

---

## Tecnologías usadas

- Swift 6 (aislamiento por defecto en `MainActor`, concurrencia estricta)
- SwiftUI
- RealityKit / `RealityView` para el visor 3D
- `async/await` para la carga de modelos (sin Combine)
- Swift Testing para las pruebas
- Integración continua con GitHub Actions (compila y corre los tests en cada push/PR)
- Cero dependencias externas

---

## Cómo está organizado el proyecto

```
CoffeeDemo/
├── CoffeeDemoApp.swift
├── Models/
│   ├── CoffeeItem.swift          # Una bebida: ficha + nombre del .usdz
│   └── MenuNavigator.swift       # Recorrido cíclico de la carta (puro, testeado)
└── Views/
    ├── ContentView.swift         # Compone el visor + el título + la tarjeta
    ├── CoffeeCard.swift          # Tarjeta inferior con la ficha y prev/next
    └── CoffeeViewer3D.swift      # RealityView: carga, escala, gira, y avisa si falta el modelo
```

`CoffeeItem` y `MenuNavigator` no dependen de RealityKit ni de SwiftUI, y son lo que
cubren las pruebas.

---

## Cómo funciona / flujo principal

1. `ContentView` arranca un `MenuNavigator` con las cuatro bebidas de `CoffeeItem.menu`.
2. Para la bebida actual, `CoffeeViewer3D` recibe el nombre de su `.usdz` y lanza una
   tarea (`.task(id:)`) que hace `try await Entity(named:)`.
3. Si el modelo carga: se escala para que su lado mayor mida un tamaño fijo, se centra,
   y un bucle `async` lo hace girar en el eje Y frame a frame. Arrastrar en horizontal
   cambia el sentido del giro.
4. Si el modelo **no está en el bundle**: en vez de una pantalla vacía, se muestra un
   aviso indicando qué archivo falta.
5. Las flechas de la tarjeta llaman a `navigator.next()` / `navigator.previous()`, que
   recorren la carta de forma cíclica; al cambiar de bebida, la tarea anterior se
   cancela y empieza la nueva carga.

---

## Funcionalidades / qué demuestra

- Carga de modelos `.usdz` en runtime con `async/await` y `RealityView` (sin el
  `ARView` + `UIViewRepresentable` de la versión anterior, ni `loadAsync` deprecado).
- Normalización de un modelo de tamaño arbitrario a un encuadre estándar
  (`visualBounds` → escala y centro).
- Rotación continua dirigida por una tarea `async`, con inversión por gesto.
- Estado de carga explícito: cargando / listo / modelo ausente.
- Iluminación propia (luz principal + de relleno) para que el modelo no se vea plano.
- Navegación cíclica aislada en `MenuNavigator`, un tipo de valor puro y probado.

---

## Pruebas

`CoffeeDemoTests` (Swift Testing):

- **`MenuNavigator`**: empieza en el primer elemento; `next` avanza y da la vuelta;
  `previous` retrocede y da la vuelta; `next` seguido de `previous` vuelve al mismo
  sitio; un índice inicial fuera de rango se recorta; una lista vacía no rompe y no
  tiene elemento actual.
- **`CoffeeItem.menu`**: cuatro bebidas; cada una apunta a un `.usdz` distinto; todas
  tienen título, precio y al menos un ingrediente; el `id` es el nombre de archivo.

Correr los tests:

```bash
xcodebuild test \
  -project CoffeeDemo.xcodeproj \
  -scheme CoffeeDemo \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

---

## Cómo probar la app

El repo **no incluye los modelos 3D**. La app compila, arranca y funciona sin ellos:
muestra un aviso de "falta el modelo" en el visor. Para verla con bebidas reales:

1. Consigue cuatro modelos `.usdz` (por ejemplo de la
   [galería de AR Quick Look de Apple](https://developer.apple.com/augmented-reality/quick-look/),
   [Poly Haven](https://polyhaven.com) o modelos con licencia CC0 en Sketchfab).
2. Renómbralos exactamente así y colócalos en `CoffeeDemo/CoffeeDemo/`:
   - `caffe_latte.usdz`
   - `Double_Hot_Chocolate.usdz`
   - `Nutella_Milkshake.usdz`
   - `vanilla_iced_latte.usdz`
3. Abre `CoffeeDemo.xcodeproj` con **Xcode 26** (ver `.xcode-version`), elige un
   simulador de iPhone (objetivo mínimo iOS 26) y ejecuta.

Los nombres viven en `CoffeeItem.menu`; si prefieres otros modelos, cambia ahí los
`fileName`.

---

## Cosas pendientes o limitadas (a propósito)

- **Sin modelos en el repo** (assets de terceros). El visor tiene un estado de "modelo
  ausente" precisamente para esto.
- **La cámara y las luces son fijas.** No hay zoom ni control de encuadre; el arrastre
  solo invierte el giro, no orbita.
- **El giro lo dirige una tarea `async` a ~60 Hz** que actualiza estado de SwiftUI. Es
  suficiente para un modelo; para una escena con muchos objetos convendría un
  `System` de RealityKit.
- **La carta está fija en código** (`CoffeeItem.menu`): no se carga de red ni de disco.
- **Sin carrito ni pantalla de detalle**: el foco es el visor 3D y la navegación.

---

## Autor

Stephano Portella
