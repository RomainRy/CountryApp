
import SwiftUI

public struct EmptyState: View {
    let message: String
    let icon: String
    
    public init(message: String, icon: String = "magnifyingglass") {
        self.message = message
        self.icon = icon
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
