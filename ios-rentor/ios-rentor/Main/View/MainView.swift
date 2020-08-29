//
//  MainView.swift
//  ios-rentor
//
//  Created by Thomas on 29/08/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            SimmulatorView()
            .tabItem {
                Image("sliders")
                Text("Simulations")
            }
            SettingView()
            .tabItem {
                Image("settings")
                Text("Settings")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}