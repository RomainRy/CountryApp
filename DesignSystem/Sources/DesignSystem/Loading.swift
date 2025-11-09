
import SwiftUI

public struct Loading: View {
    let message: String
   
    public init(message: String = "Chargement...") {
        self.message = message
    }
   
    public var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
