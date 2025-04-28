//
//  ContentView.swift
//  Countries
//
//  Created by Satoru Ishii on 4/27/25.
//

import SwiftUI

struct CountriesView: View {
    @EnvironmentObject var viewModel : CountriesViewModel

    var body: some View {
        VStack {
            Text("Countries")
                .font(.title2)
            List {
                countrySection
            }
        }
        .padding()
        .onAppear {
            viewModel.getCountries()
        }
    }
}

private extension CountriesView {
    var countrySection : some View {
        Section {
            if self.viewModel.countries != nil {
                ForEach(self.viewModel.countries!, id: \.name) { country in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(country.name + ",")
                            Text(country.region)
                            Text(country.code)
                        }
                        Text(country.capital)
                    }
                }
            }
        }
    }
}

#Preview {
    CountriesView()
}
