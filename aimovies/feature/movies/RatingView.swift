import UIKit


class RatingView: UIView {

    private let label = UILabel()
    private var rating: Double = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setRating(_ value: Double) {
        rating = value
        label.text = String(format: "%.1f", rating)
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        let radius = min(rect.width, rect.height) / 2 - 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startAngle: CGFloat = -.pi / 2
        let endAngle = startAngle + CGFloat(rating / 10) * 2 * .pi

        // Background circle
        ctx.setStrokeColor(UIColor.systemGray4.cgColor)
        ctx.setLineWidth(4)
        ctx.addArc(center: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        ctx.strokePath()

        // Rating arc
        ctx.setStrokeColor(UIColor.systemBlue.cgColor)
        ctx.setLineWidth(4)
        ctx.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        ctx.strokePath()
    }
}
