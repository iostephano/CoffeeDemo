//
//  CoffeeViewer3D.swift
//  CoffeeDemo
//
//  Created by Stephano Portella on 02/10/25.
//

import SwiftUI
import RealityKit

/// Visor 3D: carga el `.usdz` indicado, lo escala a un tamaño estándar y lo hace
/// girar. Si el modelo no está en el bundle (el repo no los incluye) muestra un
/// aviso en vez de una pantalla vacía.
struct CoffeeViewer3D: View {
    let fileName: String

    @State private var model: Entity?
    @State private var status: Status = .loading
    @State private var yaw: Float = 0
    @State private var spinDirection: Float = 1

    private enum Status: Equatable {
        case loading, ready, missing
    }

    var body: some View {
        RealityView { content in
            content.add(makeCamera())
            for light in makeLights() {
                content.add(light)
            }
        } update: { content in
            guard let model else { return }
            if model.parent == nil {
                content.add(model)
            }
            model.orientation = simd_quatf(angle: yaw, axis: [0, 1, 0])
        }
        .overlay {
            switch status {
            case .loading:
                ProgressView().tint(.white)
            case .missing:
                missingModelNotice
            case .ready:
                EmptyView()
            }
        }
        // Arrastrar en horizontal cambia el sentido del giro.
        .gesture(
            DragGesture(minimumDistance: 8)
                .onChanged { spinDirection = $0.translation.width >= 0 ? 1 : -1 }
        )
        .task(id: fileName) {
            await run()
        }
    }

    private var missingModelNotice: some View {
        VStack(spacing: 8) {
            Image(systemName: "cube.transparent")
                .font(.system(size: 44))
                .foregroundStyle(.white.opacity(0.5))
            Text("Falta el modelo 3D")
                .font(.headline)
                .foregroundStyle(.white)
            Text("Añade \(fileName) a la carpeta CoffeeDemo/ (ver README).")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .padding(24)
    }

    /// Carga el modelo y, si lo consigue, lo mantiene girando hasta que la tarea
    /// se cancele (al cambiar de bebida o cerrar la vista).
    private func run() async {
        status = .loading
        model?.removeFromParent()
        model = nil
        yaw = 0

        do {
            let entity = try await Entity(named: fileName, in: nil)
            normalize(entity, targetExtent: 0.48)
            model = entity
            status = .ready
        } catch {
            status = .missing
            return
        }

        while !Task.isCancelled {
            yaw += 0.012 * spinDirection
            try? await Task.sleep(for: .milliseconds(16))
        }
    }

    /// Escala el modelo para que su lado mayor mida `targetExtent` y lo centra,
    /// subiéndolo un poco para dejar sitio a la tarjeta inferior.
    private func normalize(_ entity: Entity, targetExtent: Float) {
        let bounds = entity.visualBounds(relativeTo: nil)
        let maxExtent = max(bounds.extents.x, bounds.extents.y, bounds.extents.z)
        let scale = maxExtent > 0 ? targetExtent / maxExtent : 1
        entity.scale = SIMD3(repeating: scale)
        entity.position = -bounds.center * scale + SIMD3(0, 0.10, 0)
    }

    private func makeCamera() -> Entity {
        let camera = PerspectiveCamera()
        camera.position = [0, 0.08, 0.75]
        return camera
    }

    private func makeLights() -> [Entity] {
        let key = DirectionalLight()
        key.light.intensity = 3400
        key.orientation = simd_quatf(angle: -.pi / 4, axis: [1, 0, 0])
            * simd_quatf(angle: .pi / 6, axis: [0, 1, 0])

        let fill = DirectionalLight()
        fill.light.intensity = 1400
        fill.orientation = simd_quatf(angle: .pi / 6, axis: [1, 0, 0])
            * simd_quatf(angle: -.pi / 3, axis: [0, 1, 0])

        return [key, fill]
    }
}
