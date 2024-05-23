//
//  FactsView.swift
//  Factorial
//
//  Created by Тимофей Юдин on 22.05.2024.
//

import SwiftUI

@MainActor
final class FactsViewModel: ObservableObject {
    @Published private(set) var facts: [Fact] = []
    
    func getAllFacts() async throws {
        self.facts = try await FactsManager.shared.getAllFacts()
    }
}

struct FactsView: View {
    @StateObject private var viewModel = FactsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.facts) { fact in
                        Text(fact.text ?? "n/a")
                    }
                }
                .navigationTitle("Факты")
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    try? await viewModel.getAllFacts()
                }
            }
        }
    }
}

#Preview {
    FactsView()
}
