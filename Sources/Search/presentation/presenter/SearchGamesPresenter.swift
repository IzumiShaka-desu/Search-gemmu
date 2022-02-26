//
//  SearchGamesPresenter.swift
//  Gemmu
//
//  Created by Akashaka on 19/02/22.
//

import SwiftUI
import Combine

public class SearchGamesPresenter: ObservableObject {

  private var cancellables: Set<AnyCancellable> = []
  private let router: SearchRouterBase
  private let searchUseCase: SearchGamesUseCase

  @Published var results: [SearchItemResultEntity] = []
  @Published var errorMessage: String = ""
  @Published var isLoading: Bool = false
  @Published var isError: Bool = false
  @Published var query = ""

  init(searchUseCase: SearchGamesUseCase, router: SearchRouterBase) {
    self.searchUseCase = searchUseCase
    self.router = router
  }

  func searchGames() {
    isLoading = true
    searchUseCase.searchGames(for: query)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isError = true
          self.isLoading = false
        case .finished:
          self.isLoading = false
        }
      }, receiveValue: { result in
        self.results=result.results
      })
      .store(in: &cancellables)
  }

  func linkBuilder<Content: View>(
    for id: Int,
    @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(
      destination: router.makeDetailView(for: id)) { content() }
    .padding(0)
    .buttonStyle(PlainButtonStyle())
  }

}
