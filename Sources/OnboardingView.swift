//
//  OnboardingView.swift
//  Gym Fit
//
//  Created by Pragyat Agrawal on 11/12/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage: Int = 0
    @State private var hasCompletedOnboarding = false
    
    private let totalPages = 3
    
    var body: some View {
        onboardingContent
    }
    
    private var onboardingContent: some View {
        VStack(spacing: 0) {
            // Page Content
            TabView(selection: $currentPage) {
                WelcomePageView()
                    .tag(0)
                
                HowItWorksPageView()
                    .tag(1)
                
                GetStartedPageView(onGetStarted: {
                    completeOnboarding()
                })
                .tag(2)
            }
#if !os(macOS)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
#endif
            
            // Page Indicator and Navigation
            HStack {
                // Skip button (only on first 2 pages)
                if currentPage < totalPages - 1 {
                    Button(action: {
                        HapticFeedback.impact(style: .light)
                        completeOnboarding()
                    }) {
                        Text("Skip")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading, 20)
                } else {
                    Spacer()
                        .frame(width: 60)
                }
                
                Spacer()
                
                // Page Indicators
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                
                Spacer()
                
                // Next/Get Started button
                Button(action: {
                    HapticFeedback.impact(style: .medium)
                    if currentPage < totalPages - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        completeOnboarding()
                    }
                }) {
                    Text(currentPage < totalPages - 1 ? "Next" : "Get Started")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(minWidth: 100)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.trailing, 20)
            }
            .padding(.vertical, 20)
#if canImport(UIKit)
            .background(Color(UIColor.systemBackground))
#elseif canImport(AppKit)
            .background(Color(NSColor.windowBackgroundColor))
#else
            .background(Color.background)
#endif
        }
    }
    
    private func completeOnboarding() {
        OnboardingManager.shared.completeOnboarding()
        HapticFeedback.notification(type: .success)
        withAnimation {
            hasCompletedOnboarding = true
        }
    }
}

struct WelcomePageView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "figure.run.circle.fill")
                    .font(.system(size: 64, weight: .medium))
                    .foregroundColor(.blue)
            }
            
            // Title
            VStack(spacing: 12) {
                Text("Welcome to GymFit")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Your Personal AI Fitness Trainer")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Features
            VStack(spacing: 24) {
                FeatureRow(
                    icon: "sparkles",
                    title: "AI-Powered Workouts",
                    description: "Get personalized workout plans generated by AI"
                )
                
                FeatureRow(
                    icon: "message.fill",
                    title: "Chat with Your Trainer",
                    description: "Ask questions and get instant fitness advice"
                )
                
                FeatureRow(
                    icon: "clock.arrow.circlepath",
                    title: "Workout History",
                    description: "Track your progress and revisit past workouts"
                )
            }
            .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}

struct HowItWorksPageView: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Title
            VStack(spacing: 12) {
                Text("How It Works")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Get your perfect workout in 3 simple steps")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            // Steps
            VStack(spacing: 32) {
                StepRow(
                    number: 1,
                    icon: "square.grid.2x2.fill",
                    title: "Select Equipment",
                    description: "Choose the equipment you have available at your gym"
                )
                
                StepRow(
                    number: 2,
                    icon: "figure.arms.open",
                    title: "Choose Body Parts",
                    description: "Pick the muscle groups you want to target"
                )
                
                StepRow(
                    number: 3,
                    icon: "clock.fill",
                    title: "Set Duration",
                    description: "Select how long you want your workout to be"
                )
            }
            .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}

struct GetStartedPageView: View {
    let onGetStarted: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green.opacity(0.2), Color.green.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64, weight: .medium))
                    .foregroundColor(.green)
            }
            
            // Title
            VStack(spacing: 16) {
                Text("Let's Get Started!")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("You're all set to create your first personalized workout plan")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            // Benefits
            VStack(spacing: 20) {
                BenefitRow(
                    icon: "bolt.fill",
                    text: "Get instant workout recommendations"
                )
                
                BenefitRow(
                    icon: "heart.fill",
                    text: "Designed for your fitness goals"
                )
                
                BenefitRow(
                    icon: "star.fill",
                    text: "AI-powered personalization"
                )
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct StepRow: View {
    let number: Int
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 20) {
            // Number badge
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 44, height: 44)
                
                Text("\(number)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Icon
            Image(systemName: icon)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 40)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.green)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

class OnboardingManager {
    static let shared = OnboardingManager()
    
    private let userDefaults = UserDefaults.standard
    private let hasCompletedOnboardingKey = "hasCompletedOnboarding"
    
    var hasCompletedOnboarding: Bool {
        userDefaults.bool(forKey: hasCompletedOnboardingKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: hasCompletedOnboardingKey)
    }
    
    func resetOnboarding() {
        userDefaults.set(false, forKey: hasCompletedOnboardingKey)
    }
    
    private init() {}
}

#Preview {
    OnboardingView()
}

