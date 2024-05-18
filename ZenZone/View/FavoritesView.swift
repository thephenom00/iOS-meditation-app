import SwiftUI

struct FavoritesView: View {
    @ObservedObject var meditationViewModel: MeditationViewModel

    var body: some View {
        VStack {
            HStack {
                Text("Liked Meditations")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.top, 20)
                Spacer()
            }
            .padding(.horizontal)

            HStack {
                Text("\(meditationViewModel.meditations.filter { $0.isLiked }.count) meditations")
                    .foregroundColor(.black)

                Spacer()
            }
            .padding(.horizontal)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(meditationViewModel.meditations.filter { $0.isLiked }) { meditation in
                        HStack {
                            Image(meditation.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Rectangle())
                                .shadow(radius: 1)
                            VStack(alignment: .leading) {
                                Text(meditation.name)
                                    .foregroundColor(.black)
                                    .font(.headline)
                                Text(meditation.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                            }
                            Spacer()
                            Text(meditationViewModel.formatTime(timeInterval: meditation.duration))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Button {
                                meditationViewModel.likeMeditation(meditation: meditation)
                            } label: {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 25))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }
                .padding()
            }
        }
        .background(Color.cream.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    FavoritesView(meditationViewModel: MeditationViewModel())
}
