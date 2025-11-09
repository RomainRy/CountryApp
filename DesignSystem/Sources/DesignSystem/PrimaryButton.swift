
import SwiftUI

public struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let style: PrimaryButtonStyle
   
    public init(title: String, style: PrimaryButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
   
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(style.textColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(style.backgroundColor)
                .cornerRadius(12)
        }
    }
}

public enum PrimaryButtonStyle {
    case primary
    case secondary
   
    var backgroundColor: Color {
        switch self {
        case .primary: return .blue
        case .secondary: return .gray.opacity(0.2)
        }
    }
   
    var textColor: Color {
        switch self {
        case .primary: return .white
        case .secondary: return .primary
        }
    }
}
