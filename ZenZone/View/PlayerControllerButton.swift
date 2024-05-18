import SwiftUI

struct PlayerControllerButton: View {
    var systemName: String
    var fontSize: CGFloat
    var color: Color?
    var action: () -> Void // Closure property to handle button action
    
    // Initialize with an action closure
    init(systemName: String, fontSize: CGFloat, color: Color? = nil, action: @escaping () -> Void) {
        self.systemName = systemName
        self.fontSize = fontSize
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) { // Invoke the action closure when the button is tapped
            Image(systemName: systemName)
                .font(.system(size: fontSize))
                .foregroundColor(color ?? .white)
        }
    }
}
