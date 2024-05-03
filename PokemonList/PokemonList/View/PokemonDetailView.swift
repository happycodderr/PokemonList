//
//  PokemonDetailView.swift
//  PokemonList
//
//  Created by Geethanjali Gopala Krishnan on 02/05/2024.
//

import SwiftUI

struct PokemonDetailView: View {
    @StateObject var viewModel: PokemonDetailViewModel = PokemonDetailViewModel()
    
    var pokemonDetailPath: String
    
    var body: some View {
        ScrollView {
            VStack {
                if let pokemon = viewModel.pokemon {
                    Text(pokemon.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .accessibilityAddTraits(.isHeader)
                    // arrange the list of sprites in horizontal scrollview
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(0..<viewModel.imageArray.count, id: \.self) { index in
                                AsyncImage(url: URL(string: viewModel.imageArray[index])) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 250, height: 250)
                                        .accessibilityHidden(true)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                    .padding(.all, 15)
                    
                    Text("Statistics of \(pokemon.name)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ForEach(pokemon.stats) { stat in
                        VStack(spacing: 10) {
                            Text(stat.stat.name)
                                .font(.title3)
                                .fontWeight(.bold)
                            Text(stat.stat.url)
                        }
                        Spacer().frame(height: 20)
                    }
                } else {
                    ProgressView()
                }
            }
        }
        .task {
            await viewModel.fetchPokemonDetail(urlString: pokemonDetailPath)
        }
        .padding([.top, .bottom], 20)
    }
}

#Preview {
    PokemonDetailView( pokemonDetailPath: "https://pokeapi.co/api/v2/pokemon/1/")
}
