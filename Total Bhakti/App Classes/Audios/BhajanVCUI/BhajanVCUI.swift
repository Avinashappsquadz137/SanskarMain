//
//  BhajanVCUI.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 24/04/26.
//  Copyright © 2026 MAC MINI. All rights reserved.
//

import SwiftUI

struct AudioTrack: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let artist: String
    let categoryID: String
    let categoryName: String
    let imageURL: String
    let mediaURL: String
    let publishedDate: String
}

@MainActor
final class BhajanPlayerViewModel: ObservableObject {
    @Published var categories: [BhajanCategory] = []
    @Published var selectedCategoryID: String = "0"
    @Published var displayedTracks: [AudioTrack] = []
    @Published var latestTrack: AudioTrack?
    @Published var isLoadingCategories = false
    @Published var isLoadingTracks = false
    @Published var errorMessage: String?

    private let latestTrackStorageKey = "bhajan.latest.track.v1"
    private var tracksByCategory: [String: [AudioTrack]] = [:]
    let param: Parameters = ["user_id": currentUser.result?.id ?? "163",
                                         "search":"bage"]
    var categoryChips: [BhajanCategoryChip] {
        let apiChips = categories.map {
            BhajanCategoryChip(id: $0.category_id ?? "", title: $0.title)
        }
        return apiChips.filter { !$0.id.isEmpty }
    }

    init() {
        restoreLatestTrack()
        Task {
            await bootstrap()
        }
    }

    func selectCategory(_ chip: BhajanCategoryChip) {
        selectedCategoryID = chip.id
        Task {
            await loadTracks(for: chip.id)
        }
    }
    func selectTrack(_ track: AudioTrack) {
        latestTrack = track
        persistLatestTrack(track)
        objectWillChange.send()
    }
    

    private func bootstrap() async {
        await fetchCategories()
        await loadTracks(for: "0")
    }

    private func fetchCategories() async {
        isLoadingCategories = true
        errorMessage = nil
        defer { isLoadingCategories = false }

        do {
            let response: BhajanCategoryResponse = try await ApiClient.shared.request(
                endpoint: APIManager.sharedInstance.KBHAJANCATEGORYAPI,
                method: .get,
                parameters: [:],
                isMultipart: false
            )
            guard response.status == true else {
                errorMessage = response.message ?? "Unable to load categories."
                return
            }
            categories = response.data ?? []
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadTracks(for categoryID: String) async {
        if let cachedTracks = tracksByCategory[categoryID] {
            displayedTracks = cachedTracks
            return
        }

        isLoadingTracks = true
        errorMessage = nil
        defer { isLoadingTracks = false }

        do {
            let response: GetBhajanListCategory = try await ApiClient.shared.request(
                endpoint: APIManager.sharedInstance.KBHAJANLISTCATEGORYAPI,
                method: .post,
                parameters: [
                    "user_id":  "\(currentUser.result?.id ?? "163")",
                    "category": categoryID == "1" ? "1" : categoryID,
                    "limit": "100",
                    "page_no": "1"
                ],
                isMultipart: true
            )

            guard response.status == true else {
                errorMessage = response.message ?? "Unable to load bhajan list."
                displayedTracks = []
                return
            }

            let mappedTracks: [AudioTrack] = response.flattenedBhajansWithCategory.map { payload in
                let bhajan = payload.item
                
                return AudioTrack(
                    id: bhajan.id ?? UUID().uuidString,
                    title: bhajan.title?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
                        ? (bhajan.title ?? "")
                        : "Untitled Bhajan",
                    artist: bhajan.artist_name?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
                        ? (bhajan.artist_name ?? "")
                        : "Default Artist",
                    categoryID: bhajan.category ?? categoryID,
                    categoryName: payload.categoryName ?? "Bhajan",
                    imageURL: bhajan.thumbnail1 ?? bhajan.thumbnail2 ?? bhajan.image ?? "",
                    mediaURL: bhajan.media_file ?? "",
                    publishedDate: bhajan.published_date ?? bhajan.creation_time ?? ""
                )
            }
            let finalTracks: [AudioTrack]

            if categoryID == "0" {
                finalTracks = mappedTracks
            } else {
                finalTracks = mappedTracks.filter { $0.categoryID == categoryID }
            }

            tracksByCategory[categoryID] = finalTracks
            displayedTracks = finalTracks
          
        } catch {
            errorMessage = error.localizedDescription
            displayedTracks = []
        }
    }

    private func persistLatestTrack(_ track: AudioTrack) {
        guard let encoded = try? JSONEncoder().encode(track) else { return }
        UserDefaults.standard.set(encoded, forKey: latestTrackStorageKey)
    }

    private func restoreLatestTrack() {
        guard let data = UserDefaults.standard.data(forKey: latestTrackStorageKey),
              let decoded = try? JSONDecoder().decode(AudioTrack.self, from: data) else { return }
        latestTrack = decoded
    }
}

struct BhajanCategoryChip: Identifiable, Hashable {
    let id: String
    let title: String
}

struct BhajanVCUI: View {
    @StateObject private var viewModel = BhajanPlayerViewModel()

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    categorySection
                    latestSection
                    allBhajanSection
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if viewModel.isLoadingCategories {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.categoryChips) { chip in
                        let isSelected = chip.id == viewModel.selectedCategoryID
                        Button {
                            viewModel.selectCategory(chip)
                        } label: {
                            Text(chip.title)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(isSelected ? Color.orange : Color.gray)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(isSelected ? Color.orange.opacity(0.12) : Color(.systemGray5))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(isSelected ? Color.orange.opacity(0.35) : Color.clear, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var latestSection: some View {
        if let latestTrack = viewModel.latestTrack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Continue Listening")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.orange)

                Button {
                    viewModel.selectTrack(latestTrack)
                } label: {
                    ZStack(alignment: .bottomLeading) {
                        trackImageView(urlString: latestTrack.imageURL)
                            .frame(height: 205)
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                        LinearGradient(
                            colors: [Color.black.opacity(0.05), Color.black.opacity(0.65)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                        VStack(alignment: .leading, spacing: 6) {
                            Text(latestTrack.title)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(2)

                            Text(latestTrack.artist)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(16)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var allBhajanSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Bhajan")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.black)

            if viewModel.isLoadingTracks {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(.vertical, 24)
            } else if viewModel.displayedTracks.isEmpty {
                Text(viewModel.errorMessage ?? "No bhajan found for selected category.")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .medium))
                    .padding(.vertical, 24)
            } else {
                LazyVStack(spacing: 14) {
                    ForEach(viewModel.displayedTracks) { track in
                        Button {
                            viewModel.selectTrack(track)
                        } label: {
                            HStack(spacing: 12) {
                                trackImageView(urlString: track.imageURL)
                                    .frame(width: 74, height: 74)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(track.title)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.black)
                                        .lineLimit(1)

                                    Text(track.artist)
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.gray)
                                        .lineLimit(1)

                                    Text(track.artist)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.orange)
                                        .lineLimit(1)
                                }

                                Spacer()

                                Image(systemName: "play.circle")
                                    .font(.system(size: 30, weight: .regular))
                                    .foregroundColor(.orange)
                            }
                            .padding(.horizontal, 2)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func trackImageView(urlString: String) -> some View {
        if let url = URL(string: urlString), !urlString.isEmpty {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    Color(.systemGray5)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    fallbackImage
                @unknown default:
                    fallbackImage
                }
            }
        } else {
            fallbackImage
        }
    }

    private var fallbackImage: some View {
        ZStack {
            Color(.systemGray5)
            Image(systemName: "music.note")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}
