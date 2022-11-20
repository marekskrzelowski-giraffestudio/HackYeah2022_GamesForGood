import SwiftUI
import Content

struct LearnView: View {
    @StateObject var viewModel: LearnViewModel

    var missionRows: [GridItem] = [GridItem(.fixed(237))]
    var taskRows: [GridItem] = [GridItem(.fixed(110))]

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            logoView
            greatingsView
            missionList
            taskList
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Content.image(.back))
        .task {
            await viewModel.onAppear()
        }
    }

    private var logoView: some View {
        HStack {
            Content.image(.logomain)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Content.image(.bell)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(height: 26)
    }

    private var greatingsView: some View {
        Text("Dobrze, że tu jesteś, \(viewModel.name)!👋")
            .font(.custom("Rubik-Medium", size: 24))
    }

    private var missionList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Twoje misje")
                .font(.custom("Rubik-SemiBold", size: 16))
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: missionRows) {
                    ForEach(viewModel.missionCards) { card in
                        MissionCardView(
                            image: URL(string: card.image),
                            color: card.color,
                            title: card.title,
                            subtitle: card.subtitle,
                            score: card.score
                        ) {
                            viewModel.showMissionAction(id: card.id)
                        }
                    }
                }
                .padding()
            }
        }
    }

    private var taskList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Twoje zadania")
                .font(.custom("Rubik-SemiBold", size: 16))
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: taskRows) {
                    ForEach(viewModel.taskCards) { card in
                        TaskCardView(
                            color: card.color,
                            title: card.title,
                            subtitle: card.subtitle,
                            score: card.score
                        )
                        .onTapGesture {
                            viewModel.showTaskAction()
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct MissionCardView:  View {
    let image: URL?
    let color: Color
    let title: String
    let subtitle: String
    let score: Int
    let action: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(color)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
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
                    .padding(.top, 11)
                    Spacer()
                    CircularProgressView(
                        progress: CGFloat(0.3),
                        thickness: 7,
                        innerSpacing: 0,
                        content: .text(font: .custom("Rubik-Bold", size: 10))
                    )
                    .frame(width: 49, height: 49)
                    .padding(.top, 11)
                }
                Text(title.uppercased())
                    .font(.custom("Rubik-Bold", size: 16))
                    .foregroundColor(Content.color(.blackWhite))
                    .lineLimit(2)
                Text(subtitle)
                    .font(.custom("Rubik-Regular", size: 12))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Content.color(.blackWhite))
                Spacer()
                ActionButton {
                    action()
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .frame(width: 200)
    }
}

struct TaskCardView:  View {
    let color: Color
    let title: String
    let subtitle: String
    let score: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(color)
            VStack(alignment: .leading) {
                Text("+10 punktów")
                    .font(.custom("Rubik-Regular", size: 12))
                    .foregroundColor(Content.color(.blackWhite))
                Text("Zbieraj deszczówkę do podlewania roślin")
                    .multilineTextAlignment(.leading)
                    .font(.custom("Rubik-Medium", size: 16))
                    .foregroundColor(Content.color(.blackWhite))
                    .padding(.top, 3)
                Spacer()
            }
            .padding()
        }
        .frame(width: 200)
    }
}
