import SwiftUI

struct ContentView: View {
    
    @State var index = 0
    @State var bubbles = [Bubble]()
    @State var selectedItem = 0
    
    let offset1 = CGSize(width: -520, height: 0) /// game
    let offset2 = CGSize(width: 0, height: -360) /// AR
    let offset3 = CGSize(width: 520, height: 0) /// todo
    let offset4 = CGSize(width: 0, height: 360) /// tutorial
    
    var body: some View {
        ZStack {
            if index >= 7 {
                LinearGradient(
                    colors: [.blue, .green],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                    .hueRotation(.degrees(index >= 8 ? 180 : 0))
                    .ignoresSafeArea()
            }
            
            HStack(spacing: 30) {
                if index >= 1 {
                    Image("Logo")
                        .resizable()
                        .frame(width: 136, height: 132)
                        .cornerRadius(32)
                        .transition(.scale)
                }
                
                if index != 10 && index != 11 {
                    Text("Coding Club")
                        .gradientForeground([.blue, Color(uiColor: UIColor(hex: 0x00aeef))])
                        .font(.system(size: 136, weight: .semibold))
                }
            }
            .scaleEffect(index >= 2 ? 0.96 : 1)
            .padding(index >= 2 ? 60 : 20)
            .background {
                Color(uiColor: .systemBackground)
                    .cornerRadius(48)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 48)
                    .trim(from: 0, to: index >= 3 ? 1 : 0)
                    .stroke(
                        AngularGradient(
                            colors: [
                                .red,
                                .yellow,
                                .green,
                                .blue,
                                .red,
                            ],
                            center: .center
                        )
                        , lineWidth: 10
                    )
            )
            .scaleEffect(index == 11 ? 2 : 1)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                BackgroundView(index: index, bubbles: bubbles)
                .disabled(selectedItem != 0)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedItem = 0
                    }
                }
            }
            .transition(.scale(scale: 6).combined(with: .opacity))
            .padding(index >= 5 ? 100 : 0)
            .scaleEffect(index >= 9 ? 0.6 : 1)
            .rotation3DEffect(.degrees(getRotationDegrees()), axis: (x: 0.8, y: 0.4, z: 0.2))
            .background {
                ZStack {
                    
                    Container {
                        GameView()
                    }
                    .frame(width: 500, height: 900)
                    
                    .disabled(selectedItem != 1)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedItem = 1
                        }
                    }
                    .scaleEffect(selectedItem == 1 ? 1 : 0.7)
                    .rotation3DEffect(.degrees(selectedItem == 1 ? 0 : 10), axis: (x: 0.8, y: 0.4, z: 0.2))
                    .offset(offset1)
                    
                    Container {
                        AugmentedRealityView()
                    }
                    .frame(width: 900, height: 700)
                    .disabled(selectedItem != 2)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedItem = 2
                        }
                    }
                    
                    .scaleEffect(selectedItem == 2 ? 1 : 0.4)
                    .rotation3DEffect(.degrees(selectedItem == 2 ? 0 : 10), axis: (x: -0.8, y: 0.4, z: 0.2))
                    .offset(offset2)
                    
                    Container {
                        TodoListView()
                    }
                    
                    .disabled(selectedItem != 3)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedItem = 3
                        }
                    }
                    .frame(width: 500, height: 900)
                    .scaleEffect(selectedItem == 3 ? 1 : 0.7)
                    .rotation3DEffect(.degrees(selectedItem == 3 ? 0 : 10), axis: (x: -0.1, y: 0.5, z: -0.3))
                    .offset(offset3)
                    
                    Container {
                        TutorialView()
                    }
                    
                    .disabled(selectedItem != 4)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedItem = 4
                        }
                    }
                    .frame(width: 900, height: 700)
                    .scaleEffect(selectedItem == 4 ? 1 : 0.4)
                    .rotation3DEffect(.degrees(selectedItem == 4 ? 0 : 10), axis: (x: 0.5, y: 0.6, z: -0.2))
                    .offset(offset4)
                }
                .opacity(index >= 9 ? 1 : 0)
            }
            .offset(entireOffset())
        }
        .ignoresSafeArea()
        .onAppear {
            start()
        }
    }
    
    func entireOffset() -> CGSize {
        switch selectedItem {
        case 0:
            return .zero
        case 1:
            return CGSize(width: -offset1.width, height: -offset1.height)
        case 2:
            return CGSize(width: -offset2.width, height: -offset2.height)
        case 3:
            return CGSize(width: -offset3.width, height: -offset3.height)
        case 4:
            return CGSize(width: -offset4.width, height: -offset4.height)
        default:
            return .zero
        }
    }
    
    func nextStep(delay: CGFloat, animation: Animation = .spring()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(animation) {
                index += 1
            }
        }
    }
    
    func start() {
        nextStep(delay: 1)
        nextStep(delay: 2)
        nextStep(delay: 3, animation: .easeOut(duration: 3))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            index = 4
            
            for index in 0..<36 {
                DispatchQueue.main.asyncAfter(deadline: .now() + CGFloat(index) / 15) {
                    addBubble(colorOffset: CGFloat(index) / 18)
                }
            }
        }
        
        nextStep(delay: 5, animation: .spring(
            response: 3,
            dampingFraction: 0.7,
            blendDuration: 0.8
        ))
        
        nextStep(delay: 6)
        
        nextStep(delay: 7, animation: .spring(
            response: 3,
            dampingFraction: 0.7,
            blendDuration: 0.8
        ))
        
        nextStep(delay: 8, animation: .easeOut(duration: 6))
        nextStep(delay: 9, animation: .spring(
            response: 3,
            dampingFraction: 0.7,
            blendDuration: 0.8
        ))
        
        /// hide text
        nextStep(delay: 10, animation: .spring(
            response: 0.8,
            dampingFraction: 0.7,
            blendDuration: 0.8
        ))
        
        nextStep(delay: 11, animation: .spring(
            response: 3,
            dampingFraction: 0.7,
            blendDuration: 0.8
        ))
        
        nextStep(delay: 17, animation: .spring(
            response: 3,
            dampingFraction: 0.7,
            blendDuration: 0.8
        ))
    }
    
    func getRotationDegrees() -> CGFloat {
        if index >= 8 {
            return 10
        }
        return 0
    }
    
    func addBubble(colorOffset: CGFloat) {
        let uiColor = UIColor.systemBlue.offset(by: colorOffset)
        
        let piPercent = colorOffset * 2 * .pi
        
        let x: CGFloat
        let y: CGFloat
        let alpha: CGFloat
        
        if colorOffset >= 1 {
            x = cos(piPercent) * 340
            y = sin(piPercent) * 340
            alpha = 0.4
        } else {
            x = cos(piPercent) * 200
            y = sin(piPercent) * 200
            alpha = 8
        }
        
        let newBubble = Bubble(
            length: 300,
            offset: CGSize(
                width: x,
                height: y
            ),
            color: uiColor,
            opacity: alpha
        )
        
        withAnimation(.spring(
            response: 0.8,
            dampingFraction: 0.6,
            blendDuration: 0.8
        )) {
            bubbles.append(newBubble)
        }
    }
}

extension View {
    public func gradientForeground(_ colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
        )
            .mask(self)
    }
}

public extension UIColor {
    /**
     Create a UIColor from a hex code.
     
     Example:
     
     let color = UIColor(hex: 0x00aeef)
     */
    convenience init(hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

struct DotsView: View {
    let color: Color
    let offset: Bool
    
    var body: some View {
        HStack {
            ForEach(0..<100, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                    .offset(x: 0, y: offset ? 0 : -600)
                    .animation(
                        .spring(
                            response: 1,
                            dampingFraction: 0.1,
                            blendDuration: 1
                        )
                            .delay(Double(index) * 0.08)
                        , value: offset
                    )
            }
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    var length: CGFloat
    var offset: CGSize
    var color: UIColor
    var opacity: CGFloat
}

/// get a gradient color
extension UIColor {
    func offset(by offset: CGFloat) -> UIColor {
        let (h, s, b, a) = hsba
        var newHue = h - offset
        
        /// make it go back to positive
        while newHue <= 0 {
            newHue += 1
        }
        let normalizedHue = newHue.truncatingRemainder(dividingBy: 1)
        return UIColor(hue: normalizedHue, saturation: s, brightness: b, alpha: a)
    }
    
    var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h: h, s: s, b: b, a: a)
    }
}

struct BackgroundView: View {
    let index: Int
    let bubbles: [Bubble]
    
    var body: some View {
        if index >= 2 {
            Color.black
                .cornerRadius(index >= 5 ? 60 : 0)
                .shadow(
                    color: .black.opacity(0.3),
                    radius: 20,
                    x: 2,
                    y: 5
                )
                .overlay {
                    ZStack {
                        ForEach(bubbles) { bubble in
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(uiColor: bubble.color),
                                            Color(uiColor: bubble.color.offset(by: 0.1))
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .opacity(bubble.opacity)
                                .frame(width: bubble.length, height: bubble.length)
                                .offset(bubble.offset)
                                .transition(.scale)
                        }
                    }
                }
        }
    }
}
