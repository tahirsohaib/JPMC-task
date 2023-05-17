//
//  PlanetDetailsView.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 17/05/2023.
//

import SwiftUI

struct PlanetDetailsView: View {
    @Binding var planet: PlanetModel?
    
    var body: some View {
        Text(planet?.name ?? "")
    }
}

struct PlanetDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetDetailsView(planet: .constant(PlanetModel.mockPlanetModel1))
    }
}
