import UIKit

class DiagonalView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isOpaque = false
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Step 1: Create the diagonal transparent-white shape
        let diagonalPath = UIBezierPath()
        diagonalPath.move(to: CGPoint(x: 0, y: 0))                             // Top-left
        diagonalPath.addLine(to: CGPoint(x: rect.width, y: 0))                // Top-right
        diagonalPath.addLine(to: CGPoint(x: rect.width, y: rect.height*0.75 )) // Bottom-right (reduced height)
        diagonalPath.addLine(to: CGPoint(x: 0, y: rect.height/1.8))         // Bottom-left
        diagonalPath.close()
      

        // Step 2: Add the full rect path
        let fullRectPath = UIBezierPath(rect: rect)

        // Step 3: Subtract the diagonal path from the full rect to get the "outside area"
        fullRectPath.append(diagonalPath.reversing())

        // Step 4: Fill the outer area with solid red
        UIColor.white.setFill()
        fullRectPath.fill()

        // Step 5: Fill the diagonal path with *real* semi-transparent white
        UIColor(white: 1.0, alpha: 0.5).setFill()
        diagonalPath.fill(with: .normal, alpha: 0.5)
    }
}
