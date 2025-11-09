
import SwiftUI

public struct CountryCard: View {
    let flagURL: String
    let countryName: String
    let capital: String
   
    public init(flagURL: String, countryName: String, capital: String) {
        self.flagURL = flagURL
        self.countryName = countryName
        self.capital = capital
    }
   
    public var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: flagURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 35)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .shadow(radius: 2)
           
            VStack(alignment: .leading, spacing: 4) {
                Text(countryName)
                    .font(.headline)
                    .foregroundColor(.primary)
               
                Text("Capitale : \(capital)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
           
            Spacer()
           
            Image(systemName: "chevron.right")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
