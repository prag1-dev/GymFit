//
//  Gym_FitApp.swift
//  Gym Fit
//
//  Created by Pragyat Agrawal on 11/12/25.
//

import SwiftUI

@main
struct Gym_FitApp: App {
    var body: some Scene {
        WindowGroup {
            if OnboardingManager.shared.hasCompletedOnboarding {
                MainTabContainerView()
            } else {
                OnboardingView()
            }
        }
    }
}
