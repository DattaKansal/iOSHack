import SwiftUI
struct EventCard: View {
    let event: Event
    
    var body: some View {
        ZStack {
            Image(event.imageName)
                .resizable()
                .frame(width: 300, height: 400)
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .cornerRadius(20)
                .overlay(
                    // Create a gradient to darken the bottom part
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(1)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .frame(height: 400), // Adjust height based on how much of the image you want to darken
                    alignment: .bottom
                )
            HStack {
                VStack(alignment: .leading) {
                    Spacer()
                    Text(event.title)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    Label(event.date, systemImage: "calendar")
                        .foregroundColor(.secondary)
                    Label("\(event.address)", systemImage: "location")
                        .foregroundColor(.secondary)
                    let price = event.price == 0 ? "Free" : "$" + String(format: "%.2f", event.price)
                    Label("\(price)", systemImage: "dollarsign.circle")
                        .foregroundColor(.secondary)

                }
                .padding(20)
                Spacer()
            }
        }
        .background(Color.secondBackground)
        .frame(width: 300, height: 400)
        .cornerRadius(20)
    }
}

#Preview {
    EventCard(event: Event(title: "Robot Speaker Event", description: "Learn and play with some robots", price: 0, orgName: "Robojackets", address: "SCC", date: "Nov 1 8-10 pm", imageName: "robot", tiers: [Tier(name: "Tier 1", price: 15, numTickets: 50), Tier(name: "Tier 2", price: 30, numTickets: 100)]))
}
