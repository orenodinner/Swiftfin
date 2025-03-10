//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2025 Jellyfin & Jellyfin Contributors
//

import Combine
import Foundation
import JellyfinAPI
import OrderedCollections

final class ActorsViewModel: PagingLibraryViewModel<BaseItemPerson> {

    // MARK: get

    override func get(page: Int) async throws -> [BaseItemPerson] {
        let parameters = actorParameters(for: page)
        let request = Paths.getPersons(parameters: parameters)
        let response = try await userSession.client.send(request)

        return response.value.items ?? []
    }

    // MARK: actor parameters

    private func actorParameters(for page: Int?) -> Paths.GetPersonsParameters {
        var parameters = Paths.GetPersonsParameters()

        parameters.enableImageTypes = [.primary]
        parameters.enableTotalRecordCount = true

        // Page size
        if let page {
            parameters.limit = pageSize
            parameters.startIndex = page * pageSize
        }

        // Filters
        if let filterViewModel {
            let filters = filterViewModel.currentFilters
            parameters.sortBy = filters.sortBy.map(\.rawValue)
            parameters.sortOrder = filters.sortOrder

            if filters.letter.first?.value == "#" {
                parameters.nameLessThan = "A"
            } else {
                parameters.nameStartsWith = filters.letter
                    .map(\.value)
                    .filter { $0 != "#" }
                    .first
            }
        } else {
            parameters.sortBy = [ItemSortBy.sortName.rawValue]
            parameters.sortOrder = [.ascending]
        }

        return parameters
    }

    // MARK: getRandomItem

    override func getRandomItem() async -> BaseItemPerson? {
        var parameters = actorParameters(for: nil)
        parameters.limit = 1
        parameters.sortBy = [ItemSortBy.random.rawValue]

        let request = Paths.getPersons(parameters: parameters)
        let response = try? await userSession.client.send(request)

        return response?.value.items?.first
    }
}
