//
//  AugmentedRealityView.swift
//  SwiftPlaygrounds
//
//  Created by A. Zheng (github.com/aheze) on 1/10/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//


import SwiftUI
import ARKit

class ARViewModel: ObservableObject {
    var addText: (() -> Void)?
    var addSphere: (() -> Void)?
    var addSprinkler: (() -> Void)?
    var clear: (() -> Void)?
    var resume: ((Bool) -> Void)?
}

struct AugmentedRealityButton: View {
    var image: String
    var text: String
    let action: (() -> Void)
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: image)
                    .foregroundColor(.purple)
                    .font(.title2)
                
                Text(text)
                    .foregroundColor(Color(uiColor: .label))
            }
            .font(.title3)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(16)
        }
    }
}
struct AugmentedRealityView: View {
    let focused: Bool
    @StateObject var model = ARViewModel()

    
    var body: some View {
        VStack(spacing: 0) {
            ARViewControllerRepresentable(model: model)
                .ignoresSafeArea()
                .overlay(alignment: .topTrailing) {
                    Button {
                        model.clear?()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .frame(width: 64, height: 64)
                            .background(.white.opacity(0.3))
                            .cornerRadius(32)
                            .padding()
                    }
                }
            
            HStack {
                AugmentedRealityButton(image: "textformat", text: "Text") {
                    model.addText?()
                }
                AugmentedRealityButton(image: "circle.fill", text: "Sphere") {
                    model.addSphere?()
                }
                AugmentedRealityButton(image: "capsule.righthalf.filled", text: "Sprinkler") {
                    model.addSprinkler?()
                }
            }
            .frame(height: 80)
            .padding()
            .background(
                Color(uiColor: .secondarySystemBackground)
            )
        }
        .onChange(of: focused) { newValue in
            model.resume?(newValue)
        }
    }
}

struct ARViewControllerRepresentable: UIViewControllerRepresentable {
    
    @ObservedObject var model: ARViewModel
    
    func makeUIViewController(context: Context) -> ARViewController {
        return ARViewController(model: model)
    }
    
    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {
        
    }
}

class ARViewController: UIViewController, ARSCNViewDelegate {
    var model: ARViewModel
    var sceneView: ARSCNView!
    var nodes = [SCNNode]()
    
    let configuration = ARWorldTrackingConfiguration()
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: ARViewModel) {
        self.model = model
        self.configuration.planeDetection = .horizontal
        
        super.init(nibName: nil, bundle: nil)
        
        model.clear = { [weak self] in
            guard let self = self else { return }
            for node in self.nodes {
                node.removeFromParentNode()
            }
        }
        
        model.resume = { [weak self] resume in
            guard let self = self else { return }
            if resume {
                self.sceneView.session.run(self.configuration)
            } else {
                self.sceneView.session.pause()
            }
        }
        
        model.addText = { [weak self] in
            guard let self = self else { return }
            if let position = self.getPosition() {
                let textGeometry = SCNText(string: "Coding Club", extrusionDepth: 0.8)
                textGeometry.font = UIFont.systemFont(ofSize: 18, weight: .medium)
                textGeometry.firstMaterial?.diffuse.contents = UIColor.systemBlue
                
                let node = SCNNode(geometry: textGeometry)
                let lookAtConstraint = SCNBillboardConstraint()
                node.constraints = [lookAtConstraint]
                node.position = SCNVector3(
                    x: position.x,
                    y: position.y,
                    z: position.z
                )
                node.scale = SCNVector3(0.006, 0.006, 0.006)
                self.nodes.append(node)
                self.sceneView.scene.rootNode.addChildNode(node)
            }
        }
        
        model.addSphere = { [weak self] in
            guard let self = self else { return }
            if let position = self.getPosition() {
                let sphereGeometry = SCNSphere(radius: 0.06)
                sphereGeometry.firstMaterial?.diffuse.contents = UIColor.green
                
                let node = SCNNode(geometry: sphereGeometry)
                node.position = SCNVector3(
                    x: position.x,
                    y: position.y,
                    z: position.z
                )
                self.nodes.append(node)
                self.sceneView.scene.rootNode.addChildNode(node)
            }
        }
        model.addSprinkler = { [weak self] in
            guard let self = self else { return }
            if let position = self.getPosition() {
                let cylinderGeometry = SCNCylinder(radius: 0.06, height: 0.1)
                cylinderGeometry.firstMaterial?.diffuse.contents = UIColor.gray
                
                let cylinderNode = SCNNode(geometry: cylinderGeometry)
                cylinderNode.position = SCNVector3(
                    x: position.x,
                    y: position.y,
                    z: position.z
                )
                
                let particleSystem = SCNParticleSystem()
                particleSystem.birthRate = 80
                particleSystem.particleSize = 0.01
                particleSystem.particleLifeSpan = 2
                particleSystem.particleColor = .green
                particleSystem.particleVelocity = 5
                particleSystem.spreadingAngle = 10
                particleSystem.isAffectedByGravity = true
                particleSystem.particleColorVariation = SCNVector4(0.25, 0, 0, 0)
                
                
                let particlesNode = SCNNode()
                particlesNode.position = SCNVector3(
                    x: position.x,
                    y: position.y + 0.1,
                    z: position.z
                )
                particlesNode.addParticleSystem(particleSystem)
                self.nodes.append(cylinderNode)
                self.nodes.append(particlesNode)
                self.sceneView.scene.rootNode.addChildNode(cylinderNode)
                self.sceneView.scene.rootNode.addChildNode(particlesNode)
            }
        }
        
    }
    
    var crosshairImageView: UIImageView!
    
    override func loadView() {
        super.loadView()
        view = UIView()
        view.backgroundColor = .black
        
        self.sceneView = ARSCNView()
        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.rightAnchor.constraint(equalTo: view.rightAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sceneView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 36)
        let image = UIImage(systemName: "plus", withConfiguration: configuration)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        crosshairImageView = UIImageView(image: image)
        view.addSubview(crosshairImageView)
        crosshairImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            crosshairImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crosshairImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.session.run(configuration)
    }
    
    func getPosition() -> simd_float4? {
        let touchLocation = self.crosshairImageView.center
        let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if let hitResult = results.first {
            let position = hitResult.worldTransform.columns.3
            return position
        }
        return nil
    }
}
