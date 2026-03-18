import SwiftUI

struct CategoryChart: View {
    var body: some View {
        VStack {
            Image(systemName: "chart.pie")
                .font(.largeTitle)
                .foregroundColor(.green)

            Text("Category chart coming soon")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 180)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    CategoryChart()
        .padding()
}
