import SwiftUI
import Content

enum TabType: CaseIterable {
    case all, songs, albums, artists, playlists

    var title: String {
        switch self {
        case .all: return Content.copy("generic.all")
        case .songs: return Content.copy("generic.songs")
        case .albums: return Content.copy("generic.albums")
        case .artists: return Content.copy("generic.artists")
        case .playlists: return Content.copy("generic.playlists")
        }
    }
}

struct TabsView: View {
    let tabs: [TabType]
    @Binding var selectedTab: TabType

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(tabs, id: \.self) { tab in
                    tabView(title: tab.title, isSelected: selectedTab == tab)
                        .onTapGesture { selectedTab = tab }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func tabView(title: String, isSelected: Bool) -> some View {
        ZStack(alignment: .bottom) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Content.color(isSelected ? .blackWhite : .blackLight))
                .padding(.top, 13)
                .padding(.bottom, 10)
            if isSelected {
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Content.color(.blackWhite))
                    .cornerRadius(2, corners: [.topLeft, .topRight])
            }
        }
    }
}
