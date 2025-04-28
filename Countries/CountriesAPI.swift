//
//  CountriesAPI.swift
//  Countries
//
//  Created by Satoru Ishii on 4/27/25.
//

import Foundation
import Combine

enum APIError: Error {
    case network(description: String)
    case decoding(description: String)
}

protocol CountriesAPIConnectable {
    func getCountries() -> AnyPublisher<[CountriesResponse], APIError>
}

class CountriesAPI : CountriesAPIConnectable {
    
    ///
    func getCountries() -> AnyPublisher<[CountriesResponse], APIError> {
        let jsonUrlComp = self.makeGetCountriesJsonUrl()
        return fetchCountriesJson(urlComponents: jsonUrlComp)
    }
    
    ///
    private func makeGetCountriesJsonUrl() -> URLComponents {
        var urlComp = URLComponents()
        urlComp.scheme = Constants.Scheme
        urlComp.host = Constants.Host
        urlComp.path = Constants.Path
        return urlComp
    }
    
    /// Fetching Countries Json
    private func fetchCountriesJson(urlComponents components: URLComponents) -> AnyPublisher<[CountriesResponse], APIError> {
        guard let url = components.url else {
            let error = APIError.network(description: "Can't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        /// Fetching and Publishing
        return URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                    .network(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { pair in
                self.decode(pair.data)
            }
            .eraseToAnyPublisher()
    }
    
    ///
    private func decode(_ data: Data) -> AnyPublisher<[CountriesResponse], APIError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return Just(data)
            .decode(type: [CountriesResponse].self, decoder: decoder)
            .mapError { error in
                    .decoding(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
