//
//  CountriesViewModel.swift
//  Countries
//
//  Created by Satoru Ishii on 4/27/25.
//

import Foundation
import Combine

/// for Combine Subscribe Failure Throws in NYCSchoolsViewModel, SATResultsViewModel
public enum CountriesError : Error {
    case getCountriesFailure
}

final class CountriesViewModel : ObservableObject {
    static var shared = CountriesViewModel()
    @Published var countries : [CountriesResponse]?

    let countriesAPI = CountriesAPI()
    private var disposables = Set<AnyCancellable>()
    
    init() {}
    
    func getCountries() {
        countriesAPI.getCountries()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { print("sink guard nil"); return }
                    switch value {
                    case .failure:
                        self.countries = nil
                        do {
                            try self.getCountriesFailure()
                        } catch {
                            print("get Countries Failure")
                        }
                    case .finished:
                        /// print("sink finished")
                        break
                    }
                },
                receiveValue: { [weak self] countriesResponses in
                    /// getting API responses
                    self!.countries = countriesResponses
                })
            .store(in: &disposables)
    }
    
    func getCountriesFailure() throws -> Void {
        throw CountriesError.getCountriesFailure
    }
}
