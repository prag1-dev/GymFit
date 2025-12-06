//
//  MainTabContainerView.swift
//  Gym Fit
//
//  Created by Cursor on 11/16/25.
//

import SwiftUI

struct MainTabContainerView: View {
    @State private var selectedTab: Tab = .coach
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content driven by selectedTab
            Group {
                switch selectedTab {
                case .workout:
                    NavigationStack {
                        BodyPartRecommendationView()
#if !os(macOS)
                            .navigationBarHidden(true)
#endif
                    }
                case .history:
                    NavigationStack {
                        WorkoutHistoryView()
                    }
                case .coach:
                    NavigationStack {
                        AICoachView()
                    }
                case .calendar:
                    NavigationStack {
                        CalendarView()
                    }
                case .settings:
                    NavigationStack {
                        SettingsView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Static bottom tab bar
            TabBarView(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    MainTabContainerView()
}

