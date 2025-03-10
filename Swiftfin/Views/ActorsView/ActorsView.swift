//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2025 Jellyfin & Jellyfin Contributors
//

import JellyfinAPI
import SwiftUI

struct ActorsView: View {
    
    @EnvironmentObject
    private var router: ActorsCoordinator.Router
    
    @StateObject
    private var viewModel: ActorsViewModel
    
    init() {
        let viewModel = ActorsViewModel(
            title: L10n.actor,
            id: "actors",
            filters: .default
        )
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        PagingLibraryView(viewModel: viewModel)
            .navigationTitle(L10n.actor)
    }
}