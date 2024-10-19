import SwiftUI
struct EventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(event.imageName)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipped()
                .cornerRadius(10)
            
            Text(event.title)
                .font(.title2)
                .foregroundColor(.primary)
            
            Text(event.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Label("$\(String(format: "%.2f", event.price))", systemImage: "dollarsign.circle")
                Spacer()
                Label("\(event.address)", systemImage: "location")
                Spacer()
                Label(event.date, systemImage: "calendar")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.secondBackground)
        .cornerRadius(15)
    }
}
