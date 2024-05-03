//
//  PokemonListView.swift
//  PokemonList
//
//  Created by Geethanjali Gopala Krishnan on 02/05/2024.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject var viewModel = PokemonListViewModel()
    @State var isAlertPresented = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.viewState {
                case .loading:
                    ProgressView()
                case .loaded:
                    loadPokemonList()
                case .error:
                    showErrorAlert()
                }
            }
            .navigationTitle("Pokemon List")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchPokemonList(urlString: APIEndPoint.pokemonURL)
                if viewModel.networkErrors != nil {
                    isAlertPresented = true
                }
            }
        }
    }
    
    @ViewBuilder
    func loadPokemonList() -> some View {
        VStack {
            Text("Please select or search for a Pokemon to get the detailed Statistics")
                .font(.title2)
                .fontWeight(.semibold)
                .accessibilityAddTraits(.isHeader)
            List(viewModel.filteredPokemons) { pokemon in
                NavigationLink (destination: PokemonDetailView( pokemonDetailPath: pokemon.url)) {
                    HStack {
                        AsyncImage(url: URL(string: viewModel.getImagePath(urlString: pokemon.url))) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        Text(pokemon.name)
                    } // Get the image of the pokemon and the name of the pokemon
                    .padding(.horizontal, 10)
                }
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) {
                oldValue, newValue in
                viewModel.filterPokemon(newValue)
            }
        }
    }
    
    @ViewBuilder
    func showErrorAlert() -> some View {
        ProgressView()
            .alert(
                isPresented: $isAlertPresented)
        {
            Alert(
                title: Text("Service Error"),
                message: Text("Data not found"),
                dismissButton: .default(Text("Dismiss"))
            )
        }
    }
}

#Preview {
    PokemonListView()
}
