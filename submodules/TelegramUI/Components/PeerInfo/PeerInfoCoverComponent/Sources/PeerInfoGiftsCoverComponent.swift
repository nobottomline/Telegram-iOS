import Foundation
import UIKit
import AsyncDisplayKit
import Display
import ComponentFlow
import ComponentDisplayAdapters
import AnimationCache
import MultiAnimationRenderer
import TelegramCore
import AccountContext
import SwiftSignalKit
import EmojiTextAttachmentView
import LokiRng
import TextFormat
import HierarchyTrackingLayer

// MARK: - GuGram Custom Gift Layer
private final class GuGramCustomGiftLayer: SimpleLayer {
    private let size: CGSize
    private let customGift: GuGramSettings.GuGramCustomGift
    private var glowing: Bool

    private var currentAnimationStyle: Int32 = -1
    private var currentAnimationIndex: Int = -1

    let shadowLayer = SimpleLayer()
    let starsLayer: CAEmitterLayer
    let iconLayer = SimpleLayer()

    init(customGift: GuGramSettings.GuGramCustomGift, size: CGSize, glowing: Bool) {
        self.size = size
        self.customGift = customGift
        self.glowing = glowing
        self.starsLayer = CAEmitterLayer()

        super.init()
        self.setupLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(layer: Any) {
        guard let layer = layer as? GuGramCustomGiftLayer else {
            fatalError()
        }
        self.size = layer.size
        self.customGift = layer.customGift
        self.glowing = layer.glowing
        self.starsLayer = CAEmitterLayer()
        super.init()
        self.setupLayers()
    }

    private static func generateGlowImage(size: CGSize, color: UIColor) -> UIImage? {
        return generateImage(size, rotatedContext: { contextSize, context in
            context.clear(CGRect(origin: .zero, size: contextSize))

            var locations: [CGFloat] = [0.0, 0.3, 1.0]
            let colors: [CGColor] = [color.withAlphaComponent(0.65).cgColor, color.withAlphaComponent(0.65).cgColor, color.withAlphaComponent(0.0).cgColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: &locations)!
            context.drawRadialGradient(gradient, startCenter: CGPoint(x: contextSize.width / 2.0, y: contextSize.height / 2.0), startRadius: 0.0, endCenter: CGPoint(x: contextSize.width / 2.0, y: contextSize.height / 2.0), endRadius: contextSize.width / 2.0, options: .drawsAfterEndLocation)
        })
    }

    private func setupParticles(color: UIColor) {
        let emitter = CAEmitterCell()
        emitter.name = "customGiftParticle"
        emitter.contents = UIImage(bundleImageName: "Premium/Stars/Particle")?.cgImage
        emitter.birthRate = 6.0
        emitter.lifetime = 2.0
        emitter.velocity = 0.1
        emitter.scale = (size.width / 40.0) * 0.12
        emitter.scaleRange = 0.02
        emitter.alphaRange = 0.1
        emitter.emissionRange = .pi * 2.0

        let staticColors: [Any] = [
            color.withAlphaComponent(0.0).cgColor,
            color.withAlphaComponent(0.58).cgColor,
            color.withAlphaComponent(0.58).cgColor,
            color.withAlphaComponent(0.0).cgColor
        ]
        let staticColorBehavior = CAEmitterCell.createEmitterBehavior(type: "colorOverLife")
        staticColorBehavior.setValue(staticColors, forKey: "colors")
        emitter.setValue([staticColorBehavior], forKey: "emitterBehaviors")

        self.starsLayer.emitterCells = [emitter]
        self.starsLayer.emitterShape = .circle
        self.starsLayer.emitterMode = .surface
    }

    private func setupGradientIcon() {
        let innerColor = UIColor(rgb: UInt32(bitPattern: customGift.innerColor))
        let outerColor = UIColor(rgb: UInt32(bitPattern: customGift.outerColor))
        let patternColor = UIColor(rgb: UInt32(bitPattern: customGift.patternColor)).withAlphaComponent(0.25)

        // Create gradient background for the icon
        let gradientImage = generateImage(size, rotatedContext: { contextSize, context in
            context.clear(CGRect(origin: .zero, size: contextSize))

            let colors: [CGColor] = [innerColor.cgColor, outerColor.cgColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            var locations: [CGFloat] = [0.0, 1.0]
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: &locations)!

            // Draw circular gradient
            let center = CGPoint(x: contextSize.width / 2.0, y: contextSize.height / 2.0)
            let radius = min(contextSize.width, contextSize.height) / 2.0

            context.addEllipse(in: CGRect(origin: .zero, size: contextSize))
            context.clip()
            context.drawRadialGradient(gradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: [])

            // Draw subtle pattern overlay
            GuGramCustomGiftLayer.drawPatternOverlay(
                in: context,
                size: contextSize,
                color: patternColor,
                patternId: customGift.patternId
            )

            // Draw ribbon and text
            if let ribbonText = customGift.ribbonText, !ribbonText.isEmpty {
                let textColor = UIColor(rgb: UInt32(bitPattern: customGift.textColor))
                let font = UIFont.systemFont(ofSize: contextSize.width * 0.36, weight: .bold)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: textColor
                ]
                let textSize = ribbonText.size(withAttributes: attributes)
                let padding = contextSize.width * 0.08
                let ribbonWidth = min(contextSize.width * 0.9, textSize.width + padding * 2.0)
                let ribbonHeight = textSize.height + padding * 0.8
                let ribbonRect = CGRect(
                    x: (contextSize.width - ribbonWidth) / 2.0,
                    y: contextSize.height * 0.62,
                    width: ribbonWidth,
                    height: ribbonHeight
                )

                let ribbonColor = UIColor(rgb: UInt32(bitPattern: customGift.ribbonColor))
                let ribbonPath = UIBezierPath(roundedRect: ribbonRect, cornerRadius: ribbonRect.height * 0.3)
                context.setFillColor(ribbonColor.cgColor)
                context.addPath(ribbonPath.cgPath)
                context.fillPath()

                let textRect = CGRect(
                    x: ribbonRect.midX - textSize.width / 2.0,
                    y: ribbonRect.midY - textSize.height / 2.0,
                    width: textSize.width,
                    height: textSize.height
                )
                ribbonText.draw(in: textRect, withAttributes: attributes)
            }
        })

        self.iconLayer.contents = gradientImage?.cgImage
    }

    override func layoutSublayers() {
        super.layoutSublayers()
        self.shadowLayer.frame = CGRect(origin: .zero, size: self.bounds.size).insetBy(dx: -8.0, dy: -8.0)
        self.iconLayer.frame = CGRect(origin: .zero, size: self.bounds.size)

        let side = floor(self.size.width * 1.25)
        let starsFrame = CGSize(width: side, height: side).centered(in: CGRect(origin: .zero, size: self.bounds.size))
        self.starsLayer.frame = starsFrame
        self.starsLayer.emitterSize = starsFrame.size
        self.starsLayer.emitterPosition = CGPoint(x: starsFrame.width / 2.0, y: starsFrame.height / 2.0)
    }

    func startAnimations(index: Int) {
        self.applyAnimationStyle(style: 1, index: index, enabled: true)
    }

    func updateGlowing(_ glowing: Bool) {
        if self.glowing != glowing {
            self.glowing = glowing
        }
        self.shadowLayer.opacity = (self.glowing && customGift.glowEnabled) ? 1.0 : 0.0
    }

    func applyAnimationStyle(style: Int32, index: Int, enabled: Bool) {
        if !enabled {
            self.clearAnimations()
            self.currentAnimationStyle = -1
            self.currentAnimationIndex = -1
            return
        }
        if self.currentAnimationStyle == style && self.currentAnimationIndex == index {
            return
        }
        self.currentAnimationStyle = style
        self.currentAnimationIndex = index
        self.clearAnimations()

        let beginTime = CACurrentMediaTime() + Double(index) * 0.18

        switch style {
        case 0:
            break
        case 2:
            self.addOrbitAnimation(beginTime: beginTime)
        case 3:
            self.addPulseAnimation(beginTime: beginTime)
        case 4:
            self.addBounceAnimation(beginTime: beginTime)
        default:
            self.addFloatingAnimation(beginTime: beginTime)
        }
    }

    private func setupLayers() {
        let glowColor = UIColor(rgb: UInt32(bitPattern: customGift.glowColor))
        self.shadowLayer.contents = GuGramCustomGiftLayer.generateGlowImage(size: CGSize(width: 44.0, height: 44.0), color: glowColor)?.cgImage
        self.shadowLayer.opacity = (glowing && customGift.glowEnabled) ? 1.0 : 0.0

        if customGift.particlesEnabled {
            setupParticles(color: UIColor(rgb: UInt32(bitPattern: customGift.particleColor)))
        } else {
            self.starsLayer.emitterCells = nil
        }

        setupGradientIcon()

        self.addSublayer(self.shadowLayer)
        self.addSublayer(self.starsLayer)
        self.addSublayer(self.iconLayer)
    }

    private func clearAnimations() {
        self.removeAnimation(forKey: "hover")
        self.removeAnimation(forKey: "orbitX")
        self.removeAnimation(forKey: "orbitY")
        self.removeAnimation(forKey: "bounce")
        self.iconLayer.removeAnimation(forKey: "wiggle")
        self.iconLayer.removeAnimation(forKey: "pulse")
        self.shadowLayer.removeAnimation(forKey: "glow")
        self.shadowLayer.removeAnimation(forKey: "pulse")
    }

    private func addFloatingAnimation(beginTime: CFTimeInterval) {
        let upDistance = CGFloat.random(in: 1.0 ..< 2.0)
        let downDistance = CGFloat.random(in: 1.0 ..< 2.0)
        let hoverDuration = TimeInterval.random(in: 3.2 ..< 4.4)

        let hoverAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        hoverAnimation.duration = hoverDuration
        hoverAnimation.fromValue = -upDistance
        hoverAnimation.toValue = downDistance
        hoverAnimation.autoreverses = true
        hoverAnimation.repeatCount = .infinity
        hoverAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        hoverAnimation.beginTime = beginTime
        hoverAnimation.isAdditive = true
        self.add(hoverAnimation, forKey: "hover")

        let fromRotationAngle = CGFloat.random(in: 0.02 ..< 0.045)
        let toRotationAngle = CGFloat.random(in: 0.02 ..< 0.045)
        let wiggleDuration = TimeInterval.random(in: 2.2 ..< 3.2)

        let wiggleAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        wiggleAnimation.duration = wiggleDuration
        wiggleAnimation.fromValue = -fromRotationAngle
        wiggleAnimation.toValue = toRotationAngle
        wiggleAnimation.autoreverses = true
        wiggleAnimation.repeatCount = .infinity
        wiggleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        wiggleAnimation.beginTime = beginTime
        wiggleAnimation.isAdditive = true
        self.iconLayer.add(wiggleAnimation, forKey: "wiggle")

        if customGift.glowEnabled {
            let glowDuration = TimeInterval.random(in: 2.0 ..< 3.0)
            let glowAnimation = CABasicAnimation(keyPath: "transform.scale")
            glowAnimation.duration = glowDuration
            glowAnimation.fromValue = 1.0
            glowAnimation.toValue = 1.2
            glowAnimation.autoreverses = true
            glowAnimation.repeatCount = .infinity
            glowAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            glowAnimation.beginTime = beginTime
            self.shadowLayer.add(glowAnimation, forKey: "glow")
        }
    }

    private func addOrbitAnimation(beginTime: CFTimeInterval) {
        let radius = max(2.0, self.size.width * 0.14)
        let steps = 48
        var valuesX: [CGFloat] = []
        var valuesY: [CGFloat] = []
        valuesX.reserveCapacity(steps)
        valuesY.reserveCapacity(steps)
        for i in 0 ..< steps {
            let angle = Double(2.0 * CGFloat.pi * CGFloat(i) / CGFloat(steps))
            valuesX.append(CGFloat(cos(angle)) * radius)
            valuesY.append(CGFloat(sin(angle)) * radius)
        }

        let duration = TimeInterval.random(in: 4.0 ..< 6.0)
        let animationX = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animationX.values = valuesX
        animationX.duration = duration
        animationX.repeatCount = .infinity
        animationX.beginTime = beginTime
        animationX.timingFunction = CAMediaTimingFunction(name: .linear)
        animationX.isAdditive = true

        let animationY = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animationY.values = valuesY
        animationY.duration = duration
        animationY.repeatCount = .infinity
        animationY.beginTime = beginTime
        animationY.timingFunction = CAMediaTimingFunction(name: .linear)
        animationY.isAdditive = true

        self.add(animationX, forKey: "orbitX")
        self.add(animationY, forKey: "orbitY")

        if customGift.glowEnabled {
            let pulse = CABasicAnimation(keyPath: "opacity")
            pulse.fromValue = 0.6
            pulse.toValue = 1.0
            pulse.duration = TimeInterval.random(in: 1.6 ..< 2.4)
            pulse.autoreverses = true
            pulse.repeatCount = .infinity
            pulse.beginTime = beginTime
            self.shadowLayer.add(pulse, forKey: "pulse")
        }
    }

    private func addPulseAnimation(beginTime: CFTimeInterval) {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.fromValue = 0.6
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = TimeInterval.random(in: 1.4 ..< 2.1)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.beginTime = beginTime
        self.iconLayer.add(pulseAnimation, forKey: "pulse")

        if customGift.glowEnabled {
            let glowAnimation = CABasicAnimation(keyPath: "transform.scale")
            glowAnimation.duration = TimeInterval.random(in: 1.8 ..< 2.6)
            glowAnimation.fromValue = 0.9
            glowAnimation.toValue = 1.25
            glowAnimation.autoreverses = true
            glowAnimation.repeatCount = .infinity
            glowAnimation.beginTime = beginTime
            self.shadowLayer.add(glowAnimation, forKey: "glow")
        }
    }

    private func addBounceAnimation(beginTime: CFTimeInterval) {
        let bounceDistance = CGFloat.random(in: 3.0 ..< 5.0)
        let bounceDuration = TimeInterval.random(in: 1.8 ..< 2.4)

        let bounceAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        bounceAnimation.duration = bounceDuration
        bounceAnimation.fromValue = -bounceDistance
        bounceAnimation.toValue = bounceDistance
        bounceAnimation.autoreverses = true
        bounceAnimation.repeatCount = .infinity
        bounceAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        bounceAnimation.beginTime = beginTime
        bounceAnimation.isAdditive = true
        self.add(bounceAnimation, forKey: "bounce")
    }

    private enum GiftPatternStyle {
        case dots
        case diagonalStripes
        case grid
        case waves
    }

    private static func drawPatternOverlay(in context: CGContext, size: CGSize, color: UIColor, patternId: String) {
        let style: GiftPatternStyle
        if patternId.contains("wave") {
            style = .waves
        } else if patternId.contains("circuit") || patternId.contains("diamond") || patternId.contains("crown") {
            style = .grid
        } else if patternId.contains("flame") || patternId.contains("leaf") {
            style = .diagonalStripes
        } else {
            style = .dots
        }

        context.saveGState()
        context.setFillColor(color.cgColor)
        context.setStrokeColor(color.cgColor)

        switch style {
        case .dots:
            let spacing = max(6.0, size.width * 0.22)
            let radius = max(1.0, size.width * 0.03)
            var y: CGFloat = spacing * 0.5
            while y < size.height {
                var x: CGFloat = spacing * 0.5
                while x < size.width {
                    context.addEllipse(in: CGRect(x: x - radius, y: y - radius, width: radius * 2.0, height: radius * 2.0))
                    context.fillPath()
                    x += spacing
                }
                y += spacing
            }
        case .diagonalStripes:
            let spacing = max(6.0, size.width * 0.18)
            context.setLineWidth(max(1.0, size.width * 0.03))
            var offset: CGFloat = -size.height
            while offset < size.width {
                context.move(to: CGPoint(x: offset, y: 0.0))
                context.addLine(to: CGPoint(x: offset + size.height, y: size.height))
                context.strokePath()
                offset += spacing
            }
        case .grid:
            let spacing = max(6.0, size.width * 0.2)
            context.setLineWidth(max(0.8, size.width * 0.02))
            var x: CGFloat = spacing
            while x < size.width {
                context.move(to: CGPoint(x: x, y: 0.0))
                context.addLine(to: CGPoint(x: x, y: size.height))
                context.strokePath()
                x += spacing
            }
            var y: CGFloat = spacing
            while y < size.height {
                context.move(to: CGPoint(x: 0.0, y: y))
                context.addLine(to: CGPoint(x: size.width, y: y))
                context.strokePath()
                y += spacing
            }
        case .waves:
            let waveHeight = max(1.0, size.width * 0.04)
            let waveLength = max(8.0, size.width * 0.28)
            context.setLineWidth(max(0.8, size.width * 0.02))
            var y: CGFloat = waveHeight * 2.0
            while y < size.height {
                var x: CGFloat = 0.0
                context.move(to: CGPoint(x: x, y: y))
                while x <= size.width {
                    let angle = Double((x / waveLength) * .pi * 2.0)
                    let dy = CGFloat(sin(angle)) * waveHeight
                    context.addLine(to: CGPoint(x: x, y: y + dy))
                    x += 4.0
                }
                context.strokePath()
                y += waveHeight * 3.0
            }
        }
        context.restoreGState()
    }
}

public final class PeerInfoGiftsCoverComponent: Component {
    public let context: AccountContext
    public let peerId: EnginePeer.Id
    public let giftsContext: ProfileGiftsContext
    public let hasBackground: Bool
    public let avatarCenter: CGPoint
    public let avatarSize: CGSize
    public let defaultHeight: CGFloat
    public let avatarTransitionFraction: CGFloat
    public let statusBarHeight: CGFloat
    public let topLeftButtonsSize: CGSize
    public let topRightButtonsSize: CGSize
    public let titleWidth: CGFloat
    public let bottomHeight: CGFloat
    public let action: (ProfileGiftsContext.State.StarGift) -> Void
    
    public init(
        context: AccountContext,
        peerId: EnginePeer.Id,
        giftsContext: ProfileGiftsContext,
        hasBackground: Bool,
        avatarCenter: CGPoint,
        avatarSize: CGSize,
        defaultHeight: CGFloat,
        avatarTransitionFraction: CGFloat,
        statusBarHeight: CGFloat,
        topLeftButtonsSize: CGSize,
        topRightButtonsSize: CGSize,
        titleWidth: CGFloat,
        bottomHeight: CGFloat,
        action: @escaping (ProfileGiftsContext.State.StarGift) -> Void
    ) {
        self.context = context
        self.peerId = peerId
        self.giftsContext = giftsContext
        self.hasBackground = hasBackground
        self.avatarCenter = avatarCenter
        self.avatarSize = avatarSize
        self.defaultHeight = defaultHeight
        self.avatarTransitionFraction = avatarTransitionFraction
        self.statusBarHeight = statusBarHeight
        self.topLeftButtonsSize = topLeftButtonsSize
        self.topRightButtonsSize = topRightButtonsSize
        self.titleWidth = titleWidth
        self.bottomHeight = bottomHeight
        self.action = action
    }
    
    public static func ==(lhs: PeerInfoGiftsCoverComponent, rhs: PeerInfoGiftsCoverComponent) -> Bool {
        if lhs.context !== rhs.context {
            return false
        }
        if lhs.peerId != rhs.peerId {
            return false
        }
        if lhs.hasBackground != rhs.hasBackground {
            return false
        }
        if lhs.avatarCenter != rhs.avatarCenter {
            return false
        }
        if lhs.avatarSize != rhs.avatarSize {
            return false
        }
        if lhs.defaultHeight != rhs.defaultHeight {
            return false
        }
        if lhs.avatarTransitionFraction != rhs.avatarTransitionFraction {
            return false
        }
        if lhs.statusBarHeight != rhs.statusBarHeight {
            return false
        }
        if lhs.topLeftButtonsSize != rhs.topLeftButtonsSize {
            return false
        }
        if lhs.topRightButtonsSize != rhs.topRightButtonsSize {
            return false
        }
        if lhs.titleWidth != rhs.titleWidth {
            return false
        }
        if lhs.bottomHeight != rhs.bottomHeight {
            return false
        }
        return true
    }
    
    public final class View: UIView {
        private var currentSize: CGSize?
        private var component: PeerInfoGiftsCoverComponent?
        private var state: EmptyComponentState?

        private var giftsDisposable: Disposable?
        private var gifts: [ProfileGiftsContext.State.StarGift] = []
        private var appliedGiftIds: [Int64] = []

        private var iconLayers: [AnyHashable: GiftIconLayer] = [:]
        private var iconPositions: [PositionGenerator.Position] = []
        private let seed = UInt(Date().timeIntervalSince1970)

        // GuGram: Custom gift support
        private var gugramCustomGiftLayers: [Int: GuGramCustomGiftLayer] = [:]
        private var gugramCustomGiftPositions: [PositionGenerator.Position] = []
        private var gugramAppliedGift: GuGramSettings.GuGramCustomGift?
        private var gugramAppliedCount: Int32 = 0
        private var gugramAppliedSize: CGSize?
        private let gugramSeed = UInt(Date().timeIntervalSince1970 + 1337)
        private var gugramSettingsDisposable: Disposable?
        private var isGuGramCustomGiftsEnabled: Bool = false
        private var gugramCustomGiftCount: Int32 = 6
        private var gugramActiveGift: GuGramSettings.GuGramCustomGift?
        private var gugramShowGiftsOnProfile: Bool = true
        private var gugramGiftAnimationStyle: Int32 = 1
        
        private let trackingLayer = HierarchyTrackingLayer()
        private var isCurrentlyInHierarchy = false
        
        private var isUpdating = false
        
        override public init(frame: CGRect) {
            super.init(frame: frame)
            
            self.clipsToBounds = true
            
            self.layer.addSublayer(self.trackingLayer)
            
            self.trackingLayer.didEnterHierarchy = { [weak self] in
                guard let self else {
                    return
                }
                self.isCurrentlyInHierarchy = true
                self.updateAnimations()
            }
            
            self.trackingLayer.didExitHierarchy = { [weak self] in
                guard let self else {
                    return
                }
                self.isCurrentlyInHierarchy = false
            }
            
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:))))
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        deinit {
            self.giftsDisposable?.dispose()
            self.gugramSettingsDisposable?.dispose()
        }

        // MARK: - GuGram Custom Gifts Setup
        private func setupGuGramSettingsObserver() {
            guard self.gugramSettingsDisposable == nil else { return }

            let enabledSignal = GuGramSettings.shared.isCustomGiftEnabledSignal
            let giftSignal = GuGramSettings.shared.activeCustomGiftSignal
            let countSignal = GuGramSettings.shared.customGiftCountSignal
            let showOnProfileSignal = GuGramSettings.shared.showGiftsOnProfileSignal
            let animationStyleSignal = GuGramSettings.shared.giftAnimationStyleSignal

            self.gugramSettingsDisposable = combineLatest(
                queue: Queue.mainQueue(),
                enabledSignal,
                giftSignal,
                countSignal,
                showOnProfileSignal,
                animationStyleSignal
            ).start(next: { [weak self] enabled, gift, count, showOnProfile, animationStyle in
                guard let self else { return }
                self.isGuGramCustomGiftsEnabled = enabled
                self.gugramActiveGift = gift
                self.gugramCustomGiftCount = count
                self.gugramShowGiftsOnProfile = showOnProfile
                self.gugramGiftAnimationStyle = animationStyle

                if !self.isUpdating {
                    self.state?.updated(transition: .spring(duration: 0.4))
                }
            })
        }

        private func updateGuGramCustomGifts(component: PeerInfoGiftsCoverComponent, transition: ComponentTransition) {
            guard isGuGramCustomGiftsEnabled,
                  gugramShowGiftsOnProfile,
                  component.peerId == component.context.account.peerId,
                  let customGift = gugramActiveGift,
                  let currentSize = self.currentSize else {
                for (_, layer) in self.gugramCustomGiftLayers {
                    layer.animateAlpha(from: 1.0, to: 0.0, duration: 0.25, removeOnCompletion: false, completion: { _ in
                        layer.removeFromSuperlayer()
                    })
                }
                self.gugramCustomGiftLayers.removeAll()
                self.gugramCustomGiftPositions.removeAll()
                self.gugramAppliedGift = nil
                self.gugramAppliedCount = 0
                self.gugramAppliedSize = nil
                return
            }

            if currentSize.width <= 0.0 || component.defaultHeight <= 0.0 {
                return
            }

            let iconSize = CGSize(width: 36.0, height: 36.0)
            let count = max(1, min(Int(gugramCustomGiftCount), 10))

            if self.gugramAppliedGift != customGift {
                for (_, layer) in self.gugramCustomGiftLayers {
                    layer.removeFromSuperlayer()
                }
                self.gugramCustomGiftLayers.removeAll()
                self.gugramCustomGiftPositions.removeAll()
            }

            let sizeChanged = self.gugramAppliedSize != currentSize
            if sizeChanged {
                self.gugramCustomGiftPositions.removeAll()
            }
            self.gugramAppliedSize = currentSize

            if self.gugramCustomGiftPositions.isEmpty || self.gugramCustomGiftPositions.count < count || self.gugramAppliedCount != gugramCustomGiftCount {
                var avatarCenter = component.avatarCenter
                if avatarCenter.y < 0.0 {
                    avatarCenter.y = component.statusBarHeight + 75.0
                }

                var excludeRects: [CGRect] = []
                if component.statusBarHeight > 0.0 {
                    excludeRects.append(CGRect(origin: .zero, size: CGSize(width: currentSize.width, height: component.statusBarHeight + 4.0)))
                }
                excludeRects.append(CGRect(origin: CGPoint(x: 0.0, y: component.statusBarHeight), size: component.topLeftButtonsSize))
                excludeRects.append(CGRect(origin: CGPoint(x: currentSize.width - component.topRightButtonsSize.width, y: component.statusBarHeight), size: component.topRightButtonsSize))
                excludeRects.append(CGRect(origin: CGPoint(x: floor((currentSize.width - component.titleWidth) / 2.0), y: avatarCenter.y + component.avatarSize.height / 2.0 + 6.0), size: CGSize(width: component.titleWidth, height: 100.0)))
                if component.bottomHeight > 0.0 {
                    excludeRects.append(CGRect(origin: CGPoint(x: 0.0, y: component.defaultHeight - component.bottomHeight), size: CGSize(width: currentSize.width, height: component.bottomHeight)))
                }

                let positionGenerator = PositionGenerator(
                    containerSize: CGSize(width: currentSize.width, height: component.defaultHeight),
                    centerFrame: component.avatarSize.centered(around: avatarCenter),
                    exclusionZones: excludeRects,
                    minimumDistance: 38.0,
                    edgePadding: 5.0,
                    seed: self.gugramSeed
                )

                self.gugramCustomGiftPositions = positionGenerator.generatePositions(count: max(10, count), itemSize: iconSize)
            }

            self.gugramAppliedGift = customGift
            self.gugramAppliedCount = gugramCustomGiftCount

            var validIndices = Set<Int>()
            for index in 0..<count {
                guard index < self.gugramCustomGiftPositions.count else { break }
                validIndices.insert(index)

                let iconPosition = self.gugramCustomGiftPositions[index]
                let customLayer: GuGramCustomGiftLayer

                if let existing = self.gugramCustomGiftLayers[index] {
                    customLayer = existing
                } else {
                    customLayer = GuGramCustomGiftLayer(customGift: customGift, size: iconSize, glowing: component.hasBackground)
                    self.gugramCustomGiftLayers[index] = customLayer
                    customLayer.zPosition = -1.0
                    self.layer.addSublayer(customLayer)

                    if self.scheduledAnimateIn {
                        customLayer.opacity = 0.0
                    } else {
                        customLayer.animateAlpha(from: 0.0, to: 1.0, duration: 0.2)
                        customLayer.animateScale(from: 0.01, to: 1.0, duration: 0.2)
                    }
                }

                customLayer.updateGlowing(component.hasBackground)
                customLayer.applyAnimationStyle(style: gugramGiftAnimationStyle, index: index, enabled: self.isCurrentlyInHierarchy)

                let itemDistanceFraction = max(0.0, min(0.5, (iconPosition.distance - component.avatarSize.width / 2.0) / 144.0))
                let itemScaleFraction = patternScaleValueAt(fraction: min(1.0, component.avatarTransitionFraction * 1.33), t: itemDistanceFraction, reverse: false)

                let toAngle: CGFloat = .pi * 0.18
                let centerPosition = PositionGenerator.Position(distance: 0.0, angle: iconPosition.angle + toAngle, scale: iconPosition.scale)
                let effectivePosition = interpolatePosition(from: iconPosition, to: centerPosition, t: itemScaleFraction)

                let absolutePosition = getAbsolutePosition(position: effectivePosition, centerPoint: component.avatarCenter)

                transition.setBounds(layer: customLayer, bounds: CGRect(origin: .zero, size: iconSize))
                transition.setPosition(layer: customLayer, position: absolutePosition)
                transition.setScale(layer: customLayer, scale: iconPosition.scale * (1.0 - itemScaleFraction))

                if !self.scheduledAnimateIn {
                    transition.setAlpha(layer: customLayer, alpha: 1.0 - itemScaleFraction)
                }
            }

            var removeIndices: [Int] = []
            for (index, layer) in self.gugramCustomGiftLayers {
                if !validIndices.contains(index) {
                    removeIndices.append(index)
                    layer.animateScale(from: 1.0, to: 0.01, duration: 0.25, removeOnCompletion: false)
                    layer.animateAlpha(from: 1.0, to: 0.0, duration: 0.25, removeOnCompletion: false, completion: { _ in
                        layer.removeFromSuperlayer()
                    })
                }
            }
            for index in removeIndices {
                self.gugramCustomGiftLayers.removeValue(forKey: index)
            }
        }

        private func interpolatePosition(from: PositionGenerator.Position, to: PositionGenerator.Position, t: CGFloat) -> PositionGenerator.Position {
            let clampedT = max(0, min(1, t))
            let interpolatedDistance = from.distance + (to.distance - from.distance) * clampedT
            let interpolatedAngle = from.angle + (to.angle - from.angle) * clampedT
            return PositionGenerator.Position(distance: interpolatedDistance, angle: interpolatedAngle, scale: from.scale)
        }
        
        @objc private func tapped(_ gestureRecognizer: UITapGestureRecognizer) {
            guard let component = self.component else {
                return
            }
            let location = gestureRecognizer.location(in: self)
            for (_, iconLayer) in self.iconLayers {
                if iconLayer.frame.contains(location) {
                    component.action(iconLayer.gift)
                    break
                }
            }
        }
        
        public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            for (_, iconLayer) in self.iconLayers {
                if iconLayer.frame.contains(point) {
                    return true
                }
            }
            return false
        }
        
        func updateAnimations() {
            var index = 0
            for (_, iconLayer) in self.iconLayers {
                if self.isCurrentlyInHierarchy {
                    iconLayer.startAnimations(index: index)
                }
                index += 1
            }

            let sortedIndices = self.gugramCustomGiftLayers.keys.sorted()
            for index in sortedIndices {
                if let layer = self.gugramCustomGiftLayers[index] {
                    layer.applyAnimationStyle(style: self.gugramGiftAnimationStyle, index: index, enabled: self.isCurrentlyInHierarchy)
                }
            }
        }
        
        private var scheduledAnimateIn = false
        public func willAnimateIn() {
            self.scheduledAnimateIn = true
            for (_, layer) in self.iconLayers {
                layer.opacity = 0.0
            }
            for (_, layer) in self.gugramCustomGiftLayers {
                layer.opacity = 0.0
            }
        }
        
        public func animateIn() {
            guard let _ = self.currentSize, let component = self.component else {
                return
            }
            self.scheduledAnimateIn = false
            
            for (_, layer) in self.iconLayers {
                layer.opacity = 1.0
                layer.animatePosition(
                    from: component.avatarCenter,
                    to: layer.position,
                    duration: 0.4,
                    timingFunction: kCAMediaTimingFunctionSpring
                )
            }
            for (_, layer) in self.gugramCustomGiftLayers {
                layer.opacity = 1.0
                layer.animatePosition(
                    from: component.avatarCenter,
                    to: layer.position,
                    duration: 0.4,
                    timingFunction: kCAMediaTimingFunctionSpring
                )
            }
        }
    
        func update(component: PeerInfoGiftsCoverComponent, availableSize: CGSize, state: EmptyComponentState, environment: Environment<Empty>, transition: ComponentTransition) -> CGSize {
            self.isUpdating = true
            defer {
                self.isUpdating = false
            }

            // GuGram: Setup custom gifts observer
            self.setupGuGramSettingsObserver()

            let previousComponent = self.component
            self.component = component
            self.state = state

            let previousCurrentSize = self.currentSize
            self.currentSize = availableSize

            let iconSize = CGSize(width: 32.0, height: 32.0)
            
            let giftIds = self.gifts.map { gift in
                if case let .unique(gift) = gift.gift {
                    return gift.id
                } else {
                    return 0
                }
            }
            
            if !giftIds.isEmpty && (self.iconPositions.isEmpty || previousCurrentSize?.width != availableSize.width || (previousComponent != nil && previousComponent?.hasBackground != component.hasBackground) || self.appliedGiftIds != giftIds) {
                var avatarCenter = component.avatarCenter
                if avatarCenter.y < 0.0 {
                    avatarCenter.y = component.statusBarHeight + 75.0
                }
                
                var excludeRects: [CGRect] = []
                if component.statusBarHeight > 0.0 {
                    excludeRects.append(CGRect(origin: .zero, size: CGSize(width: availableSize.width, height: component.statusBarHeight + 4.0)))
                }
                excludeRects.append(CGRect(origin: CGPoint(x: 0.0, y: component.statusBarHeight), size: component.topLeftButtonsSize))
                excludeRects.append(CGRect(origin: CGPoint(x: availableSize.width - component.topRightButtonsSize.width, y: component.statusBarHeight), size: component.topRightButtonsSize))
                excludeRects.append(CGRect(origin: CGPoint(x: floor((availableSize.width - component.titleWidth) / 2.0), y: avatarCenter.y + component.avatarSize.height / 2.0 + 6.0), size: CGSize(width: component.titleWidth, height: 100.0)))
                if component.bottomHeight > 0.0 {
                    excludeRects.append(CGRect(origin: CGPoint(x: 0.0, y: component.defaultHeight - component.bottomHeight), size: CGSize(width: availableSize.width, height: component.bottomHeight)))
                }
                                                
                let positionGenerator = PositionGenerator(
                    containerSize: CGSize(width: availableSize.width, height: component.defaultHeight),
                    centerFrame: component.avatarSize.centered(around: avatarCenter),
                    exclusionZones: excludeRects,
                    minimumDistance: 42.0,
                    edgePadding: 5.0,
                    seed: self.seed
                )
                
                self.iconPositions = positionGenerator.generatePositions(count: 12, itemSize: iconSize)
            }
            self.appliedGiftIds = giftIds
            
            if self.giftsDisposable == nil {
                self.giftsDisposable = combineLatest(
                    queue: Queue.mainQueue(),
                    component.giftsContext.state,
                    component.context.engine.data.subscribe(TelegramEngine.EngineData.Item.Peer.Peer(id: component.peerId))
                    |> map { peer -> Int64? in
                        if case let .user(user) = peer, case let .starGift(id, _, _, _, _, _, _, _, _) = user.emojiStatus?.content {
                            return id
                        }
                        return nil
                    }
                    |> distinctUntilChanged
                ).start(next: { [weak self] state, giftStatusId in
                    guard let self else {
                        return
                    }
                    
                    let pinnedGifts = state.gifts.filter { gift in
                        if gift.pinnedToTop {
                            if case let .unique(uniqueGift) = gift.gift {
                                return uniqueGift.id != giftStatusId
                            }
                        }
                        return false
                    }
                    self.gifts = pinnedGifts
                    
                    if !self.isUpdating {
                        self.state?.updated(transition: .spring(duration: 0.4))
                    }
                })
            }
                                                                          
            var validIds = Set<AnyHashable>()
            var index = 0
            for gift in self.gifts.prefix(12) {
                guard index < self.iconPositions.count else {
                    break
                }
                let id: AnyHashable
                if case let .unique(uniqueGift) = gift.gift {
                    id = uniqueGift.slug
                } else {
                    id = index
                }
                validIds.insert(id)
                
                var iconTransition = transition
                let iconPosition = self.iconPositions[index]
                let iconLayer: GiftIconLayer
                if let current = self.iconLayers[id] {
                    iconLayer = current
                } else {
                    iconTransition = .immediate
                    iconLayer = GiftIconLayer(context: component.context, gift: gift, size: iconSize, glowing: component.hasBackground)
                    self.iconLayers[id] = iconLayer
                    self.layer.addSublayer(iconLayer)
                    
                    if self.scheduledAnimateIn {
                        iconLayer.opacity = 0.0
                    } else {
                        iconLayer.animateAlpha(from: 0.0, to: 1.0, duration: 0.2)
                        iconLayer.animateScale(from: 0.01, to: 1.0, duration: 0.2)
                    }
                    
                    iconLayer.startAnimations(index: index)
                }
                iconLayer.glowing = component.hasBackground
                
                let itemDistanceFraction = max(0.0, min(0.5, (iconPosition.distance - component.avatarSize.width / 2.0) / 144.0))
                let itemScaleFraction = patternScaleValueAt(fraction: min(1.0, component.avatarTransitionFraction * 1.33), t: itemDistanceFraction, reverse: false)
               
                func interpolatePosition(from: PositionGenerator.Position, to: PositionGenerator.Position, t: CGFloat) -> PositionGenerator.Position {
                    let clampedT = max(0, min(1, t))
                    
                    let interpolatedDistance = from.distance + (to.distance - from.distance) * clampedT
                    let interpolatedAngle = from.angle + (to.angle - from.angle) * clampedT
                    
                    return PositionGenerator.Position(distance: interpolatedDistance, angle: interpolatedAngle, scale: from.scale)
                }
                
                let toAngle: CGFloat = .pi * 0.18
                let centerPosition = PositionGenerator.Position(distance: 0.0, angle: iconPosition.angle + toAngle, scale: iconPosition.scale)
                let effectivePosition = interpolatePosition(from: iconPosition, to: centerPosition, t: itemScaleFraction)
                let effectiveAngle = toAngle * itemScaleFraction
                
                let absolutePosition = getAbsolutePosition(position: effectivePosition, centerPoint: component.avatarCenter)
                                
                iconTransition.setBounds(layer: iconLayer, bounds: CGRect(origin: .zero, size: iconSize))
                iconTransition.setPosition(layer: iconLayer, position: absolutePosition)
                iconLayer.updateRotation(effectiveAngle, transition: iconTransition)
                iconTransition.setScale(layer: iconLayer, scale: iconPosition.scale * (1.0 - itemScaleFraction))
                
                if !self.scheduledAnimateIn {
                    iconTransition.setAlpha(layer: iconLayer, alpha: 1.0 - itemScaleFraction)
                }
                
                index += 1
            }
            
            var removeIds: [AnyHashable] = []
            for (id, layer) in self.iconLayers {
                if !validIds.contains(id) {
                    removeIds.append(id)
                    layer.animateScale(from: 1.0, to: 0.01, duration: 0.25, removeOnCompletion: false)
                    layer.animateAlpha(from: 1.0, to: 0.0, duration: 0.25, removeOnCompletion: false, completion: { _ in
                        layer.removeFromSuperlayer()
                    })
                }
            }
            for id in removeIds {
                self.iconLayers.removeValue(forKey: id)
            }

            // GuGram: update custom gifts layer
            self.updateGuGramCustomGifts(component: component, transition: transition)
            return availableSize
        }
    }
    
    public func makeView() -> View {
        return View(frame: CGRect())
    }
    
    public func update(view: View, availableSize: CGSize, state: EmptyComponentState, environment: Environment<Empty>, transition: ComponentTransition) -> CGSize {
        return view.update(component: self, availableSize: availableSize, state: state, environment: environment, transition: transition)
    }
}

private var shadowImage: UIImage? = {
    return generateImage(CGSize(width: 44.0, height: 44.0), rotatedContext: { size, context in
        context.clear(CGRect(origin: .zero, size: size))
        
        var locations: [CGFloat] = [0.0, 0.3, 1.0]
        let colors: [CGColor] = [UIColor(rgb: 0xffffff, alpha: 0.65).cgColor, UIColor(rgb: 0xffffff, alpha: 0.65).cgColor, UIColor(rgb: 0xffffff, alpha: 0.0).cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: &locations)!
        context.drawRadialGradient(gradient, startCenter: CGPoint(x: size.width / 2.0, y: size.height / 2.0), startRadius: 0.0, endCenter: CGPoint(x: size.width / 2.0, y: size.height / 2.0), endRadius: size.width / 2.0, options: .drawsAfterEndLocation)
    })
}()

private final class StarsEffectLayer: SimpleLayer {
    private let emitterLayer = CAEmitterLayer()
    
    override init() {
        super.init()
        
        self.addSublayer(self.emitterLayer)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(color: UIColor, size: CGSize) {
        self.color = color
        
        let emitter = CAEmitterCell()
        emitter.name = "emitter"
        emitter.contents = UIImage(bundleImageName: "Premium/Stars/Particle")?.cgImage
        emitter.birthRate = 8.0
        emitter.lifetime = 2.0
        emitter.velocity = 0.1
        emitter.scale = (size.width / 40.0) * 0.12
        emitter.scaleRange = 0.02
        emitter.alphaRange = 0.1
        emitter.emissionRange = .pi * 2.0
        
        let staticColors: [Any] = [
            color.withAlphaComponent(0.0).cgColor,
            color.withAlphaComponent(0.58).cgColor,
            color.withAlphaComponent(0.58).cgColor,
            color.withAlphaComponent(0.0).cgColor
        ]
        let staticColorBehavior = CAEmitterCell.createEmitterBehavior(type: "colorOverLife")
        staticColorBehavior.setValue(staticColors, forKey: "colors")
        emitter.setValue([staticColorBehavior], forKey: "emitterBehaviors")
        self.emitterLayer.emitterCells = [emitter]
    }
    
    private var color: UIColor?
        
    func update(color: UIColor, size: CGSize) {
        if self.color != color {
            self.setup(color: color, size: size)
        }
        self.emitterLayer.seed = UInt32.random(in: .min ..< .max)
        self.emitterLayer.emitterShape = .circle
        self.emitterLayer.emitterSize = size
        self.emitterLayer.emitterMode = .surface
        self.emitterLayer.frame = CGRect(origin: .zero, size: size)
        self.emitterLayer.emitterPosition = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
    }
}

private class GiftIconLayer: SimpleLayer {
    private let context: AccountContext
    let gift: ProfileGiftsContext.State.StarGift
    private let size: CGSize
    var glowing: Bool {
        didSet {
            self.shadowLayer.opacity = self.glowing ? 1.0 : 0.0
            
            let color: UIColor
            if self.glowing {
                color = .white
            } else if let layerTintColor = self.shadowLayer.layerTintColor {
                color = UIColor(cgColor: layerTintColor)
            } else {
                color = .white
            }
            
            let side = floor(self.size.width * 1.25)
            let starsFrame = CGSize(width: side, height: side).centered(in: CGRect(origin: .zero, size: self.size))
            self.starsLayer.frame = starsFrame
            self.starsLayer.update(color: color, size: starsFrame.size)
        }
    }
    
    let shadowLayer = SimpleLayer()
    let starsLayer = StarsEffectLayer()
    let animationLayer: InlineStickerItemLayer
    
    override init(layer: Any) {
        guard let layer = layer as? GiftIconLayer else {
            fatalError()
        }
                
        let context = layer.context
        let gift = layer.gift
        let size = layer.size
        let glowing = layer.glowing
        
        var file: TelegramMediaFile?
        var color: UIColor = .white
        switch gift.gift {
        case let .generic(gift):
            file = gift.file
        case let .unique(gift):
            for attribute in gift.attributes {
                if case let .model(_, fileValue, _) = attribute {
                    file = fileValue
                } else if case let .backdrop(_, _, innerColor, _, _, _, _) = attribute {
                    color = UIColor(rgb: UInt32(bitPattern: innerColor))
                }
            }
        }
        
        let emoji = ChatTextInputTextCustomEmojiAttribute(
            interactivelySelectedFromPackId: nil,
            fileId: file?.fileId.id ?? 0,
            file: file
        )
        self.animationLayer = InlineStickerItemLayer(
            context: .account(context),
            userLocation: .other,
            attemptSynchronousLoad: false,
            emoji: emoji,
            file: file,
            cache: context.animationCache,
            renderer: context.animationRenderer,
            unique: true,
            placeholderColor: UIColor.white.withAlphaComponent(0.2),
            pointSize: CGSize(width: size.width * 2.0, height: size.height * 2.0),
            loopCount: 1
        )
        
        self.shadowLayer.contents = shadowImage?.cgImage
        self.shadowLayer.layerTintColor = color.cgColor
        self.shadowLayer.opacity = glowing ? 1.0 : 0.0
        
        self.context = context
        self.gift = gift
        self.size = size
        self.glowing = glowing
        
        super.init()
        
        let side = floor(size.width * 1.25)
        let starsFrame = CGSize(width: side, height: side).centered(in: CGRect(origin: .zero, size: size))
        self.starsLayer.frame = starsFrame
        self.starsLayer.update(color: glowing ? .white : color, size: starsFrame.size)
        
        self.addSublayer(self.shadowLayer)
        self.addSublayer(self.starsLayer)
        self.addSublayer(self.animationLayer)
    }
    
    init(
        context: AccountContext,
        gift: ProfileGiftsContext.State.StarGift,
        size: CGSize,
        glowing: Bool
    ) {
        self.context = context
        self.gift = gift
        self.size = size
        self.glowing = glowing
        
        var file: TelegramMediaFile?
        var color: UIColor = .white
        switch gift.gift {
        case let .generic(gift):
            file = gift.file
        case let .unique(gift):
            for attribute in gift.attributes {
                if case let .model(_, fileValue, _) = attribute {
                    file = fileValue
                } else if case let .backdrop(_, _, innerColor, _, _, _, _) = attribute {
                    color = UIColor(rgb: UInt32(bitPattern: innerColor))
                }
            }
        }
        
        let emoji = ChatTextInputTextCustomEmojiAttribute(
            interactivelySelectedFromPackId: nil,
            fileId: file?.fileId.id ?? 0,
            file: file
        )
        self.animationLayer = InlineStickerItemLayer(
            context: .account(context),
            userLocation: .other,
            attemptSynchronousLoad: false,
            emoji: emoji,
            file: file,
            cache: context.animationCache,
            renderer: context.animationRenderer,
            unique: true,
            placeholderColor: UIColor.white.withAlphaComponent(0.2),
            pointSize: CGSize(width: size.width * 2.0, height: size.height * 2.0),
            loopCount: 1
        )
        
        self.shadowLayer.contents = shadowImage?.cgImage
        self.shadowLayer.layerTintColor = color.cgColor
        self.shadowLayer.opacity = glowing ? 1.0 : 0.0
        
        super.init()
        
        let side = floor(size.width * 1.25)
        let starsFrame = CGSize(width: side, height: side).centered(in: CGRect(origin: .zero, size: size))
        self.starsLayer.frame = starsFrame
        self.starsLayer.update(color: glowing ? .white : color, size: starsFrame.size)
        
        self.addSublayer(self.shadowLayer)
        self.addSublayer(self.starsLayer)
        self.addSublayer(self.animationLayer)
    }
    
    required init?(coder: NSCoder) {
        preconditionFailure()
    }
    
    override func layoutSublayers() {
        self.shadowLayer.frame = CGRect(origin: .zero, size: self.bounds.size).insetBy(dx: -8.0, dy: -8.0)
        self.animationLayer.bounds = CGRect(origin: .zero, size: self.bounds.size)
        self.animationLayer.position = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
    }
    
    func updateRotation(_ angle: CGFloat, transition: ComponentTransition) {
        self.animationLayer.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
    }
    
    func startAnimations(index: Int) {
        let beginTime = Double(index) * 1.5
        
        if self.animation(forKey: "hover") == nil {
            let upDistance = CGFloat.random(in: 1.0 ..< 2.0)
            let downDistance = CGFloat.random(in: 1.0 ..< 2.0)
            let hoverDuration = TimeInterval.random(in: 3.5 ..< 4.5)
            
            let hoverAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            hoverAnimation.duration = hoverDuration
            hoverAnimation.fromValue = -upDistance
            hoverAnimation.toValue = downDistance
            hoverAnimation.autoreverses = true
            hoverAnimation.repeatCount = .infinity
            hoverAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            hoverAnimation.beginTime = beginTime
            hoverAnimation.isAdditive = true
            self.add(hoverAnimation, forKey: "hover")
        }
        
        if self.animationLayer.animation(forKey: "wiggle") == nil {
            let fromRotationAngle = CGFloat.random(in: 0.025 ..< 0.05)
            let toRotationAngle = CGFloat.random(in: 0.025 ..< 0.05)
            let wiggleDuration = TimeInterval.random(in: 2.0 ..< 3.0)
            
            let wiggleAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            wiggleAnimation.duration = wiggleDuration
            wiggleAnimation.fromValue = -fromRotationAngle
            wiggleAnimation.toValue = toRotationAngle
            wiggleAnimation.autoreverses = true
            wiggleAnimation.repeatCount = .infinity
            wiggleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            wiggleAnimation.beginTime = beginTime
            wiggleAnimation.isAdditive = true
            self.animationLayer.add(wiggleAnimation, forKey: "wiggle")
        }
        
        if self.shadowLayer.animation(forKey: "glow") == nil {
            let glowDuration = TimeInterval.random(in: 2.0 ..< 3.0)
            
            let glowAnimation = CABasicAnimation(keyPath: "transform.scale")
            glowAnimation.duration = glowDuration
            glowAnimation.fromValue = 1.0
            glowAnimation.toValue = 1.2
            glowAnimation.autoreverses = true
            glowAnimation.repeatCount = .infinity
            glowAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            glowAnimation.beginTime = beginTime
            self.shadowLayer.add(glowAnimation, forKey: "glow")
        }
    }
}

private struct PositionGenerator {
    struct Position {
        let distance: CGFloat
        let angle: CGFloat
        let scale: CGFloat
        
        var relativeCartesian: CGPoint {
            return CGPoint(
                x: self.distance * cos(self.angle),
                y: self.distance * sin(self.angle)
            )
        }
    }
    
    let containerSize: CGSize
    let centerFrame: CGRect
    let exclusionZones: [CGRect]
    let minimumDistance: CGFloat
    let edgePadding: CGFloat
    let scaleRange: (min: CGFloat, max: CGFloat)
    
    let innerOrbitRange: (min: CGFloat, max: CGFloat)
    let outerOrbitRange: (min: CGFloat, max: CGFloat)
    let innerOrbitCount: Int
    
    private let lokiRng: LokiRng
    
    init(
        containerSize: CGSize,
        centerFrame: CGRect,
        exclusionZones: [CGRect],
        minimumDistance: CGFloat,
        edgePadding: CGFloat,
        seed: UInt,
        scaleRange: (min: CGFloat, max: CGFloat) = (0.7, 1.15),
        innerOrbitRange: (min: CGFloat, max: CGFloat) = (1.4, 2.2),
        outerOrbitRange: (min: CGFloat, max: CGFloat) = (2.5, 3.6),
        innerOrbitCount: Int = 4
    ) {
        self.containerSize = containerSize
        self.centerFrame = centerFrame
        self.exclusionZones = exclusionZones
        self.minimumDistance = minimumDistance
        self.edgePadding = edgePadding
        self.scaleRange = scaleRange
        self.innerOrbitRange = innerOrbitRange
        self.outerOrbitRange = outerOrbitRange
        self.innerOrbitCount = innerOrbitCount
        self.lokiRng = LokiRng(seed0: seed, seed1: 0, seed2: 0)
    }
    
    func generatePositions(count: Int, itemSize: CGSize) -> [Position] {
        var positions: [Position] = []
        
        let centerPoint = CGPoint(x: self.centerFrame.midX, y: self.centerFrame.midY)
        let centerRadius = min(self.centerFrame.width, self.centerFrame.height) / 2.0
        
        let maxAttempts = count * 200
        var attempts = 0
        
        var leftPositions = 0
        var rightPositions = 0
        
        let innerCount = min(self.innerOrbitCount, count)
        
        while positions.count < innerCount && attempts < maxAttempts {
            attempts += 1
            
            let placeOnLeftSide = rightPositions > leftPositions
            
            let orbitRangeSize = self.innerOrbitRange.max - self.innerOrbitRange.min
            let orbitDistanceFactor = self.innerOrbitRange.min + orbitRangeSize * CGFloat(self.lokiRng.next())
            let distance = orbitDistanceFactor * centerRadius
            
            let angleRange: CGFloat = placeOnLeftSide ? .pi : .pi
            let angleOffset: CGFloat = placeOnLeftSide ? .pi/2 : -(.pi/2)
            let angle = angleOffset + angleRange * CGFloat(self.lokiRng.next())
            
            let absolutePosition = getAbsolutePosition(distance: distance, angle: angle, centerPoint: centerPoint)
            
            if absolutePosition.x - itemSize.width/2 < self.edgePadding ||
                absolutePosition.x + itemSize.width/2 > self.containerSize.width - self.edgePadding ||
                absolutePosition.y - itemSize.height/2 < self.edgePadding ||
                absolutePosition.y + itemSize.height/2 > self.containerSize.height - self.edgePadding {
                continue
            }
            
            let itemRect = CGRect(
                x: absolutePosition.x - itemSize.width/2,
                y: absolutePosition.y - itemSize.height/2,
                width: itemSize.width,
                height: itemSize.height
            )
            
            if self.isValidPosition(itemRect, existingPositions: positions.map {
                getAbsolutePosition(distance: $0.distance, angle: $0.angle, centerPoint: centerPoint)
            }, itemSize: itemSize) {
                let scaleRangeSize = max(self.scaleRange.min + 0.1, 0.75) - self.scaleRange.max
                let scale = self.scaleRange.max + scaleRangeSize * CGFloat(self.lokiRng.next())
                positions.append(Position(distance: distance, angle: angle, scale: scale))
                
                if absolutePosition.x < centerPoint.x {
                    leftPositions += 1
                } else {
                    rightPositions += 1
                }
            }
        }
        
        let maxPossibleDistance = hypot(self.containerSize.width, self.containerSize.height) / 2
        
        while positions.count < count && attempts < maxAttempts {
            attempts += 1
            
            let placeOnLeftSide = rightPositions >= leftPositions
            
            let orbitRangeSize = self.outerOrbitRange.max - self.outerOrbitRange.min
            let orbitDistanceFactor = self.outerOrbitRange.min + orbitRangeSize * CGFloat(self.lokiRng.next())
            let distance = orbitDistanceFactor * centerRadius
            
            let angleRange: CGFloat = placeOnLeftSide ? .pi : .pi
            let angleOffset: CGFloat = placeOnLeftSide ? .pi/2 : -(.pi/2)
            let angle = angleOffset + angleRange * CGFloat(self.lokiRng.next())
            
            let absolutePosition = getAbsolutePosition(distance: distance, angle: angle, centerPoint: centerPoint)
            if absolutePosition.x - itemSize.width/2 < self.edgePadding ||
                absolutePosition.x + itemSize.width/2 > self.containerSize.width - self.edgePadding ||
                absolutePosition.y - itemSize.height/2 < self.edgePadding ||
                absolutePosition.y + itemSize.height/2 > self.containerSize.height - self.edgePadding {
                continue
            }
            
            let itemRect = CGRect(
                x: absolutePosition.x - itemSize.width/2,
                y: absolutePosition.y - itemSize.height/2,
                width: itemSize.width,
                height: itemSize.height
            )
            
            if self.isValidPosition(itemRect, existingPositions: positions.map {
                getAbsolutePosition(distance: $0.distance, angle: $0.angle, centerPoint: centerPoint)
            }, itemSize: itemSize) {
                let normalizedDistance = min(distance / maxPossibleDistance, 1.0)
                let scale = self.scaleRange.max - normalizedDistance * (self.scaleRange.max - self.scaleRange.min)
                positions.append(Position(distance: distance, angle: angle, scale: scale))
                
                if absolutePosition.x < centerPoint.x {
                    leftPositions += 1
                } else {
                    rightPositions += 1
                }
            }
        }
        
        return positions
    }
    
    func getAbsolutePosition(distance: CGFloat, angle: CGFloat, centerPoint: CGPoint) -> CGPoint {
        return CGPoint(
            x: centerPoint.x + distance * cos(angle),
            y: centerPoint.y + distance * sin(angle)
        )
    }
    
    private func isValidPosition(_ rect: CGRect, existingPositions: [CGPoint], itemSize: CGSize) -> Bool {
        if rect.minX < self.edgePadding || rect.maxX > self.containerSize.width - self.edgePadding ||
            rect.minY < self.edgePadding || rect.maxY > self.containerSize.height - self.edgePadding {
            return false
        }
        
        for zone in self.exclusionZones {
            if rect.intersects(zone) {
                return false
            }
        }
        
        let effectiveMinDistance = existingPositions.count > 5 ? max(self.minimumDistance * 0.7, 10.0) : self.minimumDistance
        
        for existingPosition in existingPositions {
            let distance = hypot(existingPosition.x - rect.midX, existingPosition.y - rect.midY)
            if distance < effectiveMinDistance {
                return false
            }
        }
        
        return true
    }
}

private func getAbsolutePosition(position: PositionGenerator.Position, centerPoint: CGPoint) -> CGPoint {
    return CGPoint(
        x: centerPoint.x + position.distance * cos(position.angle),
        y: centerPoint.y + position.distance * sin(position.angle)
    )
}

private func getAbsolutePosition(distance: CGFloat, angle: CGFloat, centerPoint: CGPoint) -> CGPoint {
    return CGPoint(
        x: centerPoint.x + distance * cos(angle),
        y: centerPoint.y + distance * sin(angle)
    )
}

private func windowFunction(t: CGFloat) -> CGFloat {
    return bezierPoint(0.6, 0.0, 0.4, 1.0, t)
}

private func patternScaleValueAt(fraction: CGFloat, t: CGFloat, reverse: Bool) -> CGFloat {
    let windowSize: CGFloat = 0.8

    let effectiveT: CGFloat
    let windowStartOffset: CGFloat
    let windowEndOffset: CGFloat
    if reverse {
        effectiveT = 1.0 - t
        windowStartOffset = 1.0
        windowEndOffset = -windowSize
    } else {
        effectiveT = t
        windowStartOffset = -windowSize
        windowEndOffset = 1.0
    }

    let windowPosition = (1.0 - fraction) * windowStartOffset + fraction * windowEndOffset
    let windowT = max(0.0, min(windowSize, effectiveT - windowPosition)) / windowSize
    let localT = 1.0 - windowFunction(t: windowT)

    return localT
}
