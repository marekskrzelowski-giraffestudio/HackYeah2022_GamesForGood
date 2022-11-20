import SwiftUI
import Content

struct MissionDetails: View {
    @StateObject var viewModel: MissionDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.mission.name)
                    .font(.custom("Rubik-Medium", size: 22))
                Content.image(.water)
                Text("Czy wiesz, że...")
                    .font(.custom("Rubik-SemiBold", size: 16))
                Text(viewModel.mission.missionDescription)
                    .font(.custom("Rubik-Regular", size: 12))
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Content.color(.accentLight))
                    VStack {
                        Text("Sprawdź, jak radzą sobie inni! Zobacz w jaki sposób oszczędzają pozostali użytkownicy")
                            .font(.custom("Rubik-Medium", size: 15))
                            .padding()
                        PrimaryButton(text: "Inni użytkownicy", height: 50, fontSize: 17, action: {})
                            .frame(width: 313, height: 50)
                            .padding(.bottom, 10)
                    }
                }
                ForEach(viewModel.tasks) { task in
                    TaskCard(
                        id: task.id,
                        points: task.title,
                        description: task.subtitle,
                        color: task.color,
                        image: URL(string: task.image)
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .background(Content.image(.back))
        .task {
            await viewModel.onAppear()
        }
    }
}

struct TaskCard:  View {
    let id: Int
    let points: String
    let description: String
    let color: String
    let image: URL?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(hex: color))
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    CachedAsyncImage(
                        url: image,
                        content: { image in
                            image
                                .resizable()
                                .frame(width: 49, height: 49)
                                .cornerRadius(10)
                        },
                        placeholder: {
                            Content.image(.missionph)
                                .resizable()
                                .frame(width: 49, height: 49)
                                .cornerRadius(10)
                        }
                    )
                    .padding()
                    VStack(alignment: .leading, spacing: 0) {
                        Text(points)
                            .font(.custom("Rubik-Regular", size: 12))
                            .foregroundColor(Content.color(.blackWhite))
                        Text("Zbieraj deszczówkę do podlewania roślin")
                            .multilineTextAlignment(.leading)
                            .font(.custom("Rubik-Medium", size: 16))
                            .foregroundColor(Content.color(.blackWhite))
                            .padding(.top, 3)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
    }
}

